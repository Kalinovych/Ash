/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.components {
import flashrush.asentity.framework.entity.Entity;

public interface IComponentProcessor {
	function processAddedComponent( entity:Entity, componentType:Class, component:* ):void;

	function processRemovedComponent( entity:Entity, componentType:Class, component:* ):void;
}
}
