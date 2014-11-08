/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.core {
import flashrush.asentity.framework.entity.Entity;

public interface IComponentObserver {
	function onComponentAdded( entity:Entity, componentType:Class, component:* ):void;

	function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void;
}
}
