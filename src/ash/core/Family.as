/**
 * @author Alexander Kalinovych @ 2013
 */
package ash.core {
import ash.core.Family;
import ash.tools.ComponentPool;

import flash.system.System;
import flash.utils.Dictionary;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;

/**
 * Family designed to identify entities as defined node and add or remove that node to the NodeList.
 */
public class Family {

	private static var nodePropertyMap:Dictionary = new Dictionary();
	private static var nodeComponentSet:Dictionary = new Dictionary();
	
	private static function initFamily(family:Family, nodeClass:Class):void {
		var propertyMap:Dictionary = nodePropertyMap[nodeClass];
		var componentSet:Vector.<Class> = nodeComponentSet[nodeClass];
		
		if (!propertyMap) {
			propertyMap = nodePropertyMap[nodeClass] = new Dictionary();
			componentSet = nodeComponentSet[nodeClass] = new Vector.<Class>();
			
			var classXML:XML = describeType(nodeClass);
			var variables:XMLList = classXML.factory.variable;
			for each (var item:XML in variables) {
				var propertyName:String = item.@name.toString();
				if (propertyName != "entity" && propertyName != "previous" && propertyName != "next") {
					var componentClass:Class = getDefinitionByName(item.@type.toString()) as Class;
					propertyMap[componentClass] = propertyName;
					componentSet.push(componentClass);
				}
			}
			flash.system.System.disposeXML(classXML);
		}

		family.propertyMap = propertyMap;
		family.componentSet = componentSet;
	}
	
	private var nodeClass:Class;
	private var engine:Engine;
	private var nodePool:NodePool;

	internal var nodeByEntity:Dictionary = new Dictionary();

	/** Node property name by a component class */
	internal var propertyMap:Dictionary;

	/** List of component classes defined in node */
	internal var componentSet:Vector.<Class>;

	/** Store of all matched nodes of 'alive' entities */
	internal var nodeList:NodeList = new NodeList();
	
	internal var dna:uint = 0x0;

	public function Family(nodeClass:Class, engine:Engine) {
		this.nodeClass = nodeClass;
		this.engine = engine;
		init();
	}

	private function init():void {
		initFamily(this,  nodeClass);
		nodePool = new NodePool(nodeClass, propertyMap);
	}

	internal function addEntity(entity:Entity):void {
		// do nothing if an entity already identified in this family
		if (nodeByEntity[entity]) {
			return;
		}

		// verify existence of required component set in the entity
		/*for each (var requiredClass:Class in componentSet) {
			if (!entity.has(requiredClass)) {
				return;
			}
		}*/

		createNode(entity);
	}

	/**
	 * Removes the entity if it is in this family's NodeList.
	 */
	internal function removeEntity(entity:Entity):void {
		if (nodeByEntity[entity]) {
			removeNode(entity);
		}
	}

	internal function componentAdded(entity:Entity, componentClass:Class):void {
		// do nothing if an entity already identified or component isn't interest 
		if (nodeByEntity[entity] || !propertyMap[componentClass]) {
			return;
		}

		// verify that a new component complete a set of required components in the entity
		/*for each (var requiredClass:Class in componentSet) {
			if (!entity.has(requiredClass)) {
				return;
			}
		}*/

		createNode(entity);
	}

	internal function componentRemoved(entity:Entity, componentClass:Class):void {
		if (nodeByEntity[entity] && propertyMap[componentClass]) {
			removeNode(entity);
		}
	}
	
	[Inline]
	private function createNode(entity:Entity):void {
		// Create new node and assign components from the entity to it fields
		var node:Node = nodePool.get();
		node.entity = entity;
		for each (var componentClass:Class in componentSet) {
			var property:String = propertyMap[componentClass];
			node[property] = entity.get(componentClass);
		}
		nodeByEntity[entity] = node;
		nodeList.add(node);
	}

	[Inline]
	private function removeNode(entity:Entity):void {
		var node:Node = nodeByEntity[entity];
		delete nodeByEntity[entity];

		nodeList.remove(node);

		if (engine.updating) {
			nodePool.cache(node);
			engine.updateComplete.add(releaseNodePoolCache);
		} else {
			nodePool.dispose(node);
		}
	}

	private function releaseNodePoolCache():void {
		engine.updateComplete.remove(releaseNodePoolCache);
		nodePool.releaseCache();
	}

	internal function clear():void {
		for (var node:Node = nodeList.head; node; node = node.next) {
			delete nodeByEntity[node.entity];
		}
		nodeList.removeAll();
	}

	internal function dispose():void {
		engine.updateComplete.remove(releaseNodePoolCache);
		engine = null;
		nodeList.removeAll();
		nodeList = null;
		nodeByEntity = null;
		nodePool = null;
		nodeClass = null;
		propertyMap = null;
		componentSet = null;
	}
}
}
