/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.api {
import ash.core.Entity;

public interface IComponentProcessor {
	function get componentInterests():Array;
	
	function processAddedComponent( entity:Entity, component:Object, componentClass:Class = null ):void;
	
	function processRemovedComponent( entity:Entity, component:Object, componentClass:Class = null ):void;
}
}
