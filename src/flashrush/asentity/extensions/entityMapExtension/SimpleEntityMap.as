/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.entityMapExtension {
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityHandler;

internal class SimpleEntityMap implements EntityMap, IEntityHandler {
	protected var entityByName:Object = {};

	public function SimpleEntityMap() {
	}

	public function get( name:String ):Entity {
		return entityByName[name];
	}

	public function handleEntityAdded( entity:Entity ):void {
		var name:Name = entity.get( Name );
		name && ( entityByName[name.name] = entity );
	}

	public function handleEntityRemoved( entity:Entity ):void {
		var name:Name = entity.get( Name );
		name && ( delete entityByName[name.name] );
	}

	internal function dispose():void {
		entityByName = null;
	}
}
}
