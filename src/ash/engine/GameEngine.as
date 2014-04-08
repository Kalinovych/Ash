/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine {
import ash.engine.api.IEngineTickHandler;
import ash.engine.threadsVersion.ThreadConfig;
import ash.engine.updates.IUpdateable;

public class GameEngine extends TEngine {
	private var mPreUpdater:IEngineTickHandler;
	private var mUpdater:IEngineTickHandler;
	private var mPostUpdater:IEngineTickHandler;

	public function GameEngine() {
	}

	override protected function configure( engineTickHandlers:Vector.<IEngineTickHandler> ):void {
		engineTickHandlers[0] = mPreUpdater;
		engineTickHandlers[1] = mUpdater;
		engineTickHandlers[2] = mPostUpdater;
	}

	override public function configureThreads( config:ThreadConfig ):void {
		//config.setProcessThread(IEnginePreUpdateHandler,  newPreUpdateThread() );
		config.setProcessThread( IUpdateable, new UpdateThread() );
		//config.setProcessThread( IEnginePostUpdateHandler,  new PostUpdateThread() );
	}

	public function update( deltaTime:Number ):void {
		mPreUpdater.tick();
		mUpdater.tick();
		mPostUpdater.tick();
	}
}
}
