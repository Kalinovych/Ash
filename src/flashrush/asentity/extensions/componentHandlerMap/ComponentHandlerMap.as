/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentHandlerMap {
import flash.utils.Dictionary;

import flashrush.asentity.extensions.componentHandlerMap.api.IComponentHandlerMap;
import flashrush.asentity.extensions.componentHandlerMap.api.IComponentHandlerMapper;
import flashrush.asentity.extensions.componentHandlerMap.api.IComponentHandlerUnmapper;
import flashrush.asentity.framework.components.IComponentHandlerManager;

public class ComponentHandlerMap implements IComponentHandlerMap {
	private var _manager:IComponentHandlerManager;
	private var _handlerProcessor:ComponentHandlerProcessor;
	private var _mappers:Dictionary = new Dictionary();
	
	private const NULL_UNMAPPER:IComponentHandlerUnmapper = new NullComponentHandlerUnmapper();
	
	public function ComponentHandlerMap( manager:IComponentHandlerManager ) {
		_manager = manager;
		
		_handlerProcessor = new ComponentHandlerProcessor();
		
		_manager.register( _handlerProcessor );
	}
	
	public function map( componentType:Class ):IComponentHandlerMapper {
		return _mappers[componentType] || createMapper( componentType );
	}
	
	public function unmap( componentType:Class ):IComponentHandlerUnmapper {
		return _mappers[componentType] || NULL_UNMAPPER;
	}
	
	public function unmapAll():void {
		for ( var type:Class in _mappers ) {
			unmap( type ).fromAll();
		}
	}
	
	//-------------------------------------------
	// Private
	//-------------------------------------------
	
	private function createMapper( componentType:Class ):ComponentHandlerMapper {
		var mapper:ComponentHandlerMapper = new ComponentHandlerMapper( _handlerProcessor.getHandlerStoreFor( componentType ) );
		_mappers[componentType] = mapper;
		return mapper;
	}
}
}

import flashrush.asentity.extensions.componentHandlerMap.api.IComponentHandlerUnmapper;
import flashrush.asentity.framework.components.IComponentHandler;

class NullComponentHandlerUnmapper implements IComponentHandlerUnmapper {
	
	public function fromHandler( handler:IComponentHandler ):void {}
	
	public function fromAll():void {}
}