/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentHandlerMap {
import flash.utils.Dictionary;

import flashrush.asentity.extensions.componentHandlerMap.api.IComponentHandlerMapper;
import flashrush.asentity.extensions.componentHandlerMap.api.IComponentHandlerMapping;
import flashrush.asentity.extensions.componentHandlerMap.api.IComponentHandlerUnmapper;
import flashrush.asentity.framework.componentManager.IComponentHandler;

public class ComponentHandlerMapper implements IComponentHandlerMapper, IComponentHandlerUnmapper {
	private var _componentType:Class;
	private var _notifier:ComponentHandlerManager;
	private var _mappings:Dictionary = new Dictionary();
	
	public function ComponentHandlerMapper( componentType:Class, notifier:ComponentHandlerManager ) {
		_componentType = componentType;
		_notifier = notifier;
	}
	
	public function toHandler( handler:IComponentHandler ):IComponentHandlerMapping {
		return _mappings[handler] || createMapping( handler );
	}
	
	public function fromHandler( handler:IComponentHandler ):void {
		var mapping:IComponentHandlerMapping = _mappings[handler];
		mapping && deleteMapping( mapping );
	}
	
	public function toCallback( callback:Function ):void {
		
	}
	
	public function fromAll():void {
		for each(var mapping:IComponentHandlerMapping in _mappings) {
			deleteMapping( mapping );
		}
		/*for (var handler:IComponentHandler in _mappings ) {
			fromHandler( handler );
		}*/
	}
	
	private function createMapping( handler:IComponentHandler ):ComponentHandlerMapping {
		var mapping:ComponentHandlerMapping = new ComponentHandlerMapping( _componentType, handler );
		_mappings[handler] = mapping;
		_notifier.addMapping( mapping );
		return mapping;
	}
	
	private function deleteMapping( mapping:IComponentHandlerMapping ):void {
		delete _mappings[mapping.componentType];
		_notifier.removeMapping( mapping );
	}
	
}
}