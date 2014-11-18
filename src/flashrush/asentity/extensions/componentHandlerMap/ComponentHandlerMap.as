/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentHandlerMap {
import flash.utils.Dictionary;

import flashrush.asentity.extensions.componentHandlerMap.api.IComponentHandlerMap;
import flashrush.asentity.extensions.componentHandlerMap.api.IComponentHandlerMapper;
import flashrush.asentity.extensions.componentHandlerMap.api.IComponentHandlerUnmapper;

public class ComponentHandlerMap implements IComponentHandlerMap {
	private var _notifier:ComponentHandlerManager;
	private var _mappers:Dictionary = new Dictionary();
	
	private const NULL_UNMAPPER:IComponentHandlerUnmapper = new NullComponentHandlerUnmapper();
	
	public function ComponentHandlerMap( notifier:ComponentHandlerManager = null ) {
		_notifier = notifier || new ComponentHandlerManager();
	}
	
	public function map( componentType:Class ):IComponentHandlerMapper {
		return _mappers[componentType] || createMapper( componentType );
	}
	
	public function unmap( componentType:Class ):IComponentHandlerUnmapper {
		return _mappers[componentType] || NULL_UNMAPPER;
	}
	
	public function processAdded( component:Object ):void {
		const type:Class = component.constructor as Class;
		_notifier.handleComponentAdded(null, type, component );
	}
	
	public function processRemoved( component:Object ):void {
		const type:Class = component.constructor as Class;
		_notifier.handleComponentAdded(null, type, component );
	}
	
	private function createMapper( componentType:Class ):ComponentHandlerMapper {
		var mapper:ComponentHandlerMapper = new ComponentHandlerMapper( componentType, _notifier );
		_mappers[componentType] = mapper;
		return mapper;
	}
}
}

import flashrush.asentity.extensions.componentHandlerMap.api.IComponentHandlerUnmapper;
import flashrush.asentity.framework.componentManager.IComponentHandler;

class NullComponentHandlerUnmapper implements IComponentHandlerUnmapper {
	
	public function fromHandler( handler:IComponentHandler ):void {}
	
	public function fromAll():void {}
}