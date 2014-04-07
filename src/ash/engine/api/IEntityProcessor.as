/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.api {
import ash.core.Entity;

public interface IEntityProcessor {
	function processAddedEntity( entity:Entity ):void;
	
	function processRemovedEntity( entity:Entity ):void;
}
}
