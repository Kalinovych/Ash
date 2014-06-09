/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.processes.api {
public interface IProcess {
	function onAdded():void;

	function onRemoved():void;
}
}
