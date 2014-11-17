/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.core.ConsistencyLock;
import flashrush.asentity.framework.components.IComponentProcessor;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.utils.BitSign;

use namespace asentity;

/**
 * Class responsible for concrete aspect detection
 */
internal class AspectFamily implements IComponentProcessor/*, IEntityObserver */ {
	internal var aspectInfo:AspectInfo;
	
	internal var aspects:AspectList = new AspectList();
	internal var aspectByEntity:Dictionary = new Dictionary();
	
	internal var bits:BitSign;
	internal var mask:BitSign;
	
	private var consistencyLock:ConsistencyLock;
	
	private var poolHead:Aspect;
	private var disposeCacheHead:Aspect;
	
	/**
	 * Constructs new family of the aspect
	 * @param aspectInfo
	 * @param consistencyLock
	 */
	public function AspectFamily( aspectInfo:AspectInfo, consistencyLock:ConsistencyLock = null ) {
		this.aspectInfo = aspectInfo;
		this.consistencyLock = consistencyLock;
	}
	
	public function addQualifiedEntity( entity:Entity ):void {
		if ( !aspectByEntity[entity] ) {
			$createAspectOf( entity );
		}
	}
	
	public function removeQualifiedEntity( entity:Entity ):void {
		if ( aspectByEntity[entity] ) {
			$removeAspectOf( entity );
		}
	}
	
	public function processAddedComponent( entity:Entity, componentType:Class, component:* ):void {
		// the node of the aspect of the entity that are exists or not in this family.
		const aspect:Aspect = aspectByEntity[entity];
		const trait:FamilyTrait = aspectInfo.traitMap[componentType];
		
		if ( !trait ) return;
		
		switch ( trait.kind ) {
			case FamilyTrait.REQUIRED:
				// the entity obtains one of the aspect traits
				if ( !aspect && entity.componentBits.hasAllOf( bits, mask ) ) {
					$createAspectOf( entity );
				}
				break;
			
			case FamilyTrait.OPTIONAL:
				if ( aspect ) {
					aspect[trait.fieldName] = component;
				}
				break;
			
			case FamilyTrait.EXCLUDED: // added aspect exclusion component
				if ( aspect ) {
					$removeAspectOf( entity );
				}
				break;
		}
	}
	
	public function processRemovedComponent( entity:Entity, componentType:Class, component:* ):void {
		// the node of the aspect of the entity that are exists or not in this family.
		const aspect:Aspect = aspectByEntity[entity];
		const trait:FamilyTrait = aspectInfo.traitMap[componentType];
		
		// exit if the family hasn't such trait
		if ( !trait ) return;
		
		switch ( trait.kind ) {
			case FamilyTrait.REQUIRED:
				// aspect lost it trait
				if ( aspect ) {
					$removeAspectOf( entity );
				}
				break;
			
			case FamilyTrait.OPTIONAL:
				// just clear the reference
				if ( aspect ) {
					aspect[trait.fieldName] = null;
				}
				break;
			
			case FamilyTrait.EXCLUDED:
				// removed component that denies the aspect
				// check is the entity fits the aspect now
				if ( entity.componentBits.hasAllOf( bits, mask ) ) {
					addQualifiedEntity( entity );
				}
				break;
		}
	}
	
	//-------------------------------------------
	// Protected
	//-------------------------------------------
	
	/**
	 * Command to create new family's aspect for the matched entity
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
			poolHead = poolHead.next;
			aspect.cacheNext = null;
		} else {
			aspect = new aspectInfo.type();
		}
		aspect.entity = entity;
		
		// set components to aspect fields if it has own class. 
		if ( aspectInfo.type != Aspect ) {
			for ( var i:int = 0; i < aspectInfo.traitCount; i++ ) {
				const trait:FamilyTrait = aspectInfo.traits[i];
				if ( trait.fieldName && trait.isNotExcluded ) {
					aspect[trait.fieldName] = entity.get( trait.type );
				}
			}
		}
		
		aspectByEntity[entity] = aspect;
		aspects.add( aspect );
	}
	
	[Inline]
	private final function $removeAspectOf( entity:Entity ):void {
		const aspect:Aspect = aspectByEntity[entity];
		delete aspectByEntity[entity];
		aspects.remove( aspect );
		
		if ( consistencyLock && consistencyLock.isLocked ) {
			aspect.cacheNext = disposeCacheHead;
			disposeCacheHead = aspect;
			consistencyLock.onUnlocks( releaseCache );
		} else {
			$disposeAspect( aspect )
		}
	}
	
	private final function $disposeAspect( aspect:Aspect ):void {
		for ( var i:int = 0; i < aspectInfo.traitCount; i++ ) {
			aspect[aspectInfo.traits[i].fieldName] = null;
		}
		
		aspect.entity = null;
		aspect.prev = null;
		aspect.next = null;
		
		aspect.cacheNext = poolHead;
		poolHead = aspect;
	}
	
	
	private function releaseCache():void {
		while ( disposeCacheHead ) {
			const aspect:Aspect = disposeCacheHead;
			disposeCacheHead = disposeCacheHead.cacheNext;
			
			aspect.cacheNext = null;
			$disposeAspect( aspect );
		}
	}
	
}
}
