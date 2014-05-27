/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine {
import ashx.engine.aspects.AspectManager;
import ashx.engine.components.ComponentManager;
import ashx.engine.entity.Entity;
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

	public function createEntity():Entity {
		return new Entity();
	}

	public function addEntity( entity:Entity ):Entity {
		return _entityManager.add( entity );
	}

	public function hasEntity( id:uint ):Boolean {
		return _entityManager.contains( id );
	}

	public function getEntity( id:uint ):Entity {
		return _entityManager.get( id );
	}

	public function removeEntity( entity:Entity ):Entity {
		return _entityManager.remove( entity );
	}

	public function removeAllEntities():void {
		_entityManager.removeAll();
	}

	public function addSystem( system:*, order:int ):void {
		_systemManager.add( system, order );
	}

	public function removeSystem( system:* ):void {
		_systemManager.remove( system );
	}

	public function update( deltaTime:Number ):void {

	}
}
}
