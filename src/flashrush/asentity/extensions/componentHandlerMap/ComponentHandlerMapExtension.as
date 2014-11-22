/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentHandlerMap {
import flashrush.asentity.extensions.componentHandlerMap.api.IComponentHandlerMap;
import flashrush.asentity.framework.core.EntitySpace;

public class ComponentHandlerMapExtension {
	private var _entitySpace:EntitySpace;
	private var _componentHandlerMap:IComponentHandlerMap;
	
	public function ComponentHandlerMapExtension( entitySpace:EntitySpace ) {
		_entitySpace = entitySpace;
	}
	
	public function extend():void {
		var componentHandlerNotifier:ComponentHandlerManager = new ComponentHandlerManager();
		_componentHandlerMap = new ComponentHandlerMap( componentHandlerNotifier );
		_componentManager.addComponentHandler( componentHandlerNotifier );
	}
}
}
