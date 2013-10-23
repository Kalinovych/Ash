package ash.core {
import ash.signals.Signal0;

import flash.utils.Dictionary;

/**
 * The Engine class is the central point for creating and managing your game state. Add
 * entities and systems to the engine, and fetch families of nodes from the engine.
 */
public class Engine {
	private var entityNames:Dictionary;
	private var entityList:EntityList;
	private var systemList:SystemList;

	/**
	 * NodeMatcher by a node class
	 */
	private var nodeMatcherMap:Dictionary = new Dictionary();

	/**
	 * Vectors of NodeMatcher by a component class.
	 * 
	 * Designed to optimize node matchers notification about a component added or removed from an Entity.
	 * The Engine will process only a list of matchers interested in added/removed component.
	 * Matchers not interested in a component stays out of notification loop. 
	 */
	private var matcherListByComponent:Dictionary = new Dictionary();

	/**
	 * Indicates if the engine is currently in its update loop.
	 */
	public var updating:Boolean;

	/**
	 * Dispatched when the update loop ends. If you want to add and remove systems from the
	 * engine it is usually best not to do so during the update loop. To avoid this you can
	 * listen for this signal and make the change when the signal is dispatched.
	 */
	public var updateComplete:Signal0;

	/**
	 * Constructor
	 */
	public function Engine() {
		entityList = new EntityList();
		entityNames = new Dictionary();
		systemList = new SystemList();
		updateComplete = new Signal0();
	}

	/**
	 * Add an entity to the engine.
	 *
	 * @param entity The entity to add.
	 */

	public function addEntity(entity:Entity):void {
		if (entityNames[ entity.name ]) {
			throw new Error("The entity name " + entity.name + " is already in use by another entity.");
		}
		entity._engine = this;
		entityList.add(entity);
		entityNames[ entity.name ] = entity;

		entity.componentAdded.add(componentAdded);
		entity.componentRemoved.add(componentRemoved);
		entity.nameChanged.add(entityNameChanged);

		for (var componentClass:* in entity.components) {
			var matcherList:Vector.<NodeMatcher> = matcherListByComponent[componentClass];
			if (matcherList) {
				for each(var matcher:NodeMatcher in matcherList) {
					matcher.entityAdded(entity);
				}
			}
		}
	}

	/**
	 * Remove an entity from the engine.
	 *
	 * @param entity The entity to remove.
	 */
	public function removeEntity(entity:Entity):void {
		entity.componentAdded.remove(componentAdded);
		entity.componentRemoved.remove(componentRemoved);
		entity.nameChanged.remove(entityNameChanged);

		for (var componentClass:* in entity.components) {
			var matcherList:Vector.<NodeMatcher> = matcherListByComponent[componentClass];
			if (matcherList) {
				for each(var matcher:NodeMatcher in matcherList) {
					matcher.entityRemoved(entity);
				}
			}
		}

		delete entityNames[ entity.name ];
		entityList.remove(entity);
		entity._engine = null;
	}

	private function entityNameChanged(entity:Entity, oldName:String):void {
		if (entityNames[ oldName ] == entity) {
			delete entityNames[ oldName ];
			entityNames[ entity.name ] = entity;
		}
	}

	/**
	 * Get an entity based on its name.
	 *
	 * @param name The name of the entity
	 * @return The entity, or null if no entity with that name exists on the engine
	 */
	public function getEntityByName(name:String):Entity {
		return entityNames[ name ];
	}

	/**
	 * Remove all entities from the engine.
	 */
	public function removeAllEntities():void {
		while (entityList.head) {
			removeEntity(entityList.head);
		}
	}

	/**
	 * Returns a vector containing all the entities in the engine.
	 */
	public function get entities():Vector.<Entity> {
		var entities:Vector.<Entity> = new Vector.<Entity>();
		for (var entity:Entity = entityList.head; entity; entity = entity.next) {
			entities.push(entity);
		}
		return entities;
	}

	/**
	 * @private
	 */
	private function componentAdded(entity:Entity, componentClass:Class):void {
		var matcherList:Vector.<NodeMatcher> = matcherListByComponent[componentClass];
		if (matcherList) {
			for each(var matcher:NodeMatcher in matcherList) {
				matcher.componentAdded(entity);
			}
		}
	}

	/**
	 * @private
	 */
	private function componentRemoved(entity:Entity, componentClass:Class):void {
		var matcherList:Vector.<NodeMatcher> = matcherListByComponent[componentClass];
		if (matcherList) {
			for each(var matcher:NodeMatcher in matcherList) {
				matcher.componentRemoved(entity, componentClass);
			}
		}
	}

	/**
	 * Get a collection of nodes from the engine, based on the type of the node required.
	 *
	 * <p>The engine will create the appropriate NodeList if it doesn't already exist and
	 * will keep its contents up to date as entities are added to and removed from the
	 * engine.</p>
	 *
	 * <p>If a NodeList is no longer required, release it with the releaseNodeList method.</p>
	 *
	 * @param nodeClass The type of node required.
	 * @return A linked list of all nodes of this type from all entities in the engine.
	 */
	public function getNodeList(nodeClass:Class):NodeList {
		return ( nodeMatcherMap[nodeClass] || createNodeMatcher(nodeClass) ).nodeList;
	}

	/**
	 * If a NodeList is no longer required, this method will stop the engine updating
	 * the list and will release all references to the list within the framework
	 * classes, enabling it to be garbage collected.
	 *
	 * <p>It is not essential to release a list, but releasing it will free
	 * up memory and processor resources.</p>
	 *
	 * @param nodeClass The type of the node class if the list to be released.
	 */
	public function releaseNodeList(nodeClass:Class):void {
		var matcher:NodeMatcher = nodeMatcherMap[nodeClass];
		if (matcher) {
			matcher.clear();
			delete nodeMatcherMap[nodeClass];
		}
	}

	
	[Inline]
	private function createNodeMatcher(nodeClass:Class):NodeMatcher {
		var matcher:NodeMatcher = nodeMatcherMap[nodeClass] = new NodeMatcher(nodeClass, this);

		for (var entity:Entity = entityList.head; entity; entity = entity.next) {
			matcher.entityAdded(entity);
		}

		// subscribe for new components notification
		for each(var componentClass:Class in matcher.componentSet) {
			var matcherList:Vector.<NodeMatcher> = ( matcherListByComponent[componentClass] ||= new Vector.<NodeMatcher>() );
			matcherList.push(matcher);
		}

		return matcher;
	}


	/**
	 * Add a system to the engine, and set its priority for the order in which the
	 * systems are updated by the engine update loop.
	 *
	 * <p>The priority dictates the order in which the systems are updated by the engine update
	 * loop. Lower numbers for priority are updated first. i.e. a priority of 1 is
	 * updated before a priority of 2.</p>
	 *
	 * @param system The system to add to the engine.
	 * @param priority The priority for updating the systems during the engine loop. A
	 * lower number means the system is updated sooner.
	 */
	public function addSystem(system:System, priority:int = 0):void {
		system.priority = priority;
		system.addToEngine(this);
		systemList.add(system);
	}

	/**
	 * Get the system instance of a particular type from within the engine.
	 *
	 * @param type The type of system
	 * @return The instance of the system type that is in the engine, or
	 * null if no systems of this type are in the engine.
	 */
	public function getSystem(type:Class):System {
		return systemList.get(type);
	}

	/**
	 * Returns a vector containing all the systems in the engine.
	 */
	public function get systems():Vector.<System> {
		var systems:Vector.<System> = new Vector.<System>();
		for (var system:System = systemList.head; system; system = system.next) {
			systems.push(system);
		}
		return systems;
	}

	/**
	 * Remove a system from the engine.
	 *
	 * @param system The system to remove from the engine.
	 */
	public function removeSystem(system:System):void {
		systemList.remove(system);
		system.removeFromEngine(this);
	}

	/**
	 * Remove all systems from the engine.
	 */
	public function removeAllSystems():void {
		while (systemList.head) {
			removeSystem(systemList.head);
		}
	}

	/**
	 * Update the engine. This causes the engine update loop to run, calling update on all the
	 * systems in the engine.
	 *
	 * <p>The package net.richardlord.ash.tick contains classes that can be used to provide
	 * a steady or variable tick that calls this update method.</p>
	 *
	 * @time The duration, in seconds, of this update step.
	 */
	public function update(time:Number):void {
		updating = true;
		for (var system:System = systemList.head; system; system = system.next) {
			system.update(time);
		}
		updating = false;
		updateComplete.dispatch();
	}
}
}
