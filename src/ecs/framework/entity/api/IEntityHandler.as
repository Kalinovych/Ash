/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.framework.entity.api {
import ecs.framework.entity.*;

public interface IEntityHandler {
	function onEntityAdded( entity:Entity ):void;

	function onEntityRemoved( entity:Entity ):void;
}
}
