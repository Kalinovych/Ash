/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.api {
import ash.core.Engine;

public interface IEngineProcess {
	function addedToEngine( engine:Engine ):void;
	
	function removedFromEngine( engine:Engine ):void;
	
	//function get parent():IEngineProcess;
	
	//function set parent(value:IEngineProcess):void;
}
}
