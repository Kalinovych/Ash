/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine {
import flashrush.asentity.extensions.componentHandlerMap.ComponentHandlerMap;
import flashrush.asentity.extensions.componentHandlerMap.ComponentHandlerManager;
import flashrush.asentity.extensions.componentHandlerMap.api.IComponentHandlerMap;
import flashrush.asentity.framework.componentManager.ComponentManager;
import flashrush.asentity.framework.core.EntitySpace;

public class Engine {
	private var _space:EntitySpace;
	private var _componentManager:ComponentManager;
	private var _componentHandlerMap:IComponentHandlerMap;
	
	public function Engine() {
		_space = new EntitySpace();
		_componentManager = new ComponentManager( _space );
		
		var componentHandlerNotifier:ComponentHandlerManager = new ComponentHandlerManager();
		_componentHandlerMap = new ComponentHandlerMap( componentHandlerNotifier );
		_componentManager.addComponentHandler( componentHandlerNotifier );
	}
}
}
