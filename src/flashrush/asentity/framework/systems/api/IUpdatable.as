/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems.api {
public interface IUpdatable {
	function update( time:Number ):void;
	
	function get order():int;
}
}
