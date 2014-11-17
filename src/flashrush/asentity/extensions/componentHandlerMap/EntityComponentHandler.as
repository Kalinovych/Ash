/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentHandlerMap {
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.components.*;
import flashrush.asentity.framework.entity.Entity;
import flashrush.collections.LinkedSet;
import flashrush.collections.base.LLNodeBase;
import flashrush.collections.list_internal;

use namespace asentity;

public class EntityComponentHandler implements IComponentProcessor {
	private var _entity:Entity;
	private var _componentType:Class;
	private var _processors:LinkedSet;
	
	public function EntityComponentHandler( entity:Entity, componentType:Class ) {
		_entity = entity;
		_componentType = componentType;
	}
	
	public function activate():void {
		_entity.addComponentHandler( this );
	}
	
	public function deactivate():void {
		_entity.removeComponentHandler( this );
	}
	
	public function addProcessor( processor:IComponentProcessor ):void {
		_processors.add( processor );
	}
	
	public function removeProcessor( processor:IComponentProcessor ):void {
		_processors.remove( processor );
	}
	
	public function processAddedComponent( entity:Entity, componentType:Class, component:* ):void {
		$processAddedComponent( entity, componentType, component );
	}
	
	public function processRemovedComponent( entity:Entity, componentType:Class, component:* ):void {
		$processRemovedComponent( entity, componentType, component );
	}

//-------------------------------------------
// Internals
//-------------------------------------------
	
	[Inline]
	protected final function $processAddedComponent( entity:Entity, componentType:Class, component:* ):void {
		use namespace list_internal;
		
		for ( var node:LLNodeBase = _processors.first; node; node = node.next ) {
			const processor:IComponentProcessor = node.item;
			processor.processAddedComponent( entity, componentType, component );
		}
	}
	
	[Inline]
	protected final function $processRemovedComponent( entity:Entity, componentType:Class, component:* ):void {
		use namespace list_internal;
		
		for ( var node:LLNodeBase = _processors.first; node; node = node.next ) {
			const observer:IComponentProcessor = node.item;
			observer.processRemovedComponent( entity, componentType, component );
		}
	}
}
}
