/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.components {
import ash.core.Entity;

public interface IComponentObserver {
	function onComponentAdded( entity:Entity, component:*, componentType:* ):void;
	
	function onComponentRemoved( entity:Entity, component:*, componentType:* ):void;
}
}
