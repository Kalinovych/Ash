/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.threadsVersion {
public interface IEngineThread {
	function process():void;
	
	function start():void;
	
	function stop():void;
	
	function suspend():void;
	
	function resume():void;
}
}