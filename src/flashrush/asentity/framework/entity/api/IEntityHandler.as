/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.entity.api {
import flashrush.asentity.framework.entity.Entity;

public interface IEntityHandler {
	function handleEntityAdded( entity:Entity ):void;

	function handleEntityRemoved( entity:Entity ):void;
}
}
