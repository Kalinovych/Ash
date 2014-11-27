/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine {

import com.flashrush.signals.ISignal;
import com.flashrush.signals.Signal;

import ecs.engine.threads.RenderThread;
import ecs.engine.threads.UpdateThread;

import flashrush.asentity.extensions.aspects.AspectManager;
import flashrush.asentity.extensions.entityMapExtension.EntityMap;
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.EntityCollection;
import flashrush.asentity.framework.systems.SystemManager;

use namespace asentity;

public class GameEngine {
	private static var sStateEnum:int = 0;
	public static const UNINITIALIZED:int = sStateEnum++;
	public static const INITIALIZING:int = sStateEnum++;
	public static const IDLE:int = sStateEnum++;
	public static const UPDATING:int = sStateEnum++;
	public static const RENDERING:int = sStateEnum++;
	public static const DISPOSED:int = sStateEnum++;

	protected var _entityManager:EntityCollection;
	protected var _systemManager:SystemManager;

	protected var _componentManager:ComponentHandler;
	protected var _aspectManager:AspectManager;
	protected var _entityMap:EntityMap;

	protected var _state:int = UNINITIALIZED;

	protected var updateThread:UpdateThread;
	protected var renderThread:RenderThread;

	protected var _onUpdate:Signal = new Signal();

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

	public function hasEntity( entity:Entity ):Boolean {
		return _entityManager.contains( entity );
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
		_entityManager = new EntityCollection();
		_systemManager = new SystemManager();
	}

	protected function initManagers():void {
		_componentManager = new ComponentHandler( _entityManager );
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