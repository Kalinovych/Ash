/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.threads {
import ecs.engine.processes.IProcess;

public interface IProcessThread {
	function processAdded( process:IProcess ):void;

	function processRemoved( process:IProcess ):void;
}
}
