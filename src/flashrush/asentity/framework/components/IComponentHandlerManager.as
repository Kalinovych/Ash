/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.components {
import flashrush.asentity.framework.api.asentity;

use namespace asentity;

public interface IComponentHandlerManager {
	function register( handler:IComponentHandler ):void;
	
	function unregister( handler:IComponentHandler ):void;
}
}
