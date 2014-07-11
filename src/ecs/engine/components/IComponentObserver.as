/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.components {
import flashrush.asentity.framework.components.api.IComponentHandler;

public interface IComponentObserver {
	function registerHandler( componentType:Class, handler:IComponentHandler ):void;

	function unRegisterHandler( componentType:Class, handler:IComponentHandler ):void;
}
}
