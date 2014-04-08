/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.api {
public interface IEngineProcessHandler {
	function handleAddedProcess( process:* ):void;

	function handleRemovedProcess( process:* ):void;
}
}
