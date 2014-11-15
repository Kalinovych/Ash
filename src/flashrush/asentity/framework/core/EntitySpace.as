/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.core {
import flash.errors.IllegalOperationError;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityObserver;
import flashrush.asentity.framework.utils.BitSign;
import flashrush.collections.InternalLinkedSet;
import flashrush.collections.base.LLNodeBase;
import flashrush.collections.list_internal;
import flashrush.signals.ICallbacks;
import flashrush.signals.Signal1;
import flashrush.signals.Signal3;

use namespace asentity;

public class EntitySpace {
	/**
	 * Dev:
	 *   linear handlers or concurrent signals?
	 *
	 *   is it possible withing handlers notification added another entity?
	 *
	 *   Possible call stack;
	 *      addEntity
	 *          notify handlers
	 *              aspectManager process components of added entity
	 *                  creates an aspect
	 *                      notifies aspect added
	 *                          system process added aspect
	 *                              is some cases add/remove an other entity?
	 *
	 *
	 */
	
	private var _entities:EntityList = new EntityList( this );
	private var _entityHandlers:InternalLinkedSet = new InternalLinkedSet();
	
	//protected var _OnEntityAdded:Signal1 = new Signal1( Entity );
	//protected var _OnEntityRemoved:Signal1 = new Signal1( Entity );
	
	public function EntitySpace() {
		super();
	}

//-------------------------------------------
// Properties
//-------------------------------------------
	
	public final function get firstEntity():Entity {
		return _entities.first;
	}
	
	public final function get lastEntity():Entity {
		return _entities.last;
	}
	
	public final function get entityCount():uint {
		return _entities.length;
	}
	
	/*public final function get OnEntityAdded():ICallbacks {
		return _OnEntityAdded;
	}
	
	public final function get OnEntityRemoved():ICallbacks {
		return _OnEntityRemoved;
	}*/

//-------------------------------------------
// Public methods
//-------------------------------------------
	
	public function add( entity:Entity ):Entity {
		CONFIG::debug{
			if ( entity.space && entity.space != this ) {
				throw new IllegalOperationError( "The entity belongs to an other space and can't be added!" );
			}
		}
		
		if ( !entity.space ) {
			_entities.add( entity );
			$processAddedEntity( entity );
		}
		return entity;
	}
	
	public function contains( entity:Entity ):Boolean {
		return (entity.space == this);
	}
	
	public function remove( entity:Entity ):Entity {
		CONFIG::debug{
			if ( entity.space && entity.space != this ) {
				throw new IllegalOperationError( "The entity belongs to an other space and can't be removed from this one." );
			}
		}
		
		if ( entity.space == this ) {
			_entities.remove( entity );
			$processRemovedEntity( entity );
		}
		return entity;
	}
	
	public function removeAll():void {
		_entities.removeAll( $processRemovedEntity );
	}
	
	public function filterEntities( bits:BitSign, mask:BitSign, handler:Function ):void {
		for ( var entity:Entity = firstEntity; entity; entity = entity.next ) {
			if ( entity.componentBits.hasAllOf( bits, mask ) ) {
				handler( entity );
			}
		}
	}

//-------------------------------------------
// Framework internals
//-------------------------------------------
	
	asentity function addEntityHandler( handler:IEntityObserver ):void {
		_entityHandlers.add( handler );
	}
	
	asentity function removeEntityHandler( handler:IEntityObserver ):void {
		_entityHandlers.remove( handler );
	}

//-------------------------------------------
// Protected helpers
//-------------------------------------------
	
	[Inline]
	protected final function $processAddedEntity( entity:Entity ):void {
		//_OnEntityAdded.dispatch( entity );
		
		use namespace list_internal;
		
		for ( var node:LLNodeBase = _entityHandlers.firstNode; node; node = node.next ) {
			const handler:IEntityObserver = node.item;
			handler.onEntityAdded( entity );
		}
	}
	
	[Inline]
	protected final function $processRemovedEntity( entity:Entity ):void {
		//_OnEntityRemoved.dispatch( entity );
		
		use namespace list_internal;
		
		for ( var node:LLNodeBase = _entityHandlers.firstNode; node; node = node.next ) {
			const handler:IEntityObserver = node.item;
			handler.onEntityRemoved( entity );
		}
	}
}
}
