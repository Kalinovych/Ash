/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.api {
import ashx.engine.lists.EntityNodeList;

public interface IEntityFamiliesManager {
	function getEntities( familyIdentifier:Class ):EntityNodeList;
}
}
