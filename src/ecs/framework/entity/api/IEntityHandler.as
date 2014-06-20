/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.framework.entity.api {
import ecs.framework.entity.*;

public interface IEntityHandler {
	function handleEntityAdded( entity:Entity ):void;

	function handleEntityRemoved( entity:Entity ):void;
}
}
