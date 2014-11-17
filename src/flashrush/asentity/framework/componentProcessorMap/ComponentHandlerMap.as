/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.componentProcessorMap {
import flash.utils.Dictionary;

public class ComponentHandlerMap {
	private var _notifier:ComponentHandlerNotifier;
	private var _mappers:Dictionary = new Dictionary();
	
	public function ComponentHandlerMap( notifier:ComponentHandlerNotifier = null ) {
		_notifier = notifier || new ComponentHandlerNotifier();
	}
	
	public function map( componentType:Class ):ComponentHandlerMapper {
		return _mappers[componentType] || createMapper( componentType );
	}
	
	public function processAdded( item:Object ):void {
		const type:Class = item.constructor as Class;
		_notifier.handleComponentAdded(null, type, item );
	}
	
	private function createMapper( componentType:Class ):ComponentHandlerMapper {
		var mapper:ComponentHandlerMapper = new ComponentHandlerMapper( componentType, _notifier );
		_mappers[componentType] = mapper;
		return mapper;
	}
}
}
