/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.threadsVersion {
import ashx.engine.ecse;
import ashx.engine.lists.LinkedHashMap;

public class ThreadConfig {
	ecse var threads:LinkedHashMap;

	public function ThreadConfig() {
		ecse::threads = new LinkedHashMap();
	}

	public function setProcessThread( process:*, thread:ISystemThread ):void {
		ecse::threads.set( process, thread );
	}
	
}
}
