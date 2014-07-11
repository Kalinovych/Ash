/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.processes.api {
public interface IUpdateable {
	function update( deltaTime:Number ):void;
}
}
