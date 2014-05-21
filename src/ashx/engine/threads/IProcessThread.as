/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.threads {
import ashx.engine.api.IProcess;

public interface IProcessThread {
	function processAdded( process:IProcess ):void;

	function processRemoved( process:IProcess ):void;
}
}
