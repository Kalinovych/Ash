package ash.core {

import ash.engine.ecse;
import ash.signals.Signal0;

import com.flashrush.signatures.BitSignManager;

import flash.utils.Dictionary;


use namespace ecse;

/**
 * The Engine class is the central point for creating and managing your game state. Add
 * entities and systems to the engine, and fetch families of nodes from the engine.
 */
public class Engine {
	private var entityByName:Dictionary;
	private var entityList:EntityList;
	private var systemList:SystemList;

	/**
	 * Family by a node class
	 */
	private var familyMap:Dictionary = new Dictionary();

	/**
	 * Vectors of Family by a component class.
	 *
	 * Designed to optimize node matchers notification about a component added or removed from an Entity.
	 * The Engine will process only a list of matchers interested in added/removed component.
	 * Matchers not interested in a component stays out of notification loop.
	 */
	private var familiesByComponent:Dictionary = new Dictionary();

	private var signManager:BitSignManager;

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
	public function Engine( componentCapacityLevel:uint = 1 ) {
		entityList = new EntityList();
		entityByName = new Dictionary();
		systemList = new SystemList();
		updateComplete = new Signal0();

		signManager = new BitSignManager( componentCapacityLevel );
	}

	/*public function addProcess(process:IEngineProcess, priority:int):void {
		if (process is IEntityProcessor) mEntityProcessorList.add(process, priority);
		if (process is IComponentProcessor) mComponentProcessorList.add(process, priority);
		if (process is IEnginePreUpdateHandler) mEnginePreUpdateHandlerList.add(process, priority);
		if (process is IEngineUpdateHandler) mEngineUpdateHandlerList.add(process, priority);
		if (process is IEnginePostUpdateHandler) mEnginePostUpdateHandlerList.add(process, priority);
		
		//process.addedToEngine( this );
	}

	public function upd( deltaTime:Number ):void {
		var node:ProcessorNode = mEnginePreUpdateHandlerList.head.next;
		while (node != mEnginePreUpdateHandlerList.tail) {
			var preUpdateHandler:IEnginePreUpdateHandler = node.processor;
			preUpdateHandler.preUpdate();
		}
		
		updating = true;
		
		node = mEngineUpdateHandlerList.head.next;
		while (node != mEngineUpdateHandlerList.tail) {
			var updateHandler:IEngineUpdateHandler = node.processor;
			updateHandler.update( deltaTime );
		}

		updating = false;

		node = mEnginePostUpdateHandlerList.head.next;
		while (node != mEngineUpdateHandlerList.tail) {
			var postUpdateHandler:IEnginePostUpdateHandler = node.processor;
			postUpdateHandler.postUpdate();
		}
	}

	/**
	 * Add an entity to the engine.
	 *
	 * @param entity The entity to add.
	 */

	public function addEntity( entity:Entity ):void {
		if ( entityByName[ entity.id ] ) {
			throw new Error( "The entity name " + entity.name + " is already in use by another entity." );
		}

		entity.sign = signManager.signKeys( entity.components );

		entity._engine = this;
		entityList.add( entity );
		entityByName[ entity.id ] = entity;

		entity.componentAdded.add( componentAdded );
		entity.componentRemoved.add( componentRemoved );
		entity.nameChanged.add( entityNameChanged );

		for each( var family:Family in familyMap ) {
			if ( entityBelongToFamily( entity, family ) ) {
				family.addEntity( entity );
			}
		}
	}

	/**
	 * Remove an entity from the engine.
	 *
	 * @param entity The entity to remove.
	 */
	public function removeEntity( entity:Entity ):void {
		entity.componentAdded.remove( componentAdded );
		entity.componentRemoved.remove( componentRemoved );
		entity.nameChanged.remove( entityNameChanged );

		for each( var family:Family in familyMap ) {
			if ( entityBelongToFamily( entity, family ) ) {
				family.removeEntity( entity );
			}
		}

		delete entityByName[ entity.id ];
		entityList.remove( entity );
		signManager.recycleSign( entity.sign );
		entity.sign = null;
		entity._engine = null;
	}

	/**
	 * @private
	 */
	protected function componentAdded( entity:Entity, componentClass:Class ):void {
		// put component bit to the entity dna
		entity.sign.add( componentClass );

		var familyList:Vector.<Family> = familiesByComponent[componentClass];
		if ( familyList && familyList.length ) {
			for each( var family:Family in familyList ) {
				if ( entity.sign.contains( family.sign ) ) {
					family.componentAdded( entity, componentClass );
				}
			}
		}
	}

	/**
	 * @private
	 */
	protected function componentRemoved( entity:Entity, componentClass:Class ):void {
		var familyList:Vector.<Family> = familiesByComponent[componentClass];
		if ( familyList && familyList.length ) {
			for each( var family:Family in familyList ) {
				if ( entity.sign.contains( family.sign ) ) {
					family.componentRemoved( entity, componentClass );
				}
			}
		}

		entity.sign.remove( componentClass );
	}

	/**
	 * Return true if the entity in the engine
	 * @param entity
	 * @return
	 */
	public function hasEntity( entity:Entity ):Boolean {
		return (entityByName[entity.name] == entity);
	}

	protected function entityNameChanged( entity:Entity, oldName:String ):void {
		if ( entityByName[ oldName ] == entity ) {
			delete entityByName[ oldName ];
			entityByName[ entity.name ] = entity;
		}
	}

	/**
	 * Get an entity based on its name.
	 *
	 * @param name The name of the entity
	 * @return The entity, or null if no entity with that name exists on the engine
	 */
	public function getEntityByName( name:String ):Entity {
		return entityByName[ name ];
	}

	/**
	 * Return node of the entity if the entity belong to a family of the node.
	 * Return null if family of the node not exists or not created yet.
	 * @param entity
	 * @param nodeClass
	 * @return
	 */
	public function entityAsNode( entity:Entity, nodeClass:Class ):* {
		var family:Family = familyMap[nodeClass];
		return (family ? family.nodeByEntity[entity] : null);
	}

	/**
	 * Search an Entity with the name and try to get it's node with type of nodeClass.
	 * @param name The name of the entity to find
	 * @param nodeClass The Class that represents the family
	 * @return A node of nodeClass type of the entity with the name, otherwise null
	 */
	public function getEntityNode( name:String, nodeClass:Class ):* {
		return entityAsNode( getEntityByName( name ), nodeClass );
	}

	/**
	 * Remove all entities from the engine.
	 */
	public function removeAllEntities():void {
		while ( entityList.head ) {
			removeEntity( entityList.head );
		}
	}

	/**
	 * Returns a vector containing all the entities in the engine.
	 */
	public function getEntityList():Vector.<Entity> {
		var entities:Vector.<Entity> = new Vector.<Entity>( entityList.length );
		for ( var entity:Entity = entityList.head, i:int = 0; entity; entity = entity.next, i++ ) {
			entities[i] = entity;
		}
		return entities;
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
	public function getNodeList( nodeClass:Class ):NodeList {
		return ( familyMap[nodeClass] || inline_createFamily( nodeClass ) ).nodeList;
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
	public function releaseNodeList( nodeClass:Class ):void {
		var family:Family = familyMap[nodeClass];
		if ( family ) {
			// unsubscribe for components add/remove notification
			for each( var componentClass:Class in family.componentInterests ) {
				var familyList:Vector.<Family> = familiesByComponent[componentClass];
				var index:int = familyList.indexOf( family );
				if ( index >= 0 ) {
					familyList.splice( index, 1 );
				}
			}

			family.clear();
			delete familyMap[nodeClass];
		}
	}


	[Inline]
	protected final function inline_createFamily( nodeClass:Class ):Family {
		var family:Family = familyMap[nodeClass] = new Family( nodeClass, this );
		family.sign = signManager.signKeys( family.propertyMap );
		if ( family.excludedComponents ) {
			family.exclusionSign = signManager.signKeys( family.excludedComponents );
		}

		// find all entities matching to the new family
		for ( var entity:Entity = entityList.head; entity; entity = entity.next ) {
			if ( entityBelongToFamily( entity, family ) ) {
				family.addEntity( entity );
			}
		}

		// subscribe for handling added/removed components interested in
		for each( var componentClass:Class in family.componentInterests ) {
			var familyList:Vector.<Family> = ( familiesByComponent[componentClass] ||= new <Family>[] );
			familyList[familyList.length] = family;
		}

		return family;
	}

	[Inline]
	protected final function entityBelongToFamily( entity:Entity, family:Family ):Boolean {
		return ( entity.sign.contains( family.sign ) && !( family.exclusionSign && entity.sign.contains( family.exclusionSign ) ) );
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
	public function addSystem( system:System, priority:int = 0 ):void {
		system.priority = priority;
		system.addToEngine( this );
		systemList.add( system );
	}

	/**
	 * Get the system instance of a particular type from within the engine.
	 *
	 * @param type The type of system
	 * @return The instance of the system type that is in the engine, or
	 * null if no systems of this type are in the engine.
	 */
	public function getSystem( type:Class ):System {
		return systemList.get( type );
	}

	/**
	 * Returns a vector containing all the systems in the engine.
	 */
	public function getSystemList():Vector.<System> {
		var systems:Vector.<System> = new Vector.<System>( systemList.length );
		for ( var system:System = systemList.head, i:int = 0; system; system = system.next, i++ ) {
			systems[i] = system;
		}
		return systems;
	}

	public function get rawSystemList():SystemList {
		return systemList;
	}

	/**
	 * Remove a system from the engine.
	 *
	 * @param system The system to remove from the engine.
	 */
	public function removeSystem( system:System ):void {
		systemList.remove( system );
		system.removeFromEngine( this );
	}

	/**
	 * Remove all systems from the engine.
	 */
	public function removeAllSystems():void {
		while ( systemList.head ) {
			removeSystem( systemList.head );
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
	public function update( time:Number ):void {
		updating = true;
		for ( var system:System = systemList.head; system; system = system.next ) {
			system.update( time );
		}
		updating = false;
		updateComplete.dispatch();
	}
}
}
