/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.core {
import flash.errors.IllegalOperationError;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityHandler;
import flashrush.collections.LinkedSet;
import flashrush.collections.base.LLNodeBase;
import flashrush.collections.list_internal;

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
	
	private var _entities:EntityLinker = new EntityLinker( this );
	private var _handlers:LinkedSet = new LinkedSet();
	
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
			_entities.link( entity );
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
			_entities.unlink( entity );
			$processRemovedEntity( entity );
		}
		return entity;
	}
	
	public function removeAll():void {
		_entities.unlinkAll( $processRemovedEntity );
	}
	
//-------------------------------------------
// Framework internals
//-------------------------------------------
	
	asentity function addEntityHandler( handler:IEntityHandler ):void {
		_handlers.add( handler );
	}
	
	asentity function removeEntityHandler( handler:IEntityHandler ):void {
		_handlers.remove( handler );
	}

//-------------------------------------------
// Protected helpers
//-------------------------------------------
	
	[Inline]
	protected final function $processAddedEntity( entity:Entity ):void {
		use namespace list_internal;
		
		for ( var node:LLNodeBase = _handlers.firstNode; node; node = node.next ) {
			const handler:IEntityHandler = node.item;
			handler.handleEntityAdded( entity );
		}
	}
	
	[Inline]
	protected final function $processRemovedEntity( entity:Entity ):void {
		use namespace list_internal;
		
		for ( var node:LLNodeBase = _handlers.firstNode; node; node = node.next ) {
			const handler:IEntityHandler = node.item;
			handler.handleEntityRemoved( entity );
		}
	}
}
}
