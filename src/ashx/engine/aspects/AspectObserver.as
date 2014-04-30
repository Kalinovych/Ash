/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.aspects {
import ash.core.Entity;

import ashx.engine.components.IComponentObserver;

import ashx.engine.ecse;
import ashx.engine.entity.EntityNode;
import ashx.engine.lists.EntityNodeList;

import com.flashrush.signatures.BitSign;

import flash.utils.Dictionary;

use namespace ecse;

/**
 * Aspect & AspectObserver merged in one class
 */
internal class AspectObserver implements IComponentObserver/*, IEntityObserver */ {
	private var nodeClass:Class;
	//private var nodePool:NodePool;

	private var _nodeList:EntityNodeList = new EntityNodeList();

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

	public function AspectObserver( nodeClass:Class ) {
		this.nodeClass = nodeClass;
		AspectUtil.describeAspect( nodeClass, this );
	}

	public function get nodeList():EntityNodeList {
		return _nodeList;
	}

	public function onAspectEntityAdded( entity:Entity ):void {
		//entity.ecse::addComponentObserver( this );

		// do nothing if an entity already identified in this family
		if ( nodeByEntity[entity] ) {
			return;
		}

		_createNodeOf( entity );
	}

	public function onAspectEntityRemoved( entity:Entity ):void {
		//entity.ecse::removeComponentObserver( this );

		if ( nodeByEntity[entity] ) {
			_removeNodeOf( entity );
		}
	}

	public function onComponentAdded( entity:Entity, component:*, componentClass:* ):void {
		// The node of the entity if it belongs to this family.
		var node:EntityNode = nodeByEntity[entity];

		/* Excluded component check */

		// Check is new component excludes the entity from this family
		if ( excludedComponents && excludedComponents[componentClass] ) {
			if ( node ) {
				_removeNodeOf( entity );
			}
			return;
		}

		/* Optional component check */

		// An optional component can't affect entity matching to the family.
		// If a component is optional just put the reference to the node property 
		if ( node && optionalComponents && optionalComponents[componentClass] ) {
			var property:String = optionalComponents[componentClass];
			node[property] = entity.get( componentClass );
			return;
		}

		/* Required component check */

		// do nothing if the entity already identified as member of this family or a component isn't required by this family
		if ( node || !propertyMap[componentClass] ) {
			return;
		}

		_createNodeOf( entity );
	}

	public function onComponentRemoved( entity:Entity, component:*, componentClass:* ):void {
		// The node of the entity if it belongs to this family.
		var node:EntityNode = nodeByEntity[entity];

		/* Excluded component check */

		// Check is removed component makes the entity as a member of this family
		if ( excludedComponents && excludedComponents[componentClass] ) {
			// no more unacceptable components?
			if ( !entity.sign.contains( exclusionSign ) ) {
				onAspectEntityAdded( entity );
			}
			return;
		}

		/* Optional component check */

		// Removed optional component can't decline the entity from matching to a family,
		// so just set the node property to null
		if ( node && optionalComponents && optionalComponents[componentClass] ) {
			var property:String = optionalComponents[componentClass];
			node[property] = null;
			return;
		}

		/* Required component check */

		if ( node && propertyMap[componentClass] ) {
			_removeNodeOf( entity );
		}
	}

	/**
	 * Creates new family's node for the matched entity
	 * createNode() should be called after verification of existence all required components in the entity.
	 * @param entity
	 */
	[Inline]
	private final function _createNodeOf( entity:Entity ):void {
		// Create new node and assign components from the entity to the node variables
		//var node:Node = nodePool.get();
		var node:EntityNode = new nodeClass();
		node.entity = entity;
		for ( var componentClass:* in propertyMap ) {
			var property:String = propertyMap[componentClass];
			node[property] = entity.get( componentClass );
		}

		if ( optionalComponents ) {
			for ( componentClass in optionalComponents ) {
				property = optionalComponents[componentClass];
				node[property] = entity.get( componentClass );
			}
		}

		nodeByEntity[entity] = node;
		nodeList.add( node );
	}

	[Inline]
	private final function _removeNodeOf( entity:Entity ):void {
		var node:EntityNode = nodeByEntity[entity];
		delete nodeByEntity[entity];

		nodeList.remove( node );

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
