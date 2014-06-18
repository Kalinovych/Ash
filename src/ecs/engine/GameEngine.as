/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine {
import com.flashrush.signals.v2.ISignal;
import com.flashrush.signals.v2.SignalPro;

import ecs.engine.components.ComponentObserver;
import ecs.engine.threads.RenderThread;
import ecs.engine.threads.UpdateThread;
import ecs.extensions.aspects.AspectManager;
import ecs.extensions.entityNames.EntityMap;
import ecs.framework.api.ecs_core;
import ecs.framework.entity.Entity;
import ecs.framework.entity.EntityManager;
import ecs.framework.systems.SystemManager;

use namespace ecs_core;

public class GameEngine {
	private static var sStateEnum:int = 0;
	public static const UNINITIALIZED:int = sStateEnum++;
	public static const INITIALIZING:int = sStateEnum++;
	public static const IDLE:int = sStateEnum++;
	public static const UPDATING:int = sStateEnum++;
	public static const RENDERING:int = sStateEnum++;
	public static const DISPOSED:int = sStateEnum++;

	protected var _entityManager:EntityManager;
	protected var _systemManager:SystemManager;

	protected var _componentManager:ComponentObserver;
	protected var _aspectManager:AspectManager;
	protected var _entityMap:EntityMap;

	protected var _state:int = UNINITIALIZED;

	protected var updateThread:UpdateThread;
	protected var renderThread:RenderThread;

	protected var _onUpdate:SignalPro = new SignalPro();

	public function get onUpdate():ISignal {
		return _onUpdate;
	}

	public function GameEngine() {
		_state = INITIALIZING;

		initCore();
		initManagers();
		initThreads();

		_state = IDLE;
	}

	public function get isUpdating():Boolean {
		return (_state == UPDATING);
	}

	public function createEntity():Entity {
		return new Entity();
	}

	public function addEntity( entity:Entity ):Entity {
		return _entityManager.add( entity );
	}

	public function hasEntity( id:uint ):Boolean {
		return _entityManager.has( id );
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
		_state = UPDATING;
		updateThread.process( deltaTime );
		_state = RENDERING;
		renderThread.process( deltaTime );
		_state = IDLE;
	}


	protected function initCore():void {
		_entityManager = new EntityManager();
		_systemManager = new SystemManager();
	}

	protected function initManagers():void {
		_componentManager = new ComponentObserver( _entityManager );
		_aspectManager = new AspectManager( _entityManager, _componentManager );
	}

	protected function initThreads():void {
		updateThread = new UpdateThread();
		renderThread = new RenderThread();
	}

}
}

class GameEngineState {
	private static var sStateEnum:int = 0;
	public static const UNINITIALIZED:int = sStateEnum++;
	public static const INITIALIZING:int = sStateEnum++;
	public static const IDLE:int = sStateEnum++;
	public static const UPDATING:int = sStateEnum++;
	public static const RENDERING:int = sStateEnum++;
	public static const DISPOSED:int = sStateEnum++;

	internal var _value:int = UNINITIALIZED;

	[Inline]
	public final function get value():int {
		return _value;
	}

	[Inline]
	public final function get idle():Boolean {
		return (_value == IDLE);
	}

	[Inline]
	public final function get updating():Boolean {
		return (_value == UPDATING);
	}

	[Inline]
	public final function get rendering():Boolean {
		return (_value == RENDERING);
	}

}