/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.api {
import ash.engine.ECSEngine;

public interface IEngineProcess {
	function addedToEngine( engine:ECSEngine ):void;

	function removedFromEngine( engine:ECSEngine ):void;

	//function get parent():IEngineProcess;

	//function set parent(value:IEngineProcess):void;
}
}
