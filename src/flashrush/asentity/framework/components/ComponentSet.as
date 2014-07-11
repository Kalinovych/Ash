/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.components {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.components.api.IComponentHandler;
import flashrush.gdf.api.gdf_core;
import flashrush.gdf.ds.LinkedSet;
import flashrush.gdf.ds.Node;
import flashrush.signatures.api.ISignature;

use namespace asentity;
use namespace gdf_core;

public class ComponentSet {
	asentity var _components:Dictionary = new Dictionary();
	asentity var _componentCount:uint = 0;
	asentity var _handlers:LinkedSet = new LinkedSet();
	asentity var _signature:ISignature;

	public function ComponentSet() {
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
	public function add( component:Object, type:Class = null ):ComponentSet {
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
		var node:Node = _handlers.$firstNode;
		while ( node ) {
			var handler:IComponentHandler = node.item;
			//handler.onComponentAdded( this, type, component );
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
			var node:Node = _handlers.$firstNode;
			while ( node ) {
				var handler:IComponentHandler = node.item;
				//handler.onComponentRemoved( this, type, component );
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
	public function getAll( result:Array = null ):Array {
		result ||= [];
		var i:int = result.length;
		for each( var component:* in _components ) {
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
		return _components[ componentClass ] != null;
	}

	asentity function addHandler( handler:IComponentHandler ):void {
		_handlers.add( handler );
	}

	asentity function removeHandler( handler:IComponentHandler ):void {
		_handlers.remove( handler );
	}
}
}
