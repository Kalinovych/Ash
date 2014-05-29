/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.processes {
public interface IUpdateProcess extends IProcess {
	function update( deltaTime:Number ):void;
}
}
