/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.entity {
import ash.core.Entity;

public interface IEntityHandler {
	function handleAddedEntity( entity:Entity ):void;

	function handleRemovedEntity( entity:Entity ):void;
}
}
