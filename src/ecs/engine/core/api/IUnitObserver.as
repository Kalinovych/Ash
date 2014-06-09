/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core.api {
import ecs.engine.core.ESUnit;

public interface IUnitObserver {
	function unitAdded( unit:ESUnit ):void;

	function unitRemoved( unit:ESUnit ):void;
}
}
