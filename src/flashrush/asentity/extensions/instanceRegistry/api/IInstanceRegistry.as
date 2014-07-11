/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.instanceRegistry.api {
import flashrush.asentity.extensions.instanceRegistry.InstanceList;

public interface IInstanceRegistry {
	function getInstancesOf( type:Class ):InstanceList;
}
}
