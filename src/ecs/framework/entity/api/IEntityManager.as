/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.framework.entity.api {
import ecs.framework.api.ecs_core;
import ecs.framework.entity.Entity;

use namespace ecs_core;

public interface IEntityManager {
	function get first():Entity;

	function get last():Entity;
	
	function get entityCount():uint;

	function add( entity:Entity ):Entity;

	function has( id:uint ):Boolean;

	function get( id:uint ):Entity;

	function remove( entity:Entity ):Entity;

	function removeById( id:uint ):Entity;

	function removeAll():void;

	function registerHandler( handler:IEntityHandler ):Boolean;

	function unregisterHandler( handler:IEntityHandler ):Boolean;
}
}
