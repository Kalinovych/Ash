/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.componentProcessorMap {
import flashrush.asentity.framework.components.*;

import flash.utils.Dictionary;

public class ComponentProcessorMapper {
	private var _mappings:Dictionary = new Dictionary();
	private var _handler:EntityComponentHandler;
	
	public function ComponentProcessorMapper( handler:EntityComponentHandler ) {
		_handler = handler;
	}
	
	public function toProcessor( processor:IComponentProcessor ):ComponentProcessorMapping {
		var mapping:ComponentProcessorMapping = _mappings[processor] || createMapping( processor );
		return mapping;
	}
	
	private function createMapping(processor:IComponentProcessor):ComponentProcessorMapping {
		var mapping:ComponentProcessorMapping = new ComponentProcessorMapping( processor );
		_mappings[processor] = mapping;
		_handler.addProcessor( processor );
		return mapping;
	}
}
}
