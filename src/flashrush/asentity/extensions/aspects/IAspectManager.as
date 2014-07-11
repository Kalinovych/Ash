/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
public interface IAspectManager {
	function getAspects( aspectClass:Class ):AspectList;
}
}
