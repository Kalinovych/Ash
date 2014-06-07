/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core.api {
import ecs.framework.entity.Entity;

public interface IEntityDestroyer {
	function entityRemoved( entity:Entity ):void;
}
}
