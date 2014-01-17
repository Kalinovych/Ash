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
		var excludedComponents:Dictionary = withoutComponentsByNode[nodeClass];
		var optionalComponents:Dictionary = optionalComponentsByNode[nodeClass];

		if ( !propertyMap ) {
			propertyMap = propertyMapByNode[nodeClass] = new Dictionary();
			componentInterests = componentInterestsByNode[nodeClass] = new Vector.<Class>();

			var classXML:XML = describeType( nodeClass );
			var variables:XMLList = classXML.factory.variable;

			for each ( var item:XML in variables ) {
				var propertyName:String = item.@name.toString();
				if ( propertyName != "entity" && propertyName != "previous" && propertyName != "next" ) {
					var componentClass:Class = getDefinitionByName( item.@type.toString() ) as Class;

					// excluded by metadata
					if ( item.metadata.(@name == "Without").length() > 0 ) {
						if ( !excludedComponents ) {
							excludedComponents = withoutComponentsByNode[nodeClass] = new Dictionary();
						}
						excludedComponents[componentClass] = propertyName;
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

					componentInterests.push( componentClass );
				}
			}
			flash.system.System.disposeXML( classXML );
		}

		family.propertyMap = propertyMap;
		family.componentInterests = componentInterests;
		family.excludedComponents = excludedComponents;
		family.optionalComponents = optionalComponents;
	}

	/* Family Class implementation */

	private var nodeClass:Class;
	private var engine:Engine;
	private var nodePool:NodePool;

	internal var nodeByEntity:Dictionary = new Dictionary();

	/** Node property name by a component class */
	internal var propertyMap:Dictionary;

	/** List of all component classes defined in node */
	internal var componentInterests:Vector.<Class>;

	/** Components that should not be in the entity to match the family. */
	internal var excludedComponents:Dictionary;
	
	/** Components that are not required to match an entity to the family */
	internal var optionalComponents:Dictionary;

	/** The list of all nodes of entities matched this family */
	internal var nodeList:NodeList = new NodeList();
	
	/** Bit representation of the family's required components for fast matching */
	internal var sign:BitSign;

	/** Bit representation of the family's excluded components for fast matching */
	internal var exclusionSign:BitSign;

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

	internal function entityFound( entity:Entity ):void {
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

		createNodeOf( entity );
	}

	/**
	 * Removes the entity if it have a node is in this family's NodeList.
	 */
	internal function entityLost( entity:Entity ):void {
		if ( nodeByEntity[entity] ) {
			removeNodeOf( entity );
		}
	}

	internal function componentAdded( entity:Entity, componentClass:Class ):void {
		// The node of the entity if it belongs to this family.
		var node:Node = nodeByEntity[entity];
		
		/* Excluded component check */
		
		// Check is new component excludes the entity from this family
		if ( excludedComponents && excludedComponents[componentClass] ) {
			if ( node ) {
				entityLost( entity );
			}
			return;
		}
		
		/* Optional component check */
		
		// Optional component can't affect entity matching to the family,
		// so just assign it to the node if it exists
		if (node && optionalComponents && optionalComponents[componentClass]) {
			var property:String = optionalComponents[componentClass];
			node[property] = entity.get( componentClass );
			return;
		}
		
		/* Required component check */

		// do nothing if the entity already identified as member of this family or the component isn't required by this family
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

		createNodeOf( entity );
	}

	internal function componentRemoved( entity:Entity, componentClass:Class ):void {
		// The node of the entity if it belongs to this family.
		var node:Node = nodeByEntity[entity];

		/* Excluded component check */
		
		// Check is after the component removed the entity will match to this family
		if ( excludedComponents && excludedComponents[componentClass] ) {
			// no more unacceptable components?
			if (!entity.sign.contains(exclusionSign)) {
				entityFound(entity);
			}
			return;
		}

		/* Optional component check */
		
		// Removed optional component can't decline the entity from matching to a family,
		// so just set node property to null
		if (node && optionalComponents && optionalComponents[componentClass]) {
			var property:String = optionalComponents[componentClass];
			node[property] = null;
			return;
		}

		/* Required component check */
		
		if ( node && propertyMap[componentClass] ) {
			removeNodeOf( entity );
		}
	}

	/**
	 * Creates new family's node for the matched entity
	 * createNode() should be called after verification of existence all required components in the entity.
	 * @param entity
	 */
	[Inline]
	private function createNodeOf( entity:Entity ):void {
		// Create new node and assign components from the entity to the node variables
		var node:Node = nodePool.get();
		node.entity = entity;
		for ( var componentClass:* in propertyMap ) {
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
	private function removeNodeOf( entity:Entity ):void {
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
		excludedComponents = null;
		optionalComponents = null;
	}
}
}
