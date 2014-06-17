/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.framework.entity.api {
import ecs.framework.entity.*;

public interface IEntityHandler {
	function handleAddedEntity( entity:Entity ):void;

	function handleRemovedEntity( entity:Entity ):void;
}
}
