/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems.api {
import flashrush.asentity.framework.systems.SystemNode;

public interface ISystemManager {
	function get length():uint;
	
	function get firstSystemNode():SystemNode;
	
	function get lastSystemNode():SystemNode;
	
	function add( system:ISystem, order:int = 0 ):void;

	function get( systemType:Class ):*;

	function remove( system:ISystem ):Boolean;

	function removeAll():void;

	function registerHandler( handler:ISystemHandler ):void;

	function unRegisterHandler( handler:ISystemHandler ):void;
}
}
