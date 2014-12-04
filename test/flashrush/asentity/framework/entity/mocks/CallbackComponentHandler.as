/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.entity.mocks {
import flashrush.asentity.framework.components.IComponentHandler;
import flashrush.asentity.framework.entity.Entity;

public class CallbackComponentHandler implements IComponentHandler {
	private var _addedCallback:Function;
	private var _removedCallback:Function;
	
	public function CallbackComponentHandler( addedCallback:Function = null, removedCallback:Function = null ) {
		_addedCallback = addedCallback;
		_removedCallback = removedCallback;
	}
	
	public function handleComponentAdded( component:*, componentType:Class, entity:Entity ):void {
		_addedCallback && _addedCallback( component, componentType, entity );
	}
	
	public function handleComponentRemoved( component:*, componentType:Class, entity:Entity ):void {
		_removedCallback && _removedCallback( component, componentType, entity );
	}
}
}
