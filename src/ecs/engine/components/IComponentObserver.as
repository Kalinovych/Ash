/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.components {
import ecs.framework.components.api.IComponentHandler;

public interface IComponentObserver {
	function registerHandler( componentType:Class, handler:IComponentHandler ):void;

	function unregisterHandler( componentType:Class, handler:IComponentHandler ):void;
}
}
