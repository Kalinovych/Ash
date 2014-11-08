/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.core.IComponentObserver;
import flashrush.asentity.framework.core.ProcessingLock;
import flashrush.asentity.framework.entity.Entity;
import flashrush.signatures.api.ISignature;

use namespace asentity;

/**
 * Class responsible for concrete aspect detection
 */
internal class AspectFamily implements IComponentObserver/*, IEntityObserver */ {
	internal var mappingInfo:AspectInfo;
	
	private var _aspects:AspectList = new AspectList();
	
	/** Map of this family nodes by entity */
	internal var aspectByEntity:Dictionary = new Dictionary();
	
	/** Bit representation of the family's required components for fast matching */
	internal var sign:ISignature;
	
	/** Bit representation of the family's excluded components for fast matching */
	internal var excludedSign:ISignature;
	
	private var processingLock:ProcessingLock;
	
	private var disposeCacheHead:Aspect;
	
	private var poolHead:Aspect;
	
	public function AspectFamily( aspectInfo:AspectInfo, processingLock:ProcessingLock ) {
		this.mappingInfo = aspectInfo;
		this.processingLock = processingLock;
	}
	
	/** The list of aspects that belongs to the family. */
	public final function get aspects():AspectList {
		return _aspects;
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
	
	public function onComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		// the node of the aspect of the entity that are exists or not in this family.
		const aspect:Aspect = aspectByEntity[entity];
		
		const field:AspectField = mappingInfo.fieldMap[componentType];
		
		switch ( field.kind ) {
			case AspectField.REQUIRED: // added required component of the aspect
				if ( !aspect ) {
					$createAspectOf( entity );
				}
				break;
			
			case AspectField.OPTIONAL: // added optional component of the aspect
				if ( aspect ) {
					aspect[field.name] = component;
				}
				break;
			
			case AspectField.EXCLUDED: // added aspect exclusion component
				if ( aspect ) {
					$removeAspectOf( entity );
				}
				break;
			
			default:
				// the component is not interested, do nothing.
				break;
		}
	}
	
	public function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		// the node of the aspect of the entity that are exists or not in this family.
		const aspect:Aspect = aspectByEntity[entity];
		
		const field:AspectField = mappingInfo.fieldMap[componentType];
		
		switch ( field.kind ) {
			case AspectField.REQUIRED: // removed required component of the aspect
				if ( aspect ) {
					$removeAspectOf( entity );
				}
				break;
			
			case AspectField.OPTIONAL: // removed optional component of the aspect
				if ( aspect ) {
					aspect[field.name] = null;
				}
				break;
			
			case AspectField.EXCLUDED: // removed aspect exclusion component
				// check is the entity match the aspect now
				if ( !entity._sign.hasAllOf( excludedSign ) ) {
					addQualifiedEntity( entity );
				}
				break;
			
			default:
				// the component is not interested, do nothing.
				break;
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
			poolHead = poolHead.next;
			aspect.cacheNext = null;
		} else {
			aspect = new mappingInfo.type();
		}
		aspect.entity = entity;
		
		for ( var i:int = 0; i < mappingInfo.fieldCount; i++ ) {
			const field:AspectField = mappingInfo.fieldList[i];
			if (field.isRequiredOrOptional) {
				aspect[field.name] = entity.get( field.type );
			}
		}
		
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
	
	private final function $disposeAspect( aspect:Aspect ):void {
		for ( var i:int = 0; i < mappingInfo.fieldCount; i++ ) {
			aspect[mappingInfo.fieldList[i].name] = null;
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
