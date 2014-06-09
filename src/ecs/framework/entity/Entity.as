package ecs.framework.entity {
import ecs.engine.core.ESUnit;
import ecs.framework.api.ecs_core;
import ecs.framework.components.api.IComponentHandler;
import ecs.lists.LinkedSet;
import ecs.lists.Node;

import com.flashrush.signatures.BitSign;

import flash.utils.Dictionary;

use namespace ecs_core;

/**
 * An entity is composed from components. As such, it is essentially a collection object for components.
 * Sometimes, the entities in a game will mirror the actual characters and objects in the game, but this
 * is not necessary.
 *
 * <p>Components are simple value objects that contain data relevant to the entity. Entities
 * with similar functionality will have instances of the same components. So we might have
 * a position component</p>
 *
 * <p><code>public class PositionComponent
 * {
	 *   public var x : Number;
	 *   public var y : Number;
	 * }</code></p>
 *
 * <p>All entities that have a position in the game world, will have an instance of the
 * position component. Systems operate on entities based on the components they have.</p>
 */
public class Entity extends ESUnit {
	ecs_core static var idIndex:uint = 0;

	ecs_core var _id:uint;

	ecs_core var _alive:Boolean = false;

	ecs_core var components:Dictionary = new Dictionary();

	ecs_core var _componentCount:uint = 0;

	ecs_core var componentHandlers:LinkedSet = new LinkedSet();

	ecs_core var sign:BitSign;

	public var name:String;

	/* list links */

	//ecs_core var prev:Entity;
	//ecs_core var next:Entity;

	/**
	 * The constructor
	 */
	public function Entity() {
		idIndex++;
		_id = idIndex;
		super();
	}

	[Inline]
	public final function get id():uint {
		return _id;
	}

	public function get componentCount():uint {
		return _componentCount;
	}

	/**
	 *  Determines whether the entity was added and wasn't removed from an engine.
	 */
	[Inline]
	public final function get alive():Boolean {
		return _alive;
	}

	/**
	 * Add a component to the entity.
	 *
	 * @param component The component object to add.
	 * @param type The class of the component. This is only necessary if the component
	 * extends another component class and you want the framework to treat the component as of
	 * the base class type. If not set, the class type is determined directly from the component.
	 *
	 * @return A reference to the entity. This enables the chaining of calls to add, to make
	 * creating and configuring entities cleaner. e.g.
	 *
	 * <code>var entity : Entity = new Entity()
	 *     .add( new Position( 100, 200 )
	 *     .add( new Display( new PlayerClip() );</code>
	 */
	public function add( component:Object, type:Class = null ):Entity {
		if ( !type ) {
			type = component.constructor;
		}

		// if already contains a component of the type, remove it first
		if ( components[ type ] ) {
			remove( type );
		}

		// add
		components[ type ] = component;
		_componentCount++;

		// notify handlers
		var node:Node = componentHandlers.$firstNode;
		while ( node ) {
			var handler:IComponentHandler = node.content;
			handler.onComponentAdded( this, type, component );
			node = node.next;
		}

		return this;
	}

	/**
	 * Remove a component from the entity.
	 *
	 * @param type The class of the component to be removed.
	 * @return the component, or null if the component doesn't exist in the entity
	 */
	public function remove( type:Class ):* {
		var component:* = components[ type ];
		if ( component ) {
			delete components[ type ];
			_componentCount--;

			// notify handlers
			var node:Node = componentHandlers.$firstNode;
			while ( node ) {
				var handler:IComponentHandler = node.content;
				handler.onComponentRemoved( this, type, component );
				node = node.next;
			}

			return component;
		}
		return null;
	}

	public function removeAll():void {
		for ( var componentId:Class in components ) {
			remove( componentId );
		}
	}

	/**
	 * Get a component from the entity.
	 *
	 * @param componentClass The class of the component requested.
	 * @return The component, or null if none was found.
	 */
	[Inline]
	public final function get( componentClass:Class ):* {
		return components[ componentClass ];
	}

	/**
	 * Get all components from the entity.
	 *
	 * @return An array containing all the components that are on the entity.
	 */
	public function getAll( result:Array = null ):Array {
		result ||= [];
		var i:int = result.length;
		for each( var component:* in components ) {
			result[i] = component;
			i++;
		}
		return result;
	}

	/**
	 * Does the entity have a component of a particular type.
	 *
	 * @param componentClass The class of the component sought.
	 * @return true if the entity has a component of the type, false if not.
	 */
	[Inline]
	public final function has( componentClass:Class ):Boolean {
		return components[ componentClass ] != null;
	}

	public function toString():String {
		//return "Entity(id=" + id.toString() + ")";
		return "Entity(name=\"" + name + "\", id=" + id.toString() + ")";
	}


	ecs_core function addComponentHandler( handler:IComponentHandler ):void {
		componentHandlers.add( handler );
	}

	ecs_core function removeComponentHandler( handler:IComponentHandler ):void {
		componentHandlers.remove( handler );
	}
}
}
