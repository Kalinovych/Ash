/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.extensions.instanceRegistry.api {
import ecs.extensions.instanceRegistry.*;

public interface IInstanceRegistry {
	function getInstancesOf( type:Class ):InstanceList;
}
}
