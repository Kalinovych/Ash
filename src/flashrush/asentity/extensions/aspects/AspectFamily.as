/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.components.IComponentHandler;
import flashrush.asentity.framework.core.ConsistencyLock;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.utils.BitSign;

use namespace asentity;

/**
 * Class responsible for concrete aspect detection
 */
public class AspectFamily implements IComponentHandler/*, IEntityObserver */ {
	internal var aspectInfo:AspectInfo;
	
	internal var aspects:AspectList = new AspectList();
	internal var aspectByEntity:Dictionary = new Dictionary();
	
	internal var bits:BitSign;
	internal var mask:BitSign;
	
	private var consistencyLock:ConsistencyLock;
	
	private var poolHead:AspectNode;
	private var disposeCacheHead:AspectNode;
	
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
	
	public function handleComponentAdded( component:*, componentType:Class, entity:Entity ):void {
		// the node of the aspect of the entity that are exists or not in this family.
		const aspect:AspectNode = aspectByEntity[entity];
		const trait:AspectTrait = aspectInfo.traitMap[componentType];
		
		if ( !trait ) return;
		
		switch ( trait.kind ) {
			case AspectTrait.REQUIRED:
				// the entity obtains one of the aspect traits
				if ( !aspect && entity.componentBits.hasAllOf( bits, mask ) ) {
					$createAspectOf( entity );
				}
				break;
			
			case AspectTrait.OPTIONAL:
				if ( aspect && trait.autoInject ) {
					aspect[trait.fieldName] = component;
				}
				break;
			
			case AspectTrait.EXCLUDED: // added aspect exclusion component
				if ( aspect ) {
					$removeAspectOf( entity );
				}
				break;
		}
	}
	
	public function handleComponentRemoved( component:*, componentType:Class, entity:Entity ):void {
		// the node of the aspect of the entity that are exists or not in this family.
		const aspect:AspectNode = aspectByEntity[entity];
		const trait:AspectTrait = aspectInfo.traitMap[componentType];
		
		// exit if the family hasn't such trait
		if ( !trait ) return;
		
		switch ( trait.kind ) {
			case AspectTrait.REQUIRED:
				// aspect lost it trait
				if ( aspect ) {
					$removeAspectOf( entity );
				}
				break;
			
			case AspectTrait.OPTIONAL:
				// just clear the reference
				if ( aspect && trait.autoInject ) {
					aspect[trait.fieldName] = null;
				}
				break;
			
			case AspectTrait.EXCLUDED:
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
		var aspect:AspectNode;
		if ( poolHead ) {
			aspect = poolHead;
			poolHead = poolHead.next;
			aspect.cacheNext = null;
		} else {
			aspect = new aspectInfo.type();
		}
		aspect.entity = entity;
		
		// set components to aspect fields if it has own class. 
		if ( aspectInfo.type != AspectNode ) {
			for ( var i:int = 0; i < aspectInfo.traitCount; i++ ) {
				const trait:AspectTrait = aspectInfo.traits[i];
				if ( trait.autoInject ) {
					aspect[trait.fieldName] = entity.get( trait.type );
				}
			}
		}
		
		aspectByEntity[entity] = aspect;
		aspects.add( aspect );
	}
	
	[Inline]
	private final function $removeAspectOf( entity:Entity ):void {
		const aspect:AspectNode = aspectByEntity[entity];
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
	
	private final function $disposeAspect( aspect:AspectNode ):void {
		for ( var i:int = 0; i < aspectInfo.traitCount; i++ ) {
			const trait:AspectTrait = aspectInfo.traits[i];
			if ( trait.autoInject ) {
				aspect[trait.fieldName] = null;
			}
		}
		
		aspect.entity = null;
		aspect.prev = null;
		aspect.next = null;
		
		aspect.cacheNext = poolHead;
		poolHead = aspect;
	}
	
	
	private function releaseCache():void {
		while ( disposeCacheHead ) {
			const aspect:AspectNode = disposeCacheHead;
			disposeCacheHead = disposeCacheHead.cacheNext;
			
			aspect.cacheNext = null;
			$disposeAspect( aspect );
		}
	}
	
}
}
