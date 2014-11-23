/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentMap {
import flash.utils.Dictionary;

import flashrush.asentity.extensions.componentMap.api.IComponentHandlerMap;
import flashrush.asentity.extensions.componentMap.api.IComponentHandlerMapper;
import flashrush.asentity.extensions.componentMap.api.IComponentHandlerUnmapper;

public class ComponentHandlerMap implements IComponentHandlerMap {
	private var _handlerManager:ComponentHandlerNotifier;
	private var _mappers:Dictionary = new Dictionary();
	
	private const NULL_UNMAPPER:IComponentHandlerUnmapper = new NullComponentHandlerUnmapper();
	
	public function ComponentHandlerMap( handlerManager:ComponentHandlerNotifier = null ) {
		_handlerManager = handlerManager || new ComponentHandlerNotifier();
	}
	
	public function map( componentType:Class ):IComponentHandlerMapper {
		return _mappers[componentType] || createMapper( componentType );
	}
	
	public function unmap( componentType:Class ):IComponentHandlerUnmapper {
		return _mappers[componentType] || NULL_UNMAPPER;
	}
	
	public function unmapAll():void {
		for (var type:Class in _mappers) {
			unmap(type).fromAll();
		}
	}
	
	public function processAdded( component:Object ):void {
		const type:Class = component.constructor as Class;
		_handlerManager.handleComponentAdded(null, type, component );
	}
	
	public function processRemoved( component:Object ):void {
		const type:Class = component.constructor as Class;
		_handlerManager.handleComponentAdded(null, type, component );
	}
	
	private function createMapper( componentType:Class ):ComponentHandlerMapper {
		var mapper:ComponentHandlerMapper = new ComponentHandlerMapper( componentType, _handlerManager );
		_mappers[componentType] = mapper;
		return mapper;
	}
}
}

import flashrush.asentity.extensions.componentMap.api.IComponentHandlerUnmapper;
import flashrush.asentity.framework.componentManager.IComponentHandler;

class NullComponentHandlerUnmapper implements IComponentHandlerUnmapper {
	
	public function fromHandler( handler:IComponentHandler ):void {}
	
	public function fromAll():void {}
}