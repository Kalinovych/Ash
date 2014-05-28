/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.framework.components {
import ashx.engine.components.api.IComponentHandler;

public interface IComponentObserver {
	function registerHandler( componentType:Class, handler:IComponentHandler ):void;

	function unregisterHandler( componentType:Class, handler:IComponentHandler ):void;
}
}
