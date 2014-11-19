package flashrush.asentity.framework.entity {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.componentManager.IComponentHandler;
import flashrush.asentity.framework.core.EntitySpace;
import flashrush.asentity.framework.components.IComponentProcessor;
import flashrush.asentity.framework.utils.BitSign;
import flashrush.collections.LinkedSet;
import flashrush.collections.LLNodeBase;
import flashrush.collections.list_internal;
import flashrush.utils.getClassName;

use namespace asentity;

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
	private static var idIndex:uint = 0;
	
	private var _id:uint;
	
	asentity var _components:Dictionary = new Dictionary();
	asentity var _componentCount:uint = 0;
	asentity var componentBits:BitSign;
	asentity var componentHandlers:LinkedSet/*<IComponentObserver>*/ = new LinkedSet();
	
	asentity var space:EntitySpace;
	asentity var prev:Entity;
	asentity var next:Entity;
	
	/**
	 * Constructor
	 */
	public function Entity() {
		_id = ++idIndex;
	}
	
	public final function get id():uint {
		return _id;
	}
	
	/**
	 *  Determines whether the entity currently in a space.
	 */
	public final function get alive():Boolean {
		return (space != null);
	}
	
	public final function get componentCount():uint {
		return _componentCount;
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
		const current:* = _components[type];
		if ( current ) {
			if ( component === current ) {
				return this;
			}
			remove( type );
		}
		
		// add
		_components[type] = component;
		++_componentCount;
		
		// notify observers
		use namespace list_internal;
		
		for ( var node:LLNodeBase = componentHandlers.first; node; node = node.next ) {
			const observer:IComponentProcessor = node.item;
			observer.processAddedComponent( this, type, component );
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
		var component:* = _components[type];
		if ( !component ) {
			return null;
		}
		
		delete _components[type];
		--_componentCount;
		
		// notify observers
		use namespace list_internal;
		
		for ( var node:LLNodeBase = componentHandlers.first; node; node = node.next ) {
			const observer:IComponentProcessor = node.item;
			observer.processRemovedComponent( this, type, component );
		}
		return component;
	}
	
	public function removeAll():void {
		for ( var component:Class in _components ) {
			remove( component );
		}
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
	 *****
	 * Regular solution - component aggregator.
	 * Pros:
	 *   + Do not require to modify the framework.
	 *   + Personal specific implementations.
	 *   + Aggregated control of sub-component properties.
	 * Cons:
	 *   - Manual(out of engine) aggregator implementation for each component type that can be added multiple
	 *   - Require solution to notify about added/removed sub-component. 
	 *   
	 * Explanation sample:
	 *   component Armor {
	 *     value:Number;
	 *     
	 *     items:[Armor];
	 *     
	 *     add(Armor)->{add...; updateValue();}
	 *     remove(Armor)->{remove...; updateValue();};
	 *   }
	 *
	 *   var bonusArmor = new Armor(10);
	 *   unitArmor = entity.get(Armor);
	 *   unitArmor
	 *      ? unitArmor.add(bonusArmor)
	 *      : entity.add(bonusArmor);
	 *      
	 *   
	 *
	 *****
	 * Stackable component solution.
	 * Pros: Auto-managed by Entity
	 * Cons: one-to-one component-entity relation, e.g. not able to use shared/singleton components.
	 * 
	 * Component interface:
	 * component T {
	 *   prev:T
	 *   next:T
	 * }
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
		dest ? dest.length = _componentCount : dest = [];
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
		return ( _components[type] != null );
	}
	
	public function toString():String {
		return "[Entity" + _id + "{" + componentsToStr() + "}]"; // [Entity3248{Pos,Body,Graphics}]
	}
	
	//-------------------------------------------
	// Internals
	//-------------------------------------------
	
	asentity function addComponentHandler( handler:IComponentHandler ):void {
		componentHandlers.add( handler );
	}
	
	asentity function removeComponentHandler( handler:IComponentHandler ):void {
		componentHandlers.remove( handler );
	}
	
	//-------------------------------------------
	// Protected methods
	//-------------------------------------------
	
	protected function componentsToStr():String {
		var result:String = "";
		for ( var type:Class in _components ) {
			result && (result += ",");
			result += getClassName( type );
		}
		return result;
	}
	
	
}
}
