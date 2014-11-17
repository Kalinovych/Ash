/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.entity.api {
import flashrush.asentity.framework.entity.Entity;

public interface IEntityProcessor {
	function processAddedEntity( entity:Entity ):void;

	function processRemovedEntity( entity:Entity ):void;
}
}
