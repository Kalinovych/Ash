/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.entityMapExtension {
import flashrush.asentity.framework.entity.Entity;

public interface EntityMap {
	function get( name:String ):Entity;
}
}
