/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.aspects {
import ash.core.Entity;

import ashx.engine.api.IFamiliesManager;
import ashx.engine.components.CpManager;
import ashx.engine.ecse;
import ashx.engine.entity.ECollection;
import ashx.engine.entity.IEntityHandler;
import ashx.engine.lists.EntityNodeList;
import ashx.engine.lists.ItemNode;
import ashx.engine.lists.LinkedHashMap;

import com.flashrush.signatures.BitSignManager;

use namespace ecse;

public class AspectFamiliesManager implements IFamiliesManager, IEntityHandler {
	private var entities:ECollection;
	private var cpManager:CpManager;
	private var signManager:BitSignManager;
	private var aspectObservers:LinkedHashMap/*<NodeClass, AspectObserver>*/ = new LinkedHashMap();

	public function AspectFamiliesManager( entities:ECollection, cpManager:CpManager ) {
		this.entities = entities;
		this.cpManager = cpManager;
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
			/*var observers:LinkedHashSet = observersOfComponent[componentClass] ||= new LinkedHashSet();
			observers.add( aspect );*/

			cpManager.addComponentHandler( componentClass, aspect );
		}

		return aspect;
	}

	[Inline]
	protected final function _entityMatchAspect( entity:Entity, aspect:AspectObserver ):Boolean {
		return ( entity.sign.contains( aspect.sign ) && !( aspect.exclusionSign && entity.sign.contains( aspect.exclusionSign ) ) );
	}
}
}
