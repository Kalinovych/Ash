/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine {
import ashx.engine.api.IEngineTickHandler;
import ashx.engine.aspects.AspectManager;
import ashx.engine.entity.EntityManager;
import ashx.engine.threadsVersion.ThreadConfig;
import ashx.engine.updates.IUpdateable;

public class GameEngine extends TEngine {
	private var mPreUpdater:IEngineTickHandler;
	private var mUpdater:IEngineTickHandler;
	private var mPostUpdater:IEngineTickHandler;

	protected var _entityManager:EntityManager;
	protected var _aspectManager:AspectManager;

	public function GameEngine() {
		_entityManager = new EntityManager();
		_aspectManager = new AspectManager( _entityManager );
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
