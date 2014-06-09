/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.processes.api {
import ecs.engine.processes.*;

public interface IPostUpdateProcess extends IProcess {
	function postUpdate():void;
}
}
