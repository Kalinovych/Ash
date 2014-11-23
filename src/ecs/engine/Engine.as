/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine {
import flashrush.asentity.extensions.aspects.AspectList;
import flashrush.asentity.extensions.aspects.AspectManager;
import flashrush.asentity.extensions.componentMap.ComponentHandlerNotifier;
import flashrush.asentity.extensions.componentMap.ComponentMap;
import flashrush.asentity.extensions.componentMap.api.IComponentHandlerMap;
import flashrush.asentity.framework.componentManager.ComponentHandlerManager;
import flashrush.asentity.framework.core.EntitySpace;
import flashrush.asentity.framework.entity.Entity;

public class Engine {
	private var _space:EntitySpace;
	private var _componentManager:ComponentHandlerManager;
	private var _componentHandlerMap:IComponentHandlerMap;
	private var _aspectManager:AspectManager;
	
	public function Engine() {
		init();
	}
	
	public function addEntity( entity:Entity ):Entity {
		_space.add( entity );
		return entity;
	}
	
	public function removeEntity( entity:Entity ):Entity {
		_space.remove( entity );
		return entity;
	}
	
	public function getEntities( aspectClass:Class ):AspectList {
		return _aspectManager.getAspects( aspectClass );
	}
	
	protected function init():void {
		_space = new EntitySpace();
		
		_componentManager = new ComponentHandlerManager( _space );
		
		var componentHandlerNotifier:ComponentHandlerNotifier = new ComponentHandlerNotifier();
		_componentHandlerMap = new ComponentMap( componentHandlerNotifier );
		_componentManager.register( componentHandlerNotifier );
		
		_aspectManager = new AspectManager( _space, _componentHandlerMap );
	}
}
}
