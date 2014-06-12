/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.extensions.entityNames {
import ecs.framework.entity.Entity;

public interface EntityMap {
	function get( name:String ):Entity;
}
}
