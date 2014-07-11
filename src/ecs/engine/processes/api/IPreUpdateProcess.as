/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.processes.api {
public interface IPreUpdateProcess extends IProcess {
	function preUpdate():void;
}
}
