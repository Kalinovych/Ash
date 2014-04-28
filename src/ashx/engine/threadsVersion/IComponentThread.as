/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.threadsVersion {
public interface IComponentThread extends IEngineThread {
	function componentAdded( component:* ):void;
	function componentRemoved( component:* ):void;
}
}
