/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.api {
import ash.engine.threadsVersion.IEngineComponent;

public interface IEngineComponentHandler {
	function handleAddedEngineComponent( component:IEngineComponent ):void;
	
	function handleRemovedEngineComponent( component:IEngineComponent ):void;
}
}
