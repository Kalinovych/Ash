/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flashrush.asentity.framework.core.IComponentNotifier;

import flashrush.asentity.extensions.ECSigner;
import flashrush.asentity.framework.core.ESpace;
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.core.ProcessingLock;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityObserver;
import flashrush.collections.LLNode;
import flashrush.collections.LinkedMap;
import flashrush.collections.list_internal;
import flashrush.signatures.bitwise.api.IBitSignature;

use namespace asentity;

public class AspectManager implements IAspectManager, IEntityObserver {
	private var space:ESpace;
	private var processingLock:ProcessingLock;
	private var families:LinkedMap/*<NodeClass, AspectObserver>*/ = new LinkedMap();
	private var _signer:ECSigner;
	
	public function AspectManager( space:ESpace, processingLock:ProcessingLock ) {
		this.space = space;
		this.processingLock = processingLock;
		
		_signer = new ECSigner();
		
		space.OnEntityAdded.add( onEntityAdded );
		space.OnEntityRemoved.add( onEntityRemoved );
		
		//entitySpace.registerHandler( _signer );
		//entitySpace.registerHandler( this );
	}
	
	public function getAspects( aspectDefinition:Class ):AspectList {
		var family:AspectFamily = families.get( aspectDefinition );
		if ( !family ) {
			family = createFamily( aspectDefinition );
			families.put( aspectDefinition, family );
		}
		return family.aspects;
	}
	
	/** @private **/
	public function onEntityAdded( entity:Entity ):void {
		trace( "[AspectsManager.onEntityAdded]›", entity );
		
		for ( var node:LLNode = families.firstNode; node; node = node.nextNode ) {
			const family:AspectFamily = node.list_internal::item;
			if ( $entityMatchAspect( entity, family ) ) {
				family.addQualifiedEntity( entity );
			}
		}
	}
	
	/** @private **/
	public function onEntityRemoved( entity:Entity ):void {
		for ( var node:LLNode = families.firstNode; node; node = node.list_internal::next ) {
			const family:AspectFamily = node.list_internal::item;
			if ( entity in family.aspectByEntity ) {
				family.removeQualifiedEntity( entity );
			}
			/*if ( $entityMatchAspect( entity, family ) ) {
				family.removeQualifiedEntity( entity );
			}*/
		}
		//_signer.disposeSign( sign );
		//entity._sign = null;
	}
	
	//-------------------------------------------
	// Protected methods
	//-------------------------------------------
	
	/** @private **/
	protected final function createFamily( aspectDefinition:Class ):AspectFamily {
		const aspectInfo:AspectInfo = AspectUtil.getInfo( aspectDefinition );
		const family:AspectFamily = new AspectFamily( aspectInfo, processingLock );
		
		// helpers
		var field:AspectField;
		var i:int;
		
		// sign
		const sign:IBitSignature = _signer.signer.signEmpty() as IBitSignature;
		const excludedSign:IBitSignature = ( aspectInfo.hasExcluded ? _signer.signer.signEmpty() as IBitSignature : null );
		for ( i = 0; i < aspectInfo.fieldCount; i++ ) {
			field = aspectInfo.fieldList[i];
			const flag:int = _signer.signer.provideFlag( field.type );
			field.isExcluded ? excludedSign.set( flag ) : sign.set( flag );
		}
		family.sign = sign;
		family.excludedSign = excludedSign;
		
		// scan space for an entities that match the aspect
		for ( var entity:Entity = space.entities.first; entity; entity = entity.next ) {
			if ( $entityMatchAspect( entity, family ) ) {
				family.addQualifiedEntity( entity );
			}
		}
		
		// register family as an observer of components of described types.
		const componentNotifier:IComponentNotifier = space.componentNotifier;
		for ( i = 0; i < aspectInfo.fieldCount; i++ ) {
			field = aspectInfo.fieldList[i];
			componentNotifier.addObserver( field.type, family );
		}
		
		return family;
	}
	
	[Inline]
	protected final function $entityMatchAspect( entity:Entity, aspect:AspectFamily ):Boolean {
		return ( entity._sign.hasAllOf( aspect.sign ) && !( aspect.excludedSign && entity._sign.hasAllOf( aspect.excludedSign ) ) );
	}
}
}
