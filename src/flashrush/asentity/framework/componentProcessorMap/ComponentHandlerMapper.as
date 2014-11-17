/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.componentProcessorMap {
import flash.utils.Dictionary;

import flashrush.asentity.framework.componentManager.IComponentHandler;

public class ComponentHandlerMapper {
	private var _componentType:Class;
	private var _notifier:ComponentHandlerNotifier;
	private var _mappings:Dictionary = new Dictionary();
	
	public function ComponentHandlerMapper( componentType:Class, notifier:ComponentHandlerNotifier ) {
		_componentType = componentType;
		_notifier = notifier;
	}
	
	public function toHandler( handler:IComponentHandler ):ComponentHandlerMapping {
		return _mappings[handler] || createMapping( handler );
	}
	
	private function createMapping( handler:IComponentHandler ):ComponentHandlerMapping {
		var mapping:ComponentHandlerMapping = new ComponentHandlerMapping( _componentType, handler );
		_mappings[handler] = mapping;
		_notifier.addMapping( mapping );
		return mapping;
	}
}
}