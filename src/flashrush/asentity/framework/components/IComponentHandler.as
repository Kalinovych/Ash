/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.components {
import flashrush.asentity.framework.entity.Entity;

public interface IComponentHandler {
	function handleComponentAdded( component:*, componentType:Class, entity:Entity ):void;
	
	function handleComponentRemoved( component:*, componentType:Class, entity:Entity ):void;
}
}
