/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.systems.api {
public interface ISystemHandler {
	function onSystemAdded( system:ISystem ):void;

	function onSystemRemoved( system:ISystem ):void;
}
}
