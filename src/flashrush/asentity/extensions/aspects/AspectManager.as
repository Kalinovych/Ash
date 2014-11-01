/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import ecs.engine.components.IComponentObserver;

import flashrush.asentity.extensions.ECSigner;
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.EntityCollection;
import flashrush.asentity.framework.entity.api.IEntityHandler;
import flashrush.ds.ds_internal;
import flashrush.gdf.api.gdf_core;
import flashrush.ds.LinkedMap;
import flashrush.ds.Node;
import flashrush.signatures.api.ISignature;

use namespace asentity;
use namespace gdf_core;

public class AspectManager implements IAspectManager, IEntityHandler {
	private var entities:EntityCollection;
	private var componentManager:IComponentObserver;
	private var aspectObservers:LinkedMap/*<NodeClass, AspectObserver>*/ = new LinkedMap();
	private var _signer:ECSigner;
	//private var signTable:Vector.<ISignature>;

	public function AspectManager( entities:EntityCollection, componentManager:IComponentObserver ) {
		this.entities = entities;
		this.componentManager = componentManager;

		_signer = new ECSigner();
		//signTable = new Vector.<ISignature>( entities.entityCount );

		entities.registerHandler( _signer );
		entities.registerHandler( this );
	}

	public function getAspects( aspectClass:Class ):AspectList {
		var observer:AspectObserver = aspectObservers.get( aspectClass );
		if ( !observer ) {
			observer = createObserver( aspectClass );
			aspectObservers.put( aspectClass, observer );
		}
		return observer.aspects;
	}

	/** @private **/
	public function handleEntityAdded( entity:Entity ):void {
		trace( "[AspectsManager.onEntityAdded]›", entity );
		//entity.sign = _signer.signKeys( entity.components );

		var id:uint = entity._id;
		/*if ( signTable.length <= id ) {
			signTable.length = id + 1;
		}
		var sign:ISignature = _signer.signKeys( entity._components );
		signTable[id] = sign;*/

		for ( var node:Node = aspectObservers.ds_internal::$firstNode; node; node = node.next ) {
			var observer:AspectObserver = node.item;
			if ( $signMatchAspect( entity._sign, observer ) ) {
				observer.registerEntity( entity );
			}
		}
	}

	/** @private **/
	public function handleEntityRemoved( entity:Entity ):void {
		//var sign:ISignature = signTable[entity._id];
		var sign:ISignature = entity._sign;
		for ( var node:Node = aspectObservers.ds_internal::$firstNode; node; node = node.next ) {
			var observer:AspectObserver = node.item;
			if ( $signMatchAspect( sign, observer ) ) {
				observer.unRegisterEntity( entity );
			}
		}
		//_signer.disposeSign( sign );
		//entity._sign = null;
	}

	/** @private **/
	protected final function createObserver( aspectClass:Class ):AspectObserver {
		var observer:AspectObserver = new AspectObserver( aspectClass );
		observer.sign = _signer.signer.signKeys( observer.propertyMap );
		if ( observer.excludedComponents ) {
			observer.exclusionSign = _signer.signer.signKeys( observer.excludedComponents );
		}

		// check all entities that are already in the list
		for ( var entity:Entity = entities.first; entity; entity = entity.next ) {
			//var sign:ISignature = signTable[entity._id];
			var sign:ISignature = entity._sign;
			if ( $signMatchAspect( sign, observer ) ) {
				observer.registerEntity( entity );
			}
		}

		// add observer as observer of each component in the node
		var interests:Vector.<Class> = observer.componentInterests;
		for ( var i:int = 0, len:int = interests.length; i < len; i++ ) {
			var componentClass:Class = interests[i];
			componentManager.registerHandler( componentClass, observer );
		}

		return observer;
	}

	[Inline]
	protected final function $signMatchAspect( sign:ISignature, aspect:AspectObserver ):Boolean {
		return ( sign.hasAllOf( aspect.sign ) && !( aspect.exclusionSign && sign.hasAllOf( aspect.exclusionSign ) ) );
		//return ( entity.sign.contains( aspect.sign ) && !( aspect.exclusionSign && entity.sign.contains( aspect.exclusionSign ) ) );
	}
}
}
