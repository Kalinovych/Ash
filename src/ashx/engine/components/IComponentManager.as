/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.components {
public interface IComponentManager {
	function addHandler( componentType:Class, handler:IComponentHandler ):void;

	function removeHandler( componentType:Class, handler:IComponentHandler ):void;
}
}