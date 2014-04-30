/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.aspects {
import ash.core.Entity;

import ashx.engine.ecse;

import ashx.engine.entity.*;
import ashx.engine.api.IEntityFamiliesManager;
import ashx.engine.lists.EntityNodeList;
import ashx.engine.lists.ItemNode;
import ashx.engine.lists.LinkedHashMap;
import ashx.engine.lists.LinkedHashSet;

import com.flashrush.signatures.BitSignManager;

import flash.utils.Dictionary;

use namespace ecse;

public class FamiliesManager implements IEntityFamiliesManager {
	private var entities:EntityList;
	private var signManager:BitSignManager;
	private var aspectObservers:LinkedHashMap/*<NodeClass, AspectObserver>*/ = new LinkedHashMap();
	private var observersByComponent:Dictionary = new Dictionary();

	public function FamiliesManager() {
		signManager = new BitSignManager();
	}

	public function getEntities( familyIdentifier:Class ):EntityNodeList {
		var observer:AspectObserver = aspectObservers.get( familyIdentifier );
		if ( !observer ) {
			observer = createAspectObserver( familyIdentifier );
		}
		return observer.nodeList;
	}
	
	public function onEntityAdded( entity:Entity ):void {
		entity.sign = signManager.signKeys( entity.components );
		for each( var aspect:AspectObserver in aspectObservers ) {
			if ( _entityMatchAspect( entity, aspect ) ) {
				aspect.onAspectEntityAdded( entity );
			}
		}
	}

	public function onEntityRemoved( entity:Entity ):void {
		for each( var aspect:AspectObserver in aspectObservers ) {
			if ( _entityMatchAspect( entity, aspect ) ) {
				aspect.onAspectEntityRemoved( entity );
			}
		}

		signManager.recycleSign( entity.sign );
		entity.sign = null;
	}
	
	protected final function createAspectObserver( nodeClass:Class ):AspectObserver {
		var aspect:AspectObserver = new AspectObserver( nodeClass );
		aspect.sign = signManager.signKeys( aspect.propertyMap );
		if ( aspect.excludedComponents ) {
			aspect.exclusionSign = signManager.signKeys( aspect.excludedComponents );
		}

		// find all entities matching this aspect
		for ( var node:ItemNode = entities._firstNode; node; node = node.next ) {
			var entity:Entity = node.item;
			if ( _entityMatchAspect( entity, aspect ) ) {
				aspect.onAspectEntityAdded( entity );
			}
		}

		// add aspect as observer of each component in the node
		var interests:Vector.<Class> = aspect.componentInterests;
		for ( var i:int = 0, len:int = interests.length; i < len; i++ ) {
			var componentClass:Class = interests[i];
			var observers:LinkedHashSet = observersByComponent[componentClass] ||= new LinkedHashSet();
			observers.add( aspect );

			//cpManager.addComponentObserver( componentClass, aspect );
		}

		return aspect;
	}
	
	[Inline]
	protected final function _entityMatchAspect( entity:Entity, aspect:AspectObserver ):Boolean {
		return ( entity.sign.contains( aspect.sign ) && !( aspect.exclusionSign && entity.sign.contains( aspect.exclusionSign ) ) );
	}
}
}
