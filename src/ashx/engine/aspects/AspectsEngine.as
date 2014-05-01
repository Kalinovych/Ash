/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.aspects {
import ashx.engine.entity.Entity;

import ashx.engine.ecse;
import ashx.engine.entity.EntityList;
import ashx.engine.lists.EntityNodeList;
import ashx.engine.lists.ItemNode;
import ashx.engine.lists.LinkedHashMap;
import ashx.engine.lists.LinkedHashSet;

import com.flashrush.signatures.BitSignManager;

import flash.utils.Dictionary;

use namespace ecse;

public class AspectsEngine {
	private var entities:EntityList;
	private var signManager:BitSignManager;

	private var aspectObservers:LinkedHashMap/*<NodeClass, AspectObserver>*/ = new LinkedHashMap();
	private var observersOfComponent:Dictionary/*<ComponentClass, LinkedHashSet<AspectObserver>>*/ = new Dictionary();
	private var entitySetByComponent:Dictionary/*<LinkedHashSet>*/ = new Dictionary();

	public function AspectsEngine( entities:EntityList = null ) {
		if ( !entities ) {
			entities = new EntityList();
		}
		this.entities = entities;
		signManager = new BitSignManager();
	}

	public function addEntity( entity:Entity ):void {
		entity.sign = signManager.signKeys( entity.components );
		entity.addComponentHandler( this );
		mapEntityToComponent( componentType, entity );
		for each( var aspect:AspectObserver in aspectObservers ) {
			if ( _entityMatchAspect( entity, aspect ) ) {
				aspect.onAspectEntityAdded( entity );
			}
		}
	}

	public function removeEntity( entity:Entity ):void {

		for each( var aspect:AspectObserver in aspectObservers ) {
			if ( _entityMatchAspect( entity, aspect ) ) {
				aspect.onAspectEntityRemoved( entity );
			}
		}

		signManager.recycleSign( entity.sign );
		entity.sign = null;
	}

	public function getEntity( id:uint ):Entity {
		return entities.get( id );
	}

	public function getEntities( nodeClass:Class ):EntityNodeList {
		var observer:AspectObserver = aspectObservers.get( nodeClass );
		if ( !observer ) {
			observer = createAspectObserver( nodeClass );
		}
		return observer.nodeList;
	}

	public function dispose():void {
		aspectObservers.removeAll();
		aspectObservers.dispose();
		aspectObservers = null;

		observersOfComponent = null;

		signManager = null;

		super.dispose();
	}

	/**
	 * @private
	 */
	protected function onComponentAdded( entity:Entity, component:*, componentType:* ):void {
		// add a component to the entity sign
		entity.sign.add( componentType );

		// mark the entity as a componentType instance holder
		mapEntityToComponent( componentType, entity );

		// notify aspect observers that are interested in the componentType
		var componentObservers:LinkedHashSet = observersOfComponent[componentType];
		if ( componentObservers ) {
			for ( var node:ItemNode = componentObservers.$firstNode; node; node = node.next ) {
				var observer:AspectObserver = node.item;
				if ( entity.sign.contains( observer.sign ) ) {
					observer.onComponentAdded( entity, componentType );
				}
			}
		}
	}

	/**
	 * @private
	 */
	protected function onComponentRemoved( entity:Entity, component:*, componentType:* ):void {
		// remove a component from the entity sign
		entity.sign.remove( componentType );

		// mark the entity no more contains a component of the componentType
		unmapEntityFromComponent( componentType, entity );

		// notify aspect observers that are interested in the componentType
		var componentObservers:LinkedHashSet = observersOfComponent[componentType];
		if ( componentObservers ) {
			for ( var node:ItemNode = componentObservers.$firstNode; node; node = node.next ) {
				var observer:AspectObserver = node.item;
				if ( entity.sign.contains( observer.sign ) ) {
					observer.onComponentRemoved( entity, componentType );
				}
			}
		}
	}

	protected function createAspectObserver( nodeClass:Class ):AspectObserver {
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
			var observers:LinkedHashSet/*<AspectObserver>*/ = observersOfComponent[componentClass] ||= new LinkedHashSet();
			observers.add( aspect );
		}

		return aspect;
	}

	protected function mapEntityToComponent( componentType:*, entity:Entity ):void {
		var entities:LinkedHashSet = entitySetByComponent[componentType];
		if ( !entities ) {
			entities = new LinkedHashSet();
			entitySetByComponent[componentType] = entities;
		}
		entities.add( entity );
	}

	protected function unmapEntityFromComponent( componentType:*, entity:Entity ):void {
		var entities:LinkedHashSet = entitySetByComponent[componentType];
		if ( entities ) {
			entities.remove( entity );
		}
	}

	[Inline]
	protected final function _entityMatchAspect( entity:Entity, aspect:AspectObserver ):Boolean {
		return ( entity.sign.contains( aspect.sign ) && !( aspect.exclusionSign && entity.sign.contains( aspect.exclusionSign ) ) );
	}
}
}
