/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.api {
import ashx.engine.lists.EntityNodeList;

public interface IFamiliesManager {
	function getEntities( familyIdentifier:Class ):EntityNodeList;
}
}
