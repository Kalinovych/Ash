/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentMap {
import flash.utils.Dictionary;

import flashrush.asentity.extensions.componentMap.api.IComponentHandlerMapper;
import flashrush.asentity.extensions.componentMap.api.IComponentHandlerMapping;
import flashrush.asentity.extensions.componentMap.api.IComponentHandlerUnmapper;
import flashrush.asentity.framework.components.IComponentHandler;

public class ComponentHandlerMapper implements IComponentHandlerMapper, IComponentHandlerUnmapper {
	private var _componentType:Class;
	private var _notifier:ComponentHandlerNotifier;
	private var _mappings:Dictionary = new Dictionary();
	
	public function ComponentHandlerMapper( componentType:Class, notifier:ComponentHandlerNotifier ) {
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
	
	/*public function toCallback( callback:Function ):void {
		
	}*/
	
	public function fromAll():void {
		for each(var mapping:IComponentHandlerMapping in _mappings) {
			deleteMapping( mapping );
		}
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