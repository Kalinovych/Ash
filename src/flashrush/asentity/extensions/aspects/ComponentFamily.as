/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flash.utils.Dictionary;

import flashrush.asentity.framework.components.IComponentProcessor;
import flashrush.asentity.framework.core.ConsistencyLock;
import flashrush.asentity.framework.entity.Entity;

/**
 * Groups entities containing specified component type into a single linked list.
 */
public class ComponentFamily implements IComponentProcessor {
	internal var mappingType:Class;
	internal var aspectByEntity:Dictionary/*<Entity,Aspect>*/ = new Dictionary();
	private var _aspects:NodeList = new NodeList();
	private var consistencyLock:ConsistencyLock;
	
	private var disposeCacheHead:EntityNode;
	private static var poolHead:EntityNode;
	
	public function ComponentFamily( componentType:Class, consistencyLock:ConsistencyLock ) {
		this.mappingType = componentType;
		this.consistencyLock = consistencyLock;
	}
	
	public final function get aspects():NodeList {
		return _aspects;
	}
	
	/** Adds an Entity containing the component of the mapping type to the aspect list*/
	public function addQualifiedEntity( entity:Entity ):void {
		if ( !aspectByEntity[entity] ) {
			$createAspectOf( entity );
		}
	}
	
	/** Removes an Entity containing the component of the mapping type from the aspects list */
	public function removeQualifiedEntity( entity:Entity ):void {
		if ( aspectByEntity[entity] ) {
			$removeAspectOf( entity );
		}
	}
	
	public function processAddedComponent( entity:Entity, componentType:Class, component:* ):void {
		if ( componentType == mappingType && !aspectByEntity[entity] ) {
			$createAspectOf( entity );
		}
	}
	
	public function processRemovedComponent( entity:Entity, componentType:Class, component:* ):void {
		if ( componentType == mappingType && aspectByEntity[entity] ) {
			$removeAspectOf( entity );
		}
	}
	
//-------------------------------------------
// Internals
//-------------------------------------------
	
	/**
	 * Creates new family's aspect for the matched entity
	 * createNode() should be called after verification of existence all required components in the entity.
	 * @param entity
	 */
	[Inline]
	private final function $createAspectOf( entity:Entity ):void {
		var aspect:EntityNode;
		if ( poolHead ) {
			aspect = poolHead;
			poolHead = poolHead.cacheNext;
			aspect.cacheNext = null;
		} else {
			aspect = new EntityNode();
		}
		aspect.entity = entity;
		aspectByEntity[entity] = aspect;
		_aspects.add( aspect );
	}
	
	[Inline]
	private final function $removeAspectOf( entity:Entity ):void {
		const aspect:EntityNode = aspectByEntity[entity];
		delete aspectByEntity[entity];
		_aspects.remove( aspect );
		
		if ( consistencyLock.isLocked ) {
			aspect.cacheNext = disposeCacheHead;
			disposeCacheHead = aspect;
			consistencyLock.onUnlocks( releaseCache );
		} else {
			$disposeAspect( aspect )
		}
	}
	
	private final function $disposeAspect( aspect:EntityNode ):void {
		aspect.entity = null;
		aspect.prev = null;
		aspect.next = null;
		
		aspect.cacheNext = poolHead;
		poolHead = aspect;
	}
	
	private function releaseCache():void {
		while ( disposeCacheHead ) {
			const aspect:EntityNode = disposeCacheHead;
			disposeCacheHead = disposeCacheHead.cacheNext;
			
			aspect.cacheNext = null;
			$disposeAspect( aspect );
		}
	}
	
}
}
