/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine {
import flashrush.asentity.extensions.aspects.NodeList;
import flashrush.asentity.extensions.aspects.AspectManager;
import flashrush.asentity.extensions.componentHandlerMap.ComponentHandlerProcessor;
import flashrush.asentity.extensions.componentHandlerMap.ComponentHandlerMap;
import flashrush.asentity.extensions.componentHandlerMap.api.IComponentHandlerMap;
import flashrush.asentity.framework.components.ComponentHandlerManager;
import flashrush.asentity.framework.components.IComponentHandlerManager;
import flashrush.asentity.framework.core.EntitySpace;
import flashrush.asentity.framework.entity.Entity;

public class Engine {
	private var _space:EntitySpace;
	private var _componentHandlerManager:IComponentHandlerManager;
	private var _componentMap:IComponentHandlerMap;
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
	
	public function getEntities( aspectClass:Class ):NodeList {
		return _aspectManager.getAspects( aspectClass );
	}
	
	//-------------------------------------------
	// Protected methods                         
	//-------------------------------------------
	
	protected function init():void {
		initSpace();
		initComponentHandlerManager();
		initComponentMap();
		initAspectManager();
	}
	
	protected function initSpace():void {
		_space = new EntitySpace();
	}
	
	protected function initComponentHandlerManager():void {
		_componentHandlerManager = new ComponentHandlerManager( _space );
	}
	
	protected function initComponentMap():void {
		_componentMap = new ComponentHandlerMap( _componentHandlerManager );
	}
	
	protected function initAspectManager():void {
		_aspectManager = new AspectManager( _space, _componentMap );
	}
	
}
}
