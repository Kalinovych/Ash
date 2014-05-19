/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.threadsVersion {
import ashx.engine.ecse;
import ashx.engine.lists.LinkedMap;

public class ThreadConfig {
	ecse var threads:LinkedMap;

	public function ThreadConfig() {
		ecse::threads = new LinkedMap();
	}

	public function setProcessThread( process:*, thread:ISystemThread ):void {
		ecse::threads.set( process, thread );
	}
	
}
}
