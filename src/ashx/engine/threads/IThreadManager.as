/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.threads {
import ashx.engine.threads.IProcessThread;

public interface IThreadManager {
	function registerProcessThread( process:Class, handler:IProcessThread ):void;

	function unregisterProcessThread( process:Class ):void;
}
}
