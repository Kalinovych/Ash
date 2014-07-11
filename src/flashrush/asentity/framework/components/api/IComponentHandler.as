/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.components.api {
import flashrush.asentity.framework.entity.Entity;

public interface IComponentHandler {
	function onComponentAdded( entity:Entity, componentType:Class, component:* ):void;

	function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void;
}
}
