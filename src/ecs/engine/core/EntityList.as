/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core {
import flashrush.asentity.framework.entity.Entity;

public class EntityList {
	private var entities:LinkedEntityList;
	
	public function EntityList( entities:LinkedEntityList ) {
		this.entities = entities;
	}
	
	public final function get first():Entity {
		return entities.first;
	}
	
	public final function get last():Entity {
		return entities.last;
	}
	
	public function get length():uint {
		return entities.length;
	}
	
}
}
