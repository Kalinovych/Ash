/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.processes.api {
import ecs.engine.processes.*;

public interface IPreUpdateProcess extends IProcess {
	function preUpdate():void;
}
}
