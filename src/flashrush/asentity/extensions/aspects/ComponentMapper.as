/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flash.utils.Dictionary;

import flashrush.asentity.framework.core.ProcessingLock;

import flashrush.asentity.framework.entity.Entity;

/**
 * Groups entities containing specified component type into single AspectList<Aspect>.
 */
public class ComponentMapper {
	internal var mappingType:Class;
	internal var aspectByEntity:Dictionary = new Dictionary();
	private var _aspects:AspectListBuilder = new AspectListBuilder();
	private var processingLock:ProcessingLock;
	
	private var disposeCacheHead:Aspect;
	private static var poolHead:Aspect;
	
	public function ComponentMapper( componentType:Class, processingLock:ProcessingLock ) {
		this.mappingType = componentType;
		this.processingLock = processingLock;
	}
	
	public final function get aspects():AspectList {
		return _aspects.list;
	}
	
	public function onComponentAddedToEntity( entity:Entity, componentType:Class, component:* ):void {
		if ( componentType == mappingType && !aspectByEntity[entity] ) {
			$createAspectOf( entity );
		}
	}
	
	public function onComponentRemovedFromEntity( entity:Entity, componentType:Class, component:* ):void {
		if ( componentType == mappingType && !aspectByEntity[entity] ) {
			$removeAspectOf( entity );
		}
	}
	
	/** Adds an Entity containing the component of the mapping type to the aspect list*/
	public function includeEntity( entity:Entity ):void {
		if ( !aspectByEntity[entity] ) {
			$createAspectOf( entity );
		}
	}
	
	/** Removes an Entity containing the component of the mapping type from the aspects list */
	public function excludeEntity( entity:Entity ):void {
		if ( aspectByEntity[entity] ) {
			$removeAspectOf( entity );
		}
	}
	
	/**
	 * Creates new family's aspect for the matched entity
	 * createNode() should be called after verification of existence all required components in the entity.
	 * @param entity
	 */
	[Inline]
	private final function $createAspectOf( entity:Entity ):void {
		// Create new aspect node and assign components from the entity to the aspect variables
		//var aspect:Node = nodePool.get();
		var aspect:Aspect;
		if ( poolHead ) {
			aspect = poolHead;
			poolHead = poolHead.cacheNext;
			aspect.cacheNext = null;
		} else {
			aspect = new Aspect();
		}
		aspect.entity = entity;
		aspectByEntity[entity] = aspect;
		_aspects.add( aspect );
	}
	
	[Inline]
	private final function $removeAspectOf( entity:Entity ):void {
		const aspect:Aspect = aspectByEntity[entity];
		delete aspectByEntity[entity];
		_aspects.remove( aspect );
		
		if ( processingLock.isLocked ) {
			aspect.cacheNext = disposeCacheHead;
			disposeCacheHead = aspect;
			processingLock.onUnlocks( releaseCache );
		} else {
			$disposeAspect( aspect )
		}
	}
	
	private function releaseCache():void {
		while ( disposeCacheHead ) {
			const aspect:Aspect = disposeCacheHead;
			disposeCacheHead = disposeCacheHead.cacheNext;
			
			aspect.cacheNext = null;
			$disposeAspect( aspect );
		}
	}
	
	private final function $disposeAspect( aspect:Aspect ):void {
		aspect.entity = null;
		aspect.prev = null;
		aspect.next = null;
		
		aspect.cacheNext = poolHead;
		poolHead = aspect;
	}
}
}