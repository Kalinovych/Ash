package flashrush.asentity.framework.entity {
import com.flashrush.utils.ClassUtil;

import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.components.api.IComponentHandler;
import flashrush.gdf.api.gdf_core;
import flashrush.ds.LinkedSet;
import flashrush.ds.Node;
import flashrush.signatures.api.ISignature;

use namespace asentity;
use namespace gdf_core;

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
	asentity static var idIndex:uint = 0;

	asentity var _id:uint;
	asentity var _alive:Boolean = false;

	asentity var _components:Dictionary = new Dictionary();
	asentity var _componentCount:uint = 0;
	asentity var _componentHandlers:LinkedSet = new LinkedSet();
	asentity var _sign:ISignature;

	/* list links */

	asentity var prev:Entity;
	asentity var next:Entity;

	/**
	 * Constructor
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

	/**
	 *  Determines whether the entity was added and wasn't removed from an engine.
	 */
	[Inline]
	public final function get alive():Boolean {
		return _alive;
	}

	[Inline]
	public final function get componentCount():uint {
		return _componentCount;
	}

	[Inline]
	public final function get sign():ISignature {
		return _sign;
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
		var current:* = _components[type];
		if ( current ) {
			if ( component === current ) {
				return this;
			}
			remove( type );
		}

		// add
		_components[ type ] = component;
		_componentCount++;

		// notify handlers
		var node:Node = _componentHandlers.firstNode;
		while ( node ) {
			var handler:IComponentHandler = node.item;
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
		var component:* = _components[ type ];
		if ( component ) {
			delete _components[ type ];
			_componentCount--;

			// notify handlers
			var node:Node = _componentHandlers.firstNode;
			while ( node ) {
				var handler:IComponentHandler = node.item;
				handler.onComponentRemoved( this, type, component );
				node = node.next;
			}

			return component;
		}
		return null;
	}

	public function removeAll():void {
		for ( var componentId:Class in _components ) {
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
		return _components[ componentClass ];
	}

	/**
	 * Get all components from the entity.
	 *
	 * @return An array containing all the components that are on the entity.
	 */
	public function getAll( output:Array = null ):Array {
		output ||= [];
		var i:int = output.length;
		for each( var component:* in _components ) {
			output[i] = component;
			i++;
		}
		return output;
	}

	/**
	 * Does the entity have a component of a particular type.
	 *
	 * @param componentClass The class of the component sought.
	 * @return true if the entity has a component of the type, false if not.
	 */
	[Inline]
	public final function has( componentClass:Class ):Boolean {
		return _components[ componentClass ] != null;
	}

	public function toString():String {
		//return "Entity(id=" + id.toString() + ")";
		//return "Entity(name=\"" + name + "\", id=" + id.toString() + ")";
		//return "Entity(id=" + _id + ")[" + componentsToStr() +"]";
		//return "Entity_" + _id + "[" + componentsToStr() +"]";
		//return "[Entity_" + _id + "{" + componentsToStr() + "})";
		return "{Entity" + _id + "[" + componentsToStr() + "]}"; // {Entity123[Pos,Body,Graphics]}
	}

	private function componentsToStr():String {
		var result:String = "";
		for ( var type:Class in _components ) {
			result && (result += ",");
			result += ClassUtil.getLocalName( type );
		}
		return result;
	}


	asentity function addComponentHandler( handler:IComponentHandler ):void {
		_componentHandlers.add( handler );
	}

	asentity function removeComponentHandler( handler:IComponentHandler ):void {
		_componentHandlers.remove( handler );
	}
}
}
