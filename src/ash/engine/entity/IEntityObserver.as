/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.entity {
import ash.core.Entity;

public interface IEntityObserver {
	function onEntityAdded( entity:Entity ):void;
	
	function onEntityRemoved( entity:Entity ):void;
}
}
