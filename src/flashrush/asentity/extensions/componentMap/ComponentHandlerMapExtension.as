/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentMap {
import flashrush.asentity.extensions.componentMap.api.IComponentHandlerMap;
import flashrush.asentity.framework.core.EntitySpace;

public class ComponentHandlerMapExtension {
	private var _entitySpace:EntitySpace;
	private var _componentHandlerMap:IComponentHandlerMap;
	
	public function ComponentHandlerMapExtension( entitySpace:EntitySpace ) {
		_entitySpace = entitySpace;
	}
	
	public function extend():void {
		var componentHandlerNotifier:ComponentHandlerNotifier = new ComponentHandlerNotifier();
		_componentHandlerMap = new ComponentHandlerMap( componentHandlerNotifier );
		_componentManager.addComponentHandler( componentHandlerNotifier );
	}
}
}
