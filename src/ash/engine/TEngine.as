/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine {
import ash.engine.lists.LinkedHashMap;
import ash.engine.threadsVersion.IProcessThread;
import ash.engine.threadsVersion.ThreadConfig;

public class TEngine extends UEngine {
	ecse var mThreads:LinkedHashMap;

	public function TEngine() {
		super();
	}

	public function configureThreads( config:ThreadConfig ):void {
		ecse::mThreads = config.ecse::threads;
	}
	
	public function addSystem( system:* ):void {
		use namespace ecse;
		for ( var processType:* in mThreads.registry ) {
			if ( system is processType ) {
				var thread:IProcessThread = mThreads.get( processType );
				thread.handleAddedProcess( system );
			}

		}
	}
}
}
