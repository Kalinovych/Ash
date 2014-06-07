/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core.api {
import ecs.engine.core.CoreUnit;

public interface IUnitObserver {
	function unitAdded( unit:CoreUnit ):void;

	function unitRemoved( unit:CoreUnit ):void;
}
}
