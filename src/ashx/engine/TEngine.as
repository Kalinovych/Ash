/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine {
import ashx.engine.lists.LinkedMap;
import ashx.engine.threadsVersion.ISystemThread;
import ashx.engine.threadsVersion.ThreadConfig;

public class TEngine extends UEngine {
	ecse var mThreads:LinkedMap;

	public function TEngine() {
		super();
	}

	public function configureThreads( config:ThreadConfig ):void {
		ecse::mThreads = config.ecse::threads;
	}
	
	public function addSystem( system:* ):void {
		use namespace ecse;
		for ( var processType:* in mThreads.nodeByKey ) {
			if ( system is processType ) {
				var thread:ISystemThread = mThreads.get( processType );
				thread.onSystemAdded( system );
			}

		}
	}
}
}
