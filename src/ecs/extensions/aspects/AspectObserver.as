/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.extensions.aspects {
import com.flashrush.signatures.BitSign;

import ecs.framework.api.ecs_core;
import ecs.framework.components.api.IComponentHandler;
import ecs.framework.entity.Entity;

import flash.utils.Dictionary;

use namespace ecs_core;

/**
 * Aspect & AspectObserver merged in one class
 */
internal class AspectObserver implements IComponentHandler/*, IEntityObserver */ {
	private var aspectClass:Class;
	//private var nodePool:NodePool;

	private var _aspects:AspectList = new AspectList();

	/** Map of this family nodes by entity */
	internal var nodeByEntity:Dictionary = new Dictionary();

	/** Node property name by a component class */
	internal var propertyMap:Dictionary;

	/** List of all component classes defined in node, and the family interested in handling of. */
	internal var componentInterests:Vector.<Class>;

	/** Components that should not be in the entity to match the family. */
	internal var excludedComponents:Dictionary;

	/** Components that are not required to match an entity to the family */
	internal var optionalComponents:Dictionary;

	/** Bit representation of the family's required components for fast matching */
	internal var sign:BitSign;

	/** Bit representation of the family's excluded components for fast matching */
	internal var exclusionSign:BitSign;

	public function AspectObserver( aspectClass:Class ) {
		this.aspectClass = aspectClass;
		AspectUtil.describeAspect( aspectClass, this );
	}

	public function get aspects():AspectList {
		return _aspects;
	}

	public function registerEntity( entity:Entity ):void {
		//entity.ecse::addComponentObserver( this );

		// do nothing if an entity already identified in this family
		if ( nodeByEntity[entity] ) {
			return;
		}

		$createNodeOf( entity );
	}

	public function unRegisterEntity( entity:Entity ):void {
		//entity.ecse::removeComponentObserver( this );

		if ( nodeByEntity[entity] ) {
			$removeNodeOf( entity );
		}
	}

	public function onComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		// The node of the entity if it belongs to this family.
		var node:Aspect = nodeByEntity[entity];

		/* Excluded component check */

		// Check is new component excludes the entity from this family
		if ( excludedComponents && excludedComponents[component] ) {
			if ( node ) {
				$removeNodeOf( entity );
			}
			return;
		}

		/* Optional component check */

		// An optional component can't affect entity matching to the family.
		// If a component is optional just put the reference to the node property 
		if ( node && optionalComponents && optionalComponents[component] ) {
			var property:String = optionalComponents[component];
			node[property] = entity.get( component );
			return;
		}

		/* Required component check */

		// do nothing if the entity already identified as member of this family or a component isn't required by this family
		if ( node || !propertyMap[component] ) {
			return;
		}

		$createNodeOf( entity );
	}

	public function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		// The node of the entity if it belongs to this family.
		var node:Aspect = nodeByEntity[entity];

		/* Excluded component check */

		// Check is removed component makes the entity as a member of this family
		if ( excludedComponents && excludedComponents[component] ) {
			// no more unacceptable components?
			if ( !entity._sign.contains( exclusionSign ) ) {
				registerEntity( entity );
			}
			return;
		}

		/* Optional component check */

		// Removed optional component can't decline the entity from matching to a family,
		// so just set the node property to null
		if ( node && optionalComponents && optionalComponents[component] ) {
			var property:String = optionalComponents[component];
			node[property] = null;
			return;
		}

		/* Required component check */

		if ( node && propertyMap[component] ) {
			$removeNodeOf( entity );
		}
	}

	/**
	 * Creates new family's node for the matched entity
	 * createNode() should be called after verification of existence all required components in the entity.
	 * @param entity
	 */
	[Inline]
	private final function $createNodeOf( entity:Entity ):void {
		// Create new node and assign components from the entity to the node variables
		//var node:Node = nodePool.get();
		var node:Aspect = new aspectClass();
		node.entity = entity;

		var i:uint;
		var len:uint = componentInterests.length;
		var componentClass:Class;
		for ( i = 0; i < len; i++ ) {
			componentClass = componentInterests[i];
			var property:String = propertyMap[componentClass] || optionalComponents[componentClass];
			node[property] = entity.get( componentClass );
		}

		/*for ( var componentClass:* in propertyMap ) {
			var property:String = propertyMap[componentClass];
			node[property] = entity.get( componentClass );
		}

		if ( optionalComponents ) {
			for ( componentClass in optionalComponents ) {
				property = optionalComponents[componentClass];
				node[property] = entity.get( componentClass );
			}
		}*/

		nodeByEntity[entity] = node;
		aspects.add( node );
	}

	[Inline]
	private final function $removeNodeOf( entity:Entity ):void {
		var node:Aspect = nodeByEntity[entity];
		delete nodeByEntity[entity];
		aspects.remove( node );

		/*if ( engine.updating ) {
			nodePool.cache( node );
			engine.updateComplete.add( releaseNodePoolCache );
		} else {
			nodePool.dispose( node );
		}*/
	}

	private function releaseNodePoolCache():void {
		//engine.updateComplete.remove( releaseNodePoolCache );
		//nodePool.releaseCache();
	}
}
}
