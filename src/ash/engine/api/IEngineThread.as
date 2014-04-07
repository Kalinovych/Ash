/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.api {
public interface IEngineThread {
	
	function update( deltaTime:Number ):void;
	
	function suspend():void;
	
	function resume():void;
	
	//function get timeScale():Number;
	
	//function set timeScale(value:Number):void;
	
	//function get prevThread():IEngineThread;
	
	//function get nextThread():IEngineThread;
}
}
