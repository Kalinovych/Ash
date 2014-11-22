/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core {
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.core.EntityLinker;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.api.IEntityProcessor;
import flashrush.asentity.framework.systems.SystemList;
import flashrush.asentity.framework.systems.api.ISystem;
import flashrush.asentity.framework.systems.api.ISystemHandler;
import flashrush.collections.InternalLinkedSet;
import flashrush.collections.LLNodeBase;
import flashrush.collections.list_internal;

use namespace asentity;

/**
 * Scoped collection of entities and systems
 */
public class ESContext {
	asentity var entityList:EntityLinker = new EntityLinker();
	asentity var systemList:SystemList = new SystemList();
	
	private var entityHandlers:InternalLinkedSet = new InternalLinkedSet();
	private var systemHandlers:InternalLinkedSet = new InternalLinkedSet();
	
	public function ESContext() {}
	
	public function addEntity( entity:Entity ):Entity {
		entityList.link( entity );
		
		$notifyEntityAdded( entity );
		return entity;
	}
	
	public function removeEntity( entity:Entity ):Entity {
		entityList.unlink( entity );
		
		$notifyEntityRemoved( entity );
		return entity;
	}
	
	public function removeAllEntities():void {
		entityList.unlinkAll( $notifyEntityRemoved );
	}
	
	public function addSystem( system:ISystem, order:int = 0 ):* {
		systemList.add( system, order );
		
		use namespace list_internal;
		
		for ( var node:LLNodeBase = systemHandlers.firstNode; node; node = node.next ) {
			const handler:ISystemHandler = node.item;
			handler.onSystemAdded( system );
		}
		return system;
	}
	
	public function removeSystem( system:ISystem ):* {
		systemList.remove( system );
		
		use namespace list_internal;
		
		for ( var node:LLNodeBase = systemHandlers.lastNode; node; node = node.prev ) {
			const handler:ISystemHandler = node.item;
			handler.onSystemRemoved( system );
		}
		return system;
	}
	
	//-------------------------------------------
	// Framework internal methods
	//-------------------------------------------
	
	asentity function registerHandler( handler:* ):Boolean {
		var registered:Boolean = false;
		
		if ( handler is IEntityProcessor ) {
			registered ||= entityHandlers.add( handler );
		}
		
		if ( handler is ISystemHandler ) {
			registered ||= systemHandlers.add( handler );
		}
		
		if ( !registered ) {
			trace( "[ESContext.registerHandler]› WARNING: Handler " + handler + " wasn't registered!" );
		}
		
		return registered;
	}
	
	asentity function unregisterHandler( handler:* ):void {
		if ( handler is IEntityProcessor ) {
			entityHandlers.remove( handler );
		}
		
		if ( handler is ISystemHandler ) {
			systemHandlers.remove( handler );
		}
	}
	
	//-------------------------------------------
	// Protected methods
	//-------------------------------------------
	
	[Inline]
	protected final function $notifyEntityAdded( entity:Entity ):void {
		use namespace list_internal;
		
		for ( var node:LLNodeBase = entityHandlers.firstNode; node; node = node.next ) {
			const handler:IEntityProcessor = node.item;
			handler.processAddedEntity( entity );
		}
	}
	
	[Inline]
	protected final function $notifyEntityRemoved( entity:Entity ):void {
		use namespace list_internal;
		
		for ( var node:LLNodeBase = entityHandlers.lastNode; node; node = node.prev ) {
			const handler:IEntityProcessor = node.item;
			handler.processRemovedEntity( entity );
		}
	}
}
}
