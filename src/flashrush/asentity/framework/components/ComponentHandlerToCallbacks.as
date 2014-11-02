/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.components {
import flashrush.asentity.framework.components.api.IComponentHandler;
import flashrush.asentity.framework.entity.Entity;

public class ComponentHandlerToCallbacks implements IComponentHandler {
	public var addedCallback:Function;
	public var removedCallback:Function;
	
	public function ComponentHandlerToCallbacks( addedCallback:Function = null, removedCallback:Function = null ) {
		this.addedCallback = addedCallback;
		this.removedCallback = removedCallback;
	}
	
	public function onComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		if ( addedCallback ) {
			addedCallback( entity, componentType, component );
		}
	}
	
	public function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		if ( removedCallback ) {
			removedCallback( entity, componentType, component );
		}
	}
}
}
