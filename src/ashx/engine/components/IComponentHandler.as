/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.components {
import ashx.engine.entity.Entity;

public interface IComponentHandler {
	function onComponentAdded( entity:Entity, component:*, componentType:* ):void;

	function onComponentRemoved( entity:Entity, component:*, componentType:* ):void;
}
}