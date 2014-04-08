/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine {
import ash.engine.lists.AnyElementIterator;
import ash.engine.lists.ItemNode;
import ash.engine.lists.LinkedHashMap;
import ash.engine.threadsVersion.IProcessThread;
import ash.engine.threadsVersion.ThreadConfig;

public class TEngine extends UEngine {
	private var mThreads:LinkedHashMap;
	private var mThreadIterator:AnyElementIterator;

	public function TEngine() {
		super();
		//initialize();
	}

	public function configureThreads( config:ThreadConfig ):void {
		mThreads = config.ecse::threads;
		mThreadIterator = new AnyElementIterator( mThreads );
	}

	/*private function initialize():void {
		mThreads = new LinkedHashMap();
		configureThreads( new ThreadConfig( mThreads ) );
	}
	
	
	protected function configureThreads( config:ThreadConfig ):void {
		 // or allow to pass ThreadConfig to the configureThreads
		 // and retrieve from it threadMap
	}*/

	public function addSystem( system:* ):void {
		for ( var processType:* in mThreads.ecse::registry ) {
			if ( system is processType ) {
				var thread:IProcessThread = mThreads.get( processType );
				thread.handleAddedProcess( system );
			}

		}
	}
}
}
