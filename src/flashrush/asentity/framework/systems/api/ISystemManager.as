/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems.api {
public interface ISystemManager {
	function add( system:ISystem, order:int = 0 ):void;

	function get( systemType:Class ):*;

	/**
	 * @param system system instance or Class
	 * @return removed system instance or null if a system not found
	 */
	function remove( systemOrType:* ):ISystem;

	function removeAll():void;

	function registerHandler( handler:ISystemHandler ):void;

	function unRegisterHandler( handler:ISystemHandler ):void;
}
}
