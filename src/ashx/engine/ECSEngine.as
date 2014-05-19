/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */

package ashx.engine {
import ashx.engine.api.IAspectManager;
import ashx.engine.aspects.AspectList;
import ashx.engine.aspects.AspectManager;
import ashx.engine.components.ComponentManager;
import ashx.engine.components.IComponentManager;
import ashx.engine.entity.Entity;
import ashx.engine.entity.EntityList;

use namespace ecse;

public class ECSEngine {
	protected var _entities:EntityList;
	protected var _components:ComponentManager;
	protected var _aspects:AspectManager;
	protected var _systems:*;

	//ecse var mEntityFamilies:LinkedHashMap/*<EntityNodeList>*/;

	public function ECSEngine() {
		_entities = new EntityList();
		_components = new ComponentManager( _entities );
		_aspects = new AspectManager( _entities, _components );
	}

	public function get entities():EntityList {
		return _entities;
	}

	public function get componentManager():IComponentManager {
		return _components;
	}

	public function get aspectManager():IAspectManager {
		return _aspects;
	}

	public function addEntity( entity:Entity ):Entity {
		var id:uint = entity._id;
		if ( _entities.contains( id ) ) {
			throw new Error( "This list already contains an entity with id \"" + id + "\"" );
		}

		return _entities.add( entity );
	}

	public function removeEntity( entity:Entity ):Entity {
		var id:uint = entity.id;

		if ( !_entities.contains( id ) ) {
			throw new Error( "An entity with id \"" + id + "\" not fount in this manager" );
		}

		return _entities.remove( entity );
	}

	public function removeAllEntities():void {
		_entities.removeAll();
	}

	public function containsEntity( id:uint ):Boolean {
		return _entities.contains( id );
	}

	public function getEntity( id:uint ):Entity {
		return _entities.get( id );
	}

	public function getEntities( familyIdentifier:Class = null ):AspectList {
		_aspects.getAspects( familyIdentifier );
	}

}
}
