package ashx.engine.entity {
import ash.signals.Signal2;

import ashx.engine.components.IComponentHandler;
import ashx.engine.ecse;
import ashx.engine.lists.LinkedSet;

import com.flashrush.signatures.BitSign;

import flash.utils.Dictionary;

use namespace ecse;

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
public class Entity {
	ecse static var idIndex:uint = 0;

	ecse var _id:uint;
	private var _name:String;

	ecse var components:Dictionary;

	ecse var _componentCount:uint = 0;

	ecse var sign:BitSign;

	ecse var _alive:Boolean = false;

	ecse var componentHandler:IComponentHandler;

	//protected var componentHandlers:LinkedSet;
	//protected var _componentAdded:Signal2;
	//protected var _componentRemoved:Signal2;

	/* list links */

	ecse var prev:Entity;
	ecse var next:Entity;

	/**
	 * The constructor
	 *
	 * @param name The name for the entity. If left blank, a default name is assigned with the form _entityN where N is an integer.
	 */
	public function Entity( name:String = null ) {
		idIndex++;
		_id = idIndex;

		//_componentAdded = new Signal2( Entity, Class );
		//_componentRemoved = new Signal2( Entity, Class );
		components = new Dictionary();
		//componentHandlers = new LinkedSet();
		_name = name;
	}

	[Inline]
	public final function get id():uint {
		return _id;
	}

	[Inline]
	public final function get name():String {
		return _name;
	}

	public function set name( value:String ):void {
		_name = value;
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

	/*[Inline]
	public final function get componentAdded():Signal2 {
		return _componentAdded;
	}

	[Inline]
	public final function get componentRemoved():Signal2 {
		return _componentRemoved;
	}*/

	/**
	 * Add a component to the entity.
	 *
	 * @param component The component object to add.
	 * @param componentClass The class of the component. This is only necessary if the component
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
	public function add( component:Object, componentClass:Class = null ):Entity {
		if ( !componentClass ) {
			componentClass = Class( component.constructor );
		}
		if ( components[ componentClass ] ) {
			remove( componentClass );
		}
		components[ componentClass ] = component;
		_componentCount++;

		if ( componentHandler ) {
			componentHandler.onComponentAdded( this, component, componentClass );
		}

		/*// notify observers
		for ( var node:ItemNode = componentHandlers.ecse::$firstNode; node; node = node.next ) {
			var handler:IComponentHandler = node.item;
			handler.onComponentAdded( this, component, componentClass );
		}

		_componentAdded.dispatch( this, componentClass );*/

		return this;
	}

	/**
	 * Remove a component from the entity.
	 *
	 * @param componentClass The class of the component to be removed.
	 * @return the component, or null if the component doesn't exist in the entity
	 */
	public function remove( componentClass:Class ):* {
		var component:* = components[ componentClass ];
		if ( component ) {
			delete components[ componentClass ];
			_componentCount--;

			if ( componentHandler ) {
				componentHandler.onComponentRemoved( this, component, componentClass );
			}

			/*// notify observers
			for ( var node:ItemNode = componentHandlers.$firstNode; node; node = node.next ) {
				var handler:IComponentHandler = node.item;
				handler.onComponentRemoved( this, component, componentClass );
			}

			_componentRemoved.dispatch( this, componentClass );*/

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
		return "Entity(name=\"" + name + "\", id=" + id.toString() + ")";
	}

}
}
