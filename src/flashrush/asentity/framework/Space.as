/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework {
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.EntityCollection;

public class Space {
	protected var _entities:EntityCollection = new EntityCollection();
	
	public function Space() {
	}
	
	public function addEntity( entity:Entity ):void {
		_entities.add( entity );
	}
	
	public function contains( entity:Entity ):Boolean {
		_entities.contains( entity );
	}
	
	public function removeEntity( entity:Entity ):void {
		_entities.remove( entity );
	}
	
	public function clear():void {
		_entities.removeAll();
	}
	
}
}
