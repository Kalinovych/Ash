/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.componentProcessorMap {
import flashrush.asentity.framework.componentManager.IComponentHandler;

public class ComponentHandlerMapping {
	private var _componentType:Class;
	private var _handler:IComponentHandler;
	
	public function ComponentHandlerMapping( componentType:Class, handler:IComponentHandler ) {
		_componentType = componentType;
		_handler = handler;
	}
	
	public function get componentType():Class {
		return _componentType;
	}
	
	public function get handler():IComponentHandler {
		return _handler;
	}
}
}
