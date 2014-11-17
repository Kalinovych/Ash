/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.componentManager {
import flashrush.asentity.framework.entity.Entity;

public interface IComponentHandler {
	function handleComponentAdded( entity:Entity, componentType:Class, component:* ):void;
	
	function handleComponentRemoved( entity:Entity, componentType:Class, component:* ):void;
}
}
