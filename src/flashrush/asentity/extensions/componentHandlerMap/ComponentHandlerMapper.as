/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentHandlerMap {
import flash.utils.Dictionary;

import flashrush.asentity.extensions.componentHandlerMap.api.IComponentHandlerMapper;
import flashrush.asentity.extensions.componentHandlerMap.api.IComponentHandlerUnmapper;
import flashrush.asentity.framework.components.ComponentHandlerList;
import flashrush.asentity.framework.components.IComponentHandler;

public class ComponentHandlerMapper implements IComponentHandlerMapper, IComponentHandlerUnmapper {
	private var _list:ComponentHandlerList;
	private var _mappings:Dictionary = new Dictionary();
	
	public function ComponentHandlerMapper( list:ComponentHandlerList ) {
		_list = list;
	}
	
	public function toHandler( handler:IComponentHandler ):void {
		_mappings[handler] || createMapping( handler );
	}
	
	public function fromHandler( handler:IComponentHandler ):void {
		_mappings[handler] && deleteMapping( handler );
	}
	
	public function fromAll():void {
		for (var handler:IComponentHandler in _mappings) {
			deleteMapping( handler );
		}
	}
	
	private function createMapping( handler:IComponentHandler ):void {
		_mappings[handler] = true;
		_list.add( handler );
	}
	
	private function deleteMapping( handler:IComponentHandler ):void {
		delete _mappings[handler];
		_list.remove( handler );
	}
	
}
}