/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentMap {
import flashrush.asentity.extensions.componentMap.api.IComponentHandlerMapping;
import flashrush.asentity.framework.components.IComponentHandler;

public class ComponentHandlerMapping implements IComponentHandlerMapping {
	private var _componentType:Class;
	private var _handler:IComponentHandler;
	
	internal var prev:ComponentHandlerMapping;
	internal var next:ComponentHandlerMapping;
	
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
