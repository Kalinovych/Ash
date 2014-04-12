/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.aspects {
import ash.core.Entity;
import ash.core.NodeList;
import ash.engine.components.IComponentObserver;
import ash.engine.ecse;
import ash.engine.entity.EntityManager;
import ash.engine.entity.IEntityObserver;
import ash.engine.lists.ItemNode;
import ash.engine.lists.LinkedHashMap;
import ash.engine.lists.LinkedHashSet;
import ash.engine.lists.LinkedIdMap;

import com.flashrush.signatures.BitSignManager;

import flash.utils.Dictionary;

use namespace ecse;

/**
 * A layer between engine and Aspect Observers.
 * Observe for added/removed entities and notify aspect observers.
 *
 */
public class AspectsManager implements IEntityObserver, IComponentObserver {
	private var aspectObservers:LinkedHashMap/*<NodeClass, AspectObserver>*/ = new LinkedHashMap();
	private var observersOfComponent:Dictionary/*<ComponentClass, LinkedHashSet<AspectObserver>>*/ = new Dictionary();

	private var entityManager:EntityManager;
	private var signManager:BitSignManager;

	public function AspectsManager( entityManager:EntityManager ) {
		this.entityManager = entityManager;
		this.signManager = entityManager.mSignManager;
		entityManager.addObserver( this );
	}

	public function getNodeList( nodeClass:Class ):NodeList {
		var observer:AspectObserver = aspectObservers.get( nodeClass );
		if ( !observer ) {
			observer = _createAspectObserver( nodeClass );
		}
		return observer.nodeList;
		//return ( familyMap[nodeClass] || inline_createFamily( nodeClass ) ).nodeList;
	}

	/**
	 * @private
	 */
	public function onEntityAdded( entity:Entity ):void {
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
		for each( var aspect:AspectObserver in aspectObservers ) {
			if ( _entityMatchAspect( entity, aspect ) ) {
				aspect.onAspectEntityRemoved( entity );
			}
		}
	}

	/**
	 * @private
	 */
	public function onComponentAdded( entity:Entity, component:*, componentType:* ):void {
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

	[Inline]
	protected final function _createAspectObserver( nodeClass:Class ):AspectObserver {
		var aspect:AspectObserver = new AspectObserver( nodeClass );
		aspect.sign = signManager.signKeys( aspect.propertyMap );
		if ( aspect.excludedComponents ) {
			aspect.exclusionSign = signManager.signKeys( aspect.excludedComponents );
		}

		// find all entities matching this aspect
		var entityList:LinkedIdMap = entityManager.mEntities;
		for ( var node:ItemNode = entityList._firstNode; node; node = node.next ) {
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
