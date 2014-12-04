/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems.api {
public interface ISystemHandler {
	function onSystemAdded( system:* ):void;

	function onSystemRemoved( system:* ):void;
}
}
