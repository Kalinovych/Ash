/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */

package ashx.engine {
import ashx.engine.api.IAspectManager;
import ashx.engine.aspects.AspectList;
import ashx.engine.aspects.AspectsManager;
import ashx.engine.components.ComponentObserver;
import ashx.engine.components.IComponentObserver;
import ashx.engine.entity.Entity;
import ashx.engine.entity.EntityList;
import ashx.engine.lists.LinkedHashMap;

use namespace ecse;

public class ECSEngine {
	ecse var _entities:EntityList;
	ecse var _componentObserver:IComponentObserver;
	ecse var _families:IAspectManager;

	ecse var mEntityFamilies:LinkedHashMap/*<EntityNodeList>*/;

	public function ECSEngine() {
		_entities = new EntityList();
		_componentObserver = new ComponentObserver( _entities );
		_families = new AspectsManager( _entities, _componentObserver );
	}

	public function get entities():EntityList {
		return _entities;
	}

	public function addEntity( entity:Entity ):Entity {
		var id:uint = entity.id;

		if ( _entities.contains( id ) ) {
			throw new Error( "This list already contains an entity with id \"" + id + "\"" );
		}

		return _entities.add( id, entity );
	}

	public function removeEntity( entity:Entity ):Entity {
		var id:uint = entity.id;

		if ( !_entities.contains( id ) ) {
			throw new Error( "An entity with id \"" + id + "\" not fount in this manager" );
		}

		return _entities.remove( id );
	}

	public function removeAllEntities():void {
		while ( _entities._firstNode ) {
			removeEntity( _entities._firstNode.item );
		}
	}

	public function containsEntity( id:uint ):Boolean {
		return _entities.contains( id );
	}

	public function getEntity( id:uint ):Entity {
		return _entities.get( id );
	}

	public function getEntities( familyIdentifier:Class = null ):AspectList {
		_families.getAspects( familyIdentifier );
	}

}
}
