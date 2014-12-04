/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems.api {
public interface ISystem {
	function onAdded():void;
	
	function onRemoved():void;
}
}
