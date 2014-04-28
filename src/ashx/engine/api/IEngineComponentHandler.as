/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.api {
import ashx.engine.threadsVersion.IEngineComponent;

public interface IEngineComponentHandler {
	function handleAddedEngineComponent( component:IEngineComponent ):void;
	
	function handleRemovedEngineComponent( component:IEngineComponent ):void;
}
}
