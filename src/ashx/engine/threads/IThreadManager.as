/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.threads {
public interface IThreadManager {
	function registerProcessThread( process:Class, handler:IProcessThread ):void;

	function unregisterProcessThread( process:Class ):void;
}
}