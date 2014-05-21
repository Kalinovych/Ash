/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.systems {
public interface ISystemManager {
	function add( system:*, order:int ):void;

	function remove( system:* ):void;
}
}
