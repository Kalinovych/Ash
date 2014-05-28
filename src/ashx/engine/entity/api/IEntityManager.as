/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.entity.api {
import ashx.engine.api.ecse;
import ashx.engine.entity.Entity;

use namespace ecse;

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
