/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flashrush.asentity.extensions.ECSigner;
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.core.IComponentNotifier;
import flashrush.asentity.framework.core.ConsistencyLock;
import flashrush.asentity.framework.core.EntitySpace;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityObserver;
import flashrush.asentity.framework.utils.ElementBits;
import flashrush.asentity.framework.utils.BitFactory;
import flashrush.collections.LinkedMap;
import flashrush.collections.base.LLNodeBase;
import flashrush.collections.list_internal;
import flashrush.signatures.bitwise.api.IBitSignature;

use namespace asentity;

public class AspectManager implements IAspectManager, IEntityObserver {
	private var _space:EntitySpace;
	private var componentNotifier:IComponentNotifier;
	private var consistencyLock:ConsistencyLock;
	private var families:LinkedMap/*<NodeClass, AspectFamily>*/ = new LinkedMap();
	private var ecSigner:ECSigner = new ECSigner();
	
	private var signer:BitFactory = new BitFactory();
	
	public function AspectManager( space:EntitySpace, componentNotifier:IComponentNotifier, consistencyLock:ConsistencyLock = null ) {
		this._space = space;
		this.componentNotifier = componentNotifier;
		this.consistencyLock = consistencyLock;
		
		_space.addEntityHandler( ecSigner );
		_space.addEntityHandler( this );
		
		//space.OnEntityAdded.add( ecSigner.onEntityAdded );
		//space.OnEntityRemoved.add( ecSigner.onEntityRemoved );
		
		//space.OnEntityAdded.add( onEntityAdded );
		//space.OnEntityRemoved.add( onEntityRemoved );
		
		//entitySpace.registerHandler( ecSigner );
		//entitySpace.registerHandler( this );
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
	public function onEntityAdded( entity:Entity ):void {
		use namespace list_internal;
		
		for ( var node:LLNodeBase = families.first; node; node = node.next ) {
			const family:AspectFamily = node.item;
			if ( $entityMatchAspect( entity, family ) ) {
				family.addQualifiedEntity( entity );
			}
		}
	}
	
	/** @private **/
	public function onEntityRemoved( entity:Entity ):void {
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
	// Protected methods
	//-------------------------------------------
	
	/** @private **/
	protected final function createFamily( aspectType:Class ):AspectFamily {
		const aspectInfo:AspectInfo = AspectUtil.getInfo( aspectType );
		const family:AspectFamily = new AspectFamily( aspectInfo, consistencyLock );
		
		// helpers
		var trait:FamilyTrait;
		var i:int;
		
		// sign
		const requiredBits:ElementBits = signer.signNone();
		const mask:ElementBits = signer.signAll();
		for ( i = 0; i < aspectInfo.traitCount; i++ ) {
			trait = aspectInfo.traits[i];
			switch ( trait.kind ) {
				case FamilyTrait.REQUIRED:
					requiredBits.add( trait.type );
					break;
				case FamilyTrait.OPTIONAL:
					break;
				case FamilyTrait.EXCLUDED:
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
		const componentNotifier:IComponentNotifier = componentNotifier;
		for ( i = 0; i < aspectInfo.traitCount; i++ ) {
			componentNotifier.addComponentHandler( family, aspectInfo.traits[i].type );
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
