/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.entityMapExtension {
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityObserver;

internal class SimpleEntityMap implements EntityMap, IEntityObserver {
	protected var entityByName:Object = {};

	public function SimpleEntityMap() {
	}

	public function get( name:String ):Entity {
		return entityByName[name];
	}

	public function onEntityAdded( entity:Entity ):void {
		var name:Name = entity.get( Name );
		name && ( entityByName[name.name] = entity );
	}

	public function onEntityRemoved( entity:Entity ):void {
		var name:Name = entity.get( Name );
		name && ( delete entityByName[name.name] );
	}

	internal function dispose():void {
		entityByName = null;
	}
}
}
