package flashrush.asentity.framework.entity {
import flash.utils.Dictionary;

import flashrush.asentity.framework.Space;
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.components.api.IComponentHandler;
import flashrush.ds.LinkedSet;
import flashrush.ds.Node;
import flashrush.gdf.api.gdf_core;
import flashrush.signatures.api.ISignature;
import flashrush.utils.getClassName;

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
	
	asentity var _space:Space;
	//asentity var _inSpace:Boolean = false;
	
	asentity var _components:Dictionary = new Dictionary();
	asentity var _componentCount:uint = 0;
	asentity var _componentHandlers:LinkedSet = new LinkedSet();
	asentity var _sign:ISignature;
	
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
	
	public final function get id():uint {
		return _id;
	}
	
	public final function get space():Space {
		return _space;
	}
	
	/**
	 *  Determines whether the entity was added and wasn't removed from an engine.
	 */
	public final function get isInSpace():Boolean {
		return (_space);
	}
	
	public final function get componentCount():uint {
		return _componentCount;
	}
	
	public final function get sign():ISignature {
		return _sign;
	}
	
	/*public final function get prev():Entity {
		return asentity::prev;
	}
	
	public final function get next():Entity {
		return asentity::next;
	}*/
	
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
		_components[type] = component;
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
	 * DEV:
	 *
	 * The main goal:
	 *  Stackable components - multiple component instances of the same type in the one Entity.
	 *
	 * High order requirement:
	 *  The feature should be implemented in a such way
	 *  to have smallest impact to the main add/remove functionality
	 *  and it should not burden it.
	 *
	 *
	 * Stackable component props:
	 *  prev:T
	 *  next:T
	 *
	 * ADD:
	 *  If the component is stackable and another component with such type already exists
	 *  in the Entity, the component will be stacked with others of the same type
	 *  instead of replacing it.
	 *  If a type of the component is new to this entity the behaviour same to 'add' method.
	 *
	 * GET:
	 *  Returns the first component. Using 'next' property can be iterated over an others.
	 *
	 * REMOVE:
	 *  The method 'remove(componentType)' removes the first and all linked to it components.
	 *  TODO: So we need an additional method to make able to remove a single instance of stackable component.
	 *  Solve options: Entity's method like 'remove' but for one instance
	 *      or Component's method like 'removeFromParent' what is the bad idea.
	 *
	 *  function takeout(component, type):T;
	 *
	 *  method names:
	 *   takeout
	 *   extract
	 *   removeOf
	 *   removeAt
	 *   removeOne
	 */
	public function append( component:Object, type:Class = null ):Entity {
		if ( !type ) {
			type = component.constructor;
		}
		var current:* = _components[type];
		if ( current ) {
			if ( component === current ) {
				return this;
			}
			
			// append the component to the end of current stack
			var last:* = current;
			while ( last.next ) {
				last = last.next;
			}
			last.next = component;
			component.prev = last;
			component.next = null;
			
		} else {
			add( component, type );
		}
		return this;
	}
	
	public function takeout( component:Object, type:Class = null ):* {
		type ||= component.constructor;
		
		const head:Object = _components[type];
		if ( !head ) {
			return null;
		}
		
		if ( head == component && !head.next ) {
			return remove( type );
		}
		
		for ( var item:* = head; item; item = item.next ) {
			// found
			if ( item == component ) {
				if ( component == head ) {
					_components[type] = component.next;
					component.next.prev = null;
				} else {
					component.prev.next = component.next;
					if ( component.next ) {
						component.next.prev = component.prev;
					}
				}
				return component;
			}
		}
		
		return null;
	}
	
	/**
	 * Remove a component from the entity.
	 *
	 * @param type The class of the component to be removed.
	 * @return the component, or null if the component doesn't exist in the entity
	 */
	public function remove( type:Class ):* {
		var component:* = _components[type];
		if ( component ) {
			delete _components[type];
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
	 * @param type The class of the component requested.
	 * @return The component, or null if none was found.
	 */
	[Inline]
	public final function get( type:Class ):* {
		return _components[type];
	}
	
	/**
	 * Get all components from the entity.
	 *
	 * @return An array containing all the components that are on the entity.
	 */
	public function getAll( dest:Array = null ):Array {
		dest ? dest.length = _componentCount	: dest = [];
		var i:int = 0;
		for each( var component:* in _components ) {
			dest[i++] = component;
		}
		return dest;
	}
	
	/**
	 * Does the entity have a component of a particular type.
	 *
	 * @param type The class of the component sought.
	 * @return true if the entity has a component of the type, false if not.
	 */
	[Inline]
	public final function has( type:Class ):Boolean {
		return _components[type] != null;
	}
	
	public function toString():String {
		return "[Entity" + _id + "{" + componentsToStr() + "}]"; // [Entity3248{Pos,Body,Graphics}]
	}
	
	private function componentsToStr():String {
		var result:String = "";
		for ( var type:Class in _components ) {
			result && (result += ",");
			result += getClassName( type );
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
