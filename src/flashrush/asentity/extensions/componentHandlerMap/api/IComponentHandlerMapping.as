/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentHandlerMap.api {
import flashrush.asentity.framework.componentManager.IComponentHandler;

public interface IComponentHandlerMapping {
	function get componentType():Class;
	
	function get handler():IComponentHandler;
}
}
