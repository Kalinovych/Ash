/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.entity {
import ashx.engine.entity.Entity;

public interface IEntityObserver {
	function onEntityAdded( entity:Entity ):void;
	
	function onEntityRemoved( entity:Entity ):void;
}
}
