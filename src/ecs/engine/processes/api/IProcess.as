/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.processes.api {
public interface IProcess extends IUpdateable {
	function onAdded():void;

	function onRemoved():void;
}
}
