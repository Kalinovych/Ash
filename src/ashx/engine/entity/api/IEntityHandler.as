/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.entity.api {
import ashx.engine.entity.*;

public interface IEntityHandler {
	function onEntityAdded( entity:Entity ):void;

	function onEntityRemoved( entity:Entity ):void;
}
}
