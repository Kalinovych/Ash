/**
 * @author Alexander Kalinovych @ 2013
 */
package ash.core {
import com.flashrush.signatures.BitSign;

import flash.system.System;
import flash.utils.Dictionary;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;

/**
 * Family designed to identify entities as defined node and add or remove that node to the NodeList.
 */
public class Family {

	/* Static */

	private static var propertyMapByNode:Dictionary = new Dictionary();
	private static var componentInterestsByNode:Dictionary = new Dictionary();
	private static var withoutComponentsByNode:Dictionary = new Dictionary();
	private static var optionalComponentsByNode:Dictionary = new Dictionary();

	private static function initFamily( family:Family, nodeClass:Class ):void {
		var propertyMap:Dictionary = propertyMapByNode[nodeClass];
		var componentInterests:Vector.<Class> = componentInterestsByNode[nodeClass];
		var withoutComponents:Dictionary = withoutComponentsByNode[nodeClass];
		var optionalComponents:Dictionary = optionalComponentsByNode[nodeClass];

		if ( !propertyMap ) {
			propertyMap = propertyMapByNode[nodeClass] = new Dictionary();
			componentInterests = componentInterestsByNode[nodeClass] = new Vector.<Class>();
			//withoutComponents = withoutComponentByNode[nodeClass] = new Dictionary();

			var classXML:XML = describeType( nodeClass );
			var variables:XMLList = classXML.factory.variable;

			for each ( var item:XML in variables ) {
				var propertyName:String = item.@name.toString();
				if ( propertyName != "entity" && propertyName != "previous" && propertyName != "next" ) {
					var componentClass:Class = getDefinitionByName( item.@type.toString() ) as Class;

					// excluded by metadata
					if ( item.metadata.(@name == "Without").length() > 0 ) {
						if ( !withoutComponents ) {
							withoutComponents = withoutComponentsByNode[nodeClass] = new Dictionary();
						}
						withoutComponents[componentClass] = propertyName;
					}
					else if ( item.metadata.(@name == "Optional").length() > 0 ) {
						// optional
						if ( !optionalComponents ) {
							optionalComponents = optionalComponentsByNode[nodeClass] = new Dictionary();
						}
						optionalComponents[componentClass] = propertyName;
					} else {
						propertyMap[componentClass] = propertyName;
					}


					/*var required:Boolean = (item.metadata.(@name == "Without").length() == 0);
					 if ( required ) {
					 propertyMap[componentClass] = propertyName;
					 } else {
					 if ( !withoutComponents ) {
					 withoutComponents = withoutComponentByNode[nodeClass] = new Dictionary();
					 }
					 withoutComponents[componentClass] = propertyName;
					 trace( "[Family][initFamily] Without:", componentClass );
					 }*/

					componentInterests.push( componentClass );
				}
			}
			flash.system.System.disposeXML( classXML );
		}

		family.propertyMap = propertyMap;
		family.componentInterests = componentInterests;
		family.withoutComponents = withoutComponents;
		family.optionalComponents = optionalComponents;
	}

	/* Implementation */

	private var nodeClass:Class;
	private var engine:Engine;
	private var nodePool:NodePool;

	internal var nodeByEntity:Dictionary = new Dictionary();

	/** Node property name by a component class */
	internal var propertyMap:Dictionary;

	/** List of all component classes defined in node */
	internal var componentInterests:Vector.<Class>;

	/**
	 * Components that should not be in the entity.
	 */
	internal var withoutComponents:Dictionary;

	internal var optionalComponents:Dictionary;

	/** Store of all matched nodes of 'alive' entities */
	internal var nodeList:NodeList = new NodeList();

	internal var sign:BitSign;

	internal var excludeSign:BitSign;

	/**
	 * Constructor
	 *
	 * @param nodeClass
	 * @param engine
	 */
	public function Family( nodeClass:Class, engine:Engine ) {
		this.nodeClass = nodeClass;
		this.engine = engine;
		init();
	}

	private function init():void {
		initFamily( this, nodeClass );
		nodePool = new NodePool( nodeClass, propertyMap );
	}

	internal function addEntity( entity:Entity ):void {
		// do nothing if an entity already identified in this family
		if ( nodeByEntity[entity] ) {
			return;
		}

		// NOTE: deprecated
		// verify existence of required component set in the entity
		/*for each (var requiredClass:Class in componentSet) {
		 if (!entity.has(requiredClass)) {
		 return;
		 }
		 }*/

		createNode( entity );
	}

	/**
	 * Removes the entity if it is in this family's NodeList.
	 */
	internal function removeEntity( entity:Entity ):void {
		if ( nodeByEntity[entity] ) {
			removeNode( entity );
		}
	}

	internal function componentAdded( entity:Entity, componentClass:Class ):void {
		// Instance of the node if the entity in this family's NodeList.
		var node:Node = nodeByEntity[entity];
		
		
		/* Excluded component check */
		
		// Check is new component excludes the entity from this family
		if ( withoutComponents && withoutComponents[componentClass] ) {
			if ( node ) {
				removeEntity( entity );
			}
			return;
		}
		
		/* Optional component check */
		
		// Optional component can't complete entity matching to the family,
		// so just assign it to the node
		if (optionalComponents && node && optionalComponents[componentClass]) {
			var property:String = optionalComponents[componentClass];
			node[property] = entity.get( componentClass );
			return;
		}
		
		/* Required component check */

		// do nothing if an entity already identified or component isn't interested
		if ( node || !propertyMap[componentClass] ) {
			return;
		}

		// NOTE: deprecated
		// verify that a new component complete a set of required components in the entity
		/*for each (var requiredClass:Class in componentSet) {
		 if (!entity.has(requiredClass)) {
		 return;
		 }
		 }*/

		createNode( entity );
	}

	internal function componentRemoved( entity:Entity, componentClass:Class ):void {
		// Instance of the node if the entity in this family's NodeList.
		var node:Node = nodeByEntity[entity];

		/* Excluded component check */
		
		// Check is after the component removed the entity will match to this family
		if ( withoutComponents && withoutComponents[componentClass] ) {
			// no more excluded components?
			if (!entity.sing.contains(excludeSign)) {
				addEntity(entity);
			}
			return;
		}

		/* Optional component check */
		
		// Removed optional component can't decline the entity from matching to a family,
		// so just set node property to null
		if (optionalComponents && node && optionalComponents[componentClass]) {
			var property:String = optionalComponents[componentClass];
			node[property] = null;
			return;
		}

		/* Required component check */
		
		if ( node && propertyMap[componentClass] ) {
			removeNode( entity );
		}
	}

	/**
	 * createNode() should be called after verification that all required components contained by the entity.
	 * @param entity
	 */
	[Inline]
	private function createNode( entity:Entity ):void {
		// Create new node and assign components from the entity to it fields
		var node:Node = nodePool.get();
		node.entity = entity;
		for ( var componentClass:Class in propertyMap ) {
			var property:String = propertyMap[componentClass];
			node[property] = entity.get( componentClass );
		}
		
		if (optionalComponents) {
			for (componentClass in optionalComponents) {
				property = optionalComponents[componentClass];
				node[property] = entity.get( componentClass );
			}
		}
		
		nodeByEntity[entity] = node;
		nodeList.add( node );
	}

	[Inline]
	private function removeNode( entity:Entity ):void {
		var node:Node = nodeByEntity[entity];
		delete nodeByEntity[entity];

		nodeList.remove( node );

		if ( engine.updating ) {
			nodePool.cache( node );
			engine.updateComplete.add( releaseNodePoolCache );
		} else {
			nodePool.dispose( node );
		}
	}

	private function releaseNodePoolCache():void {
		engine.updateComplete.remove( releaseNodePoolCache );
		nodePool.releaseCache();
	}

	internal function clear():void {
		for ( var node:Node = nodeList.head; node; node = node.next ) {
			delete nodeByEntity[node.entity];
		}
		nodeList.removeAll();
	}

	internal function dispose():void {
		engine.updateComplete.remove( releaseNodePoolCache );
		engine = null;
		nodeList.removeAll();
		nodeList = null;
		nodeByEntity = null;
		nodePool = null;
		nodeClass = null;
		componentInterests = null;
		propertyMap = null;
		withoutComponents = null;
		optionalComponents = null;
	}
}
}
