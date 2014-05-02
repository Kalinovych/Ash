/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.api {
import ashx.engine.aspects.AspectList;

public interface IAspectManager {
	function getAspects( familyIdentifier:Class ):AspectList;
}
}
