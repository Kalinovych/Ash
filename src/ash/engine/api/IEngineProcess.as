/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.api {
import ash.engine.UEngine;

public interface IEngineProcess {
	function addedToEngine( engine:UEngine ):void;

	function removedFromEngine( engine:UEngine ):void;

	//function get parent():IEngineProcess;

	//function set parent(value:IEngineProcess):void;
}
}
