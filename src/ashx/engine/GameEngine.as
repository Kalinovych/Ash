/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine {
import ashx.engine.aspects.AspectManager;
import ashx.engine.components.ComponentManager;
import ashx.engine.entity.EntityManager;
import ashx.engine.systems.SystemManager;
import ashx.engine.threads.RenderThread;
import ashx.engine.threads.UpdateThread;

public class GameEngine {
	protected var _entityManager:EntityManager;
	protected var _componentManager:ComponentManager;
	protected var _aspectManager:AspectManager;
	protected var _systemManager:SystemManager;

	protected var updateThread:UpdateThread;
	protected var renderThread:RenderThread;

	public function GameEngine() {
		_entityManager = new EntityManager();
		_componentManager = new ComponentManager( _entityManager );
		_aspectManager = new AspectManager( _entityManager, _componentManager );
		_systemManager = new SystemManager();

		initThreads();
	}

	protected function initThreads():void {
		updateThread = new UpdateThread();
		renderThread = new RenderThread();
	}

	public function update( deltaTime:Number ):void {

	}
}
}
