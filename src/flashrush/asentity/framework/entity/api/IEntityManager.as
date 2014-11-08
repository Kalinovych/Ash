/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.entity.api {
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.Entity;

use namespace asentity;

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

	function registerHandler( handler:IEntityObserver ):Boolean;

	function unregisterHandler( handler:IEntityObserver ):Boolean;
}
}
