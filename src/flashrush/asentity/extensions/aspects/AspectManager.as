/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flashrush.asentity.extensions.ECSigner;
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.core.IComponentNotifier;
import flashrush.asentity.framework.core.ProcessingLock;
import flashrush.asentity.framework.core.Space;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityObserver;
import flashrush.collections.LinkedMap;
import flashrush.collections.base.LLNodeBase;
import flashrush.collections.list_internal;
import flashrush.signatures.bitwise.api.IBitSignature;

use namespace asentity;

public class AspectManager implements IAspectManager, IEntityObserver {
	private var space:Space;
	private var processingLock:ProcessingLock;
	private var families:LinkedMap/*<NodeClass, AspectObserver>*/ = new LinkedMap();
	private var signer:ECSigner = new ECSigner();
	
	public function AspectManager( space:Space, processingLock:ProcessingLock ) {
		this.space = space;
		this.processingLock = processingLock;
		
		space.OnEntityAdded.add( signer.onEntityAdded );
		space.OnEntityRemoved.add( signer.onEntityRemoved );
		
		space.OnEntityAdded.add( onEntityAdded );
		space.OnEntityRemoved.add( onEntityRemoved );
		
		//entitySpace.registerHandler( signer );
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
			if ( entity in family.aspectByEntity ) {
				family.removeQualifiedEntity( entity );
			}
			/*if ( $entityMatchAspect( entity, family ) ) {
				family.removeQualifiedEntity( entity );
			}*/
		}
		//signer.disposeSign( sign );
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
		const sign:IBitSignature = signer.signer.signEmpty() as IBitSignature;
		const excludedSign:IBitSignature = ( aspectInfo.hasExcluded ? signer.signer.signEmpty() as IBitSignature : null );
		for ( i = 0; i < aspectInfo.fieldCount; i++ ) {
			field = aspectInfo.fieldList[i];
			const flag:int = signer.signer.provideFlag( field.type );
			field.isExcluded ? excludedSign.set( flag ) : sign.set( flag );
		}
		family.sign = sign;
		family.excludedSign = excludedSign;
		
		// scan space for an entities that match the aspect
		for ( var entity:Entity = space.firstEntity; entity; entity = entity.next ) {
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
