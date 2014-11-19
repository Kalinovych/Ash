/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flashrush.asentity.extensions.aspects.FamilyNode;
import flashrush.asentity.extensions.componentHandlerMap.api.IComponentHandlerMap;
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.core.ConsistencyLock;
import flashrush.asentity.framework.core.EntitySpace;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityProcessor;
import flashrush.asentity.framework.utils.BitFactory;
import flashrush.asentity.framework.utils.BitSign;
import flashrush.collections.LinkedMap;
import flashrush.collections.LLNodeBase;
import flashrush.collections.list_internal;

use namespace asentity;

public class AspectManager implements IAspectManager, IEntityProcessor {
	private var _space:EntitySpace;
	private var componentHandlerMap:IComponentHandlerMap;
	private var consistencyLock:ConsistencyLock;
	private var families:LinkedMap/*<NodeClass, AspectFamily>*/ = new LinkedMap();
	//private var ecSigner:ECSigner = new ECSigner();
	
	private var signer:BitFactory = new BitFactory();
	
	public function AspectManager( space:EntitySpace, componentHandlerMap:IComponentHandlerMap, consistencyLock:ConsistencyLock = null ) {
		this._space = space;
		this.componentHandlerMap = componentHandlerMap;
		this.consistencyLock = consistencyLock;
		
		//_space.addEntityHandler( ecSigner );
		_space.addEntityHandler( this );
	}
	
	public final function get space():EntitySpace {
		return _space;
	}
	
	public function getAspects( type:Class ):AspectList {
		var family:AspectFamily = families.get( type );
		if ( !family ) {
			family = createFamily( type );
			families.put( type, family );
		}
		return family.aspects;
	}
	
	/** @private **/
	public function processAddedEntity( entity:Entity ):void {
		for (var familyNode:FamilyNode = families.firstNode as FamilyNode; familyNode; familyNode = familyNode.next ) {
			if ($entityMatchAspect(entity, familyNode.family)) {
				familyNode.family.addQualifiedEntity( entity );
			}
		}
		
		/*use namespace list_internal;
		
		for ( var node:LLNodeBase = families.first; node; node = node.next ) {
			const family:AspectFamily = node.item;
			if ( $entityMatchAspect( entity, family ) ) {
				family.addQualifiedEntity( entity );
			}
		}*/
	}
	
	/** @private **/
	public function processRemovedEntity( entity:Entity ):void {
		use namespace list_internal;
		
		for ( var node:LLNodeBase = families.first; node; node = node.next ) {
			const family:AspectFamily = node.item;
			if ( family.aspectByEntity[entity] ) {
				family.removeQualifiedEntity( entity );
			}
		}
		//ecSigner.disposeSign( sign );
		//entity._sign = null;
	}

//-------------------------------------------
//Protected methods
//-------------------------------------------
	
	/** @private **/
	protected final function createFamily( aspectType:Class ):AspectFamily {
		const aspectInfo:AspectInfo = AspectDescriber.describe( aspectType );
		const family:AspectFamily = new AspectFamily( aspectInfo, consistencyLock );
		
		// helpers
		var trait:AspectTrait;
		var i:int;
		
		// sign
		const requiredBits:BitSign = signer.signNone();
		const mask:BitSign = signer.signAll();
		for ( i = 0; i < aspectInfo.traitCount; i++ ) {
			trait = aspectInfo.traits[i];
			switch ( trait.kind ) {
				case AspectTrait.REQUIRED:
					requiredBits.add( trait.type );
					break;
				case AspectTrait.OPTIONAL:
					break;
				case AspectTrait.EXCLUDED:
					mask.remove( trait.type );
					break;
			}
			//trait.isExcluded ? mask.remove( trait.type ) : requiredBits.add( trait.type );
		}
		family.bits = requiredBits;
		family.mask = mask;
		
		// scan space for an entities that match the aspect
		_space.filterEntities( requiredBits, mask, family.addQualifiedEntity );
		/*for ( var entity:Entity = _space.firstEntity; entity; entity = entity.next ) {
			if ( $entityMatchAspect( entity, family ) ) {
				family.addQualifiedEntity( entity );
			}
		}*/
		
		// register family as an observer of components of described types.
		for ( i = 0; i < aspectInfo.traitCount; i++ ) {
			componentHandlerMap.map( aspectInfo.traits[i].type ).toHandler( family );
		}
		
		return family;
	}
	
	[Inline]
	protected final function $entityMatchAspect( entity:Entity, aspect:AspectFamily ):Boolean {
		return entity.componentBits.hasAllOf( aspect.bits, aspect.mask );
		//return ( entity.componentBits.hasAllOf( aspect.bits ) && !( aspect.mask && entity.componentBits.hasAllOf( aspect.mask ) ) );
	}
}
}
