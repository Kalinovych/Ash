/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.api {
import ash.engine.EEngine;

public interface IEngineProcess {
	function addedToEngine( engine:EEngine ):void;

	function removedFromEngine( engine:EEngine ):void;
}
}
