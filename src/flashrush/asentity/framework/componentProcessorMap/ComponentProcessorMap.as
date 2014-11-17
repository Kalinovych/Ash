/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.componentProcessorMap {
import flash.utils.Dictionary;

import flashrush.asentity.framework.components.*;

public class ComponentProcessorMap {
	private var _handler:ComponentHandler;
	private var _mappers:Dictionary/*<Class, LinkedSet>*/ = new Dictionary();
	
	public function ComponentProcessorMap() {
		_handler = new ComponentHandler();
	}
	
	public function mapProcessor( processor:IComponentProcessor, componentType:Class ):void {
		var mapper:ComponentProcessorMapper = _mappers[componentType] || createMapper(componentType);
		mapper.toProcessor( processor );
		
		
		
		/*var interestedProcessors:LinkedSet = _processors[componentType];
		if ( !interestedProcessors ) {
			interestedProcessors = new LinkedSet();
			_processors[componentType] = interestedProcessors;
		}
		interestedProcessors.add( processor );*/
	}
	
	public function unmapProcessor( observer:IComponentProcessor, componentType:Class ):void {
		/*var typeObservers:LinkedSet = _processors[componentType];
		if ( typeObservers ) {
			typeObservers.remove( observer );
		}*/
	}
	
	protected function createMapper( componentType:Class ):ComponentProcessorMapper {
		var mapper:ComponentProcessorMapper = new ComponentProcessorMapper();
		_mappers[componentType] = mapper;
		return mapper;
	}
}
}
