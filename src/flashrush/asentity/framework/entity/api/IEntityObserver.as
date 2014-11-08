/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.entity.api {
import flashrush.asentity.framework.entity.Entity;

public interface IEntityObserver {
	function onEntityAdded( entity:Entity ):void;

	function onEntityRemoved( entity:Entity ):void;
}
}
