/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.aspects {
import ash.core.Entity;

import ashx.engine.api.IFamiliesManager;
import ashx.engine.ecse;
import ashx.engine.entity.ECollection;
import ashx.engine.lists.EntityNodeList;
import ashx.engine.lists.ItemNode;
import ashx.engine.lists.LinkedHashMap;
import ashx.engine.lists.LinkedHashSet;

import com.flashrush.signatures.BitSignManager;

import flash.utils.Dictionary;

use namespace ecse;

/**
 * A layer between engine and Aspect Observers.
 * Observe for added/removed entities and notify aspect observers.
 *
 */
public class AspectsManager implements IFamiliesManager {
	private var aspectObservers:LinkedHashMap/*<NodeClass, AspectObserver>*/ = new LinkedHashMap();
	private var observersOfComponent:Dictionary/*<ComponentClass, LinkedHashSet<AspectObserver>>*/ = new Dictionary();

	private var entities:ECollection;
	private var signManager:BitSignManager;

	public function AspectsManager( entities:ECollection ) {
		super();
		this.entities = entities;
		this.signManager = new BitSignManager();
	}

	public function getEntities( familyIdentifier:Class ):EntityNodeList {
		var observer:AspectObserver = aspectObservers.get( familyIdentifier );
		if ( !observer ) {
			observer = createAspectObserver( familyIdentifier );
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
	public function onEntityAdded( entity:Entity ):void {
		entity.sign = signManager.signKeys( entity.components );
		//super.onEntityAdded( entity );
		for each( var aspect:AspectObserver in aspectObservers ) {
			if ( _entityMatchAspect( entity, aspect ) ) {
				aspect.onAspectEntityAdded( entity );
			}
		}
	}

	/**
	 * @private
	 */
	public function onEntityRemoved( entity:Entity ):void {
		//super.onEntityRemoved( entity );
		for each( var aspect:AspectObserver in aspectObservers ) {
			if ( _entityMatchAspect( entity, aspect ) ) {
				aspect.onAspectEntityRemoved( entity );
			}
		}

		signManager.recycleSign( entity.sign );
		entity.sign = null;
	}

	/**
	 * @private
	 */
	public function onComponentAdded( entity:Entity, component:*, componentType:* ):void {
		// add a component to the entity sign
		entity.sign.add( componentType );

		// mark the entity as a componentType instance holder
		//mapEntityToComponent( componentType, entity );

		// notify aspect observers that are interested in the componentType
		var componentObservers:LinkedHashSet = observersOfComponent[componentType];
		if ( componentObservers ) {
			for ( var node:ItemNode = componentObservers._firstNode; node; node = node.next ) {
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
	public function onComponentRemoved( entity:Entity, component:*, componentType:* ):void {
		// remove a component from the entity sign
		entity.sign.remove( componentType );

		// mark the entity no more contains a component of the componentType
		//unmapEntityFromComponent( componentType, entity );

		// notify aspect observers that are interested in the componentType
		var componentObservers:LinkedHashSet = observersOfComponent[componentType];
		if ( componentObservers ) {
			for ( var node:ItemNode = componentObservers._firstNode; node; node = node.next ) {
				var observer:AspectObserver = node.item;
				if ( entity.sign.contains( observer.sign ) ) {
					observer.onComponentRemoved( entity, componentType );
				}
			}
		}
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
			var observers:LinkedHashSet/*<AspectObserver>*/ = observersOfComponent[componentClass] ||= new LinkedHashSet();
			observers.add( aspect );
		}

		return aspect;
	}

	[Inline]
	protected final function _entityMatchAspect( entity:Entity, aspect:AspectObserver ):Boolean {
		return ( entity.sign.contains( aspect.sign ) && !( aspect.exclusionSign && entity.sign.contains( aspect.exclusionSign ) ) );
	}

}
}
