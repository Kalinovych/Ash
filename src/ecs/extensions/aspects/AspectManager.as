/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.extensions.aspects {
import ecs.framework.api.ecsf;
import ecs.framework.entity.Entity;
import ecs.framework.entity.EntityManager;
import ecs.framework.entity.api.IEntityHandler;
import ecs.engine.components.IComponentObserver;
import ecs.lists.LinkedMap;
import ecs.lists.Node;

import com.flashrush.signatures.BitSign;
import com.flashrush.signatures.BitSignManager;

use namespace ecsf;

public class AspectManager implements IAspectManager, IEntityHandler {
	private var entities:EntityManager;
	private var componentManager:IComponentObserver;
	private var aspectObservers:LinkedMap/*<NodeClass, AspectObserver>*/ = new LinkedMap();
	private var signManager:BitSignManager;
	private var signTable:Vector.<BitSign>;

	public function AspectManager( entities:EntityManager, componentManager:IComponentObserver ) {
		this.entities = entities;
		this.componentManager = componentManager;
		
		signManager = new BitSignManager();
		signTable = new Vector.<BitSign>( entities.entityCount );
		
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
	public function onEntityAdded( entity:Entity ):void {
		trace( "[AspectsManager.onEntityAdded]›", entity );
		//entity.sign = signManager.signKeys( entity.components );
		
		var id:uint = entity._id;
		if (signTable.length <= id) {
			signTable.length = id + 1;
		}
		var sign:BitSign = signManager.signKeys( entity.components );
		signTable[id] = sign;
		for ( var node:Node = aspectObservers.$firstNode; node; node = node.next ) {
			var observer:AspectObserver = node.content;
			if ( $signMatchAspect( sign, observer ) ) {
				observer.addMatchedEntity( entity );
			}
		}
	}

	/** @private **/
	public function onEntityRemoved( entity:Entity ):void {
		var sign:BitSign = signTable[entity._id];
		for ( var node:Node = aspectObservers.$firstNode; node; node = node.next ) {
			var observer:AspectObserver = node.content;
			if ( $signMatchAspect( sign, observer ) ) {
				observer.removeMatchedEntity( entity );
			}
		}
		signManager.recycleSign( entity.sign );
		entity.sign = null;
	}

	/** @private **/
	protected final function createObserver( aspectClass:Class ):AspectObserver {
		var observer:AspectObserver = new AspectObserver( aspectClass );
		observer.sign = signManager.signKeys( observer.propertyMap );
		if ( observer.excludedComponents ) {
			observer.exclusionSign = signManager.signKeys( observer.excludedComponents );
		}

		// check all entities that are already in the list
		for ( var entity:Entity = entities.first; entity; entity = entity.next ) {
			var sign:BitSign = signTable[entity._id];
			if ( $signMatchAspect( sign, observer ) ) {
				observer.addMatchedEntity( entity );
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
	protected final function $signMatchAspect( sign:BitSign, aspect:AspectObserver ):Boolean {
		return ( sign.contains( aspect.sign ) && !( aspect.exclusionSign && sign.contains( aspect.exclusionSign ) ) );
		//return ( entity.sign.contains( aspect.sign ) && !( aspect.exclusionSign && entity.sign.contains( aspect.exclusionSign ) ) );
	}
}
}
