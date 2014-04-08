/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.threadsVersion {
import ash.engine.ecse;
import ash.engine.lists.LinkedHashMap;

public class ThreadConfig {
	ecse var threads:LinkedHashMap;

	public function ThreadConfig() {
		ecse::threads = new LinkedHashMap();
	}

	public function setProcessThread( process:*, thread:IProcessThread ):void {
		ecse::threads.put( process, thread );
	}
	
}
}
