/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.framework.threads {
import ashx.framework.processes.IProcess;

public interface IProcessThread {
	function processAdded( process:IProcess ):void;

	function processRemoved( process:IProcess ):void;
}
}
