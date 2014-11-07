/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.components.api.IComponentHandler;
import flashrush.asentity.framework.core.ProcessingLock;
import flashrush.asentity.framework.entity.Entity;
import flashrush.signatures.api.ISignature;

use namespace asentity;

/**
 * Class responsible for concrete aspect detection
 */
internal class AspectMapper implements IComponentHandler/*, IEntityObserver */ {
	internal var mappingInfo:AspectInfo;
	
	private var _aspects:AspectListBuilder = new AspectListBuilder();
	
	/** Map of this family nodes by entity */
	internal var aspectByEntity:Dictionary = new Dictionary();
	
	/** Bit representation of the family's required components for fast matching */
	internal var sign:ISignature;
	
	/** Bit representation of the family's excluded components for fast matching */
	internal var exclusionSign:ISignature;
	
	private var processingLock:ProcessingLock;
	
	private var disposeCacheHead:Aspect;
	
	private var poolHead:Aspect;
	
	public function AspectMapper( aspectInfo:AspectInfo, processingLock:ProcessingLock ) {
		this.mappingInfo = aspectInfo;
		this.processingLock = processingLock;
	}
	
	public function get aspects():AspectList {
		return _aspects.list;
	}
	
	public function registerEntity( entity:Entity ):void {
		//entity.ecse::addComponentObserver( this );
		
		// do nothing if an entity already identified in this family
		if ( aspectByEntity[entity] ) {
			return;
		}
		
		$createAspectOf( entity );
	}
	
	public function unRegisterEntity( entity:Entity ):void {
		//entity.ecse::removeComponentObserver( this );
		
		if ( aspectByEntity[entity] ) {
			$removeAspectOf( entity );
		}
	}
	
	public function onComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		// the node of the aspect of the entity that are exists or not in this family.
		const aspect:Aspect = aspectByEntity[entity];
		
		// the kind of interest to the added component by this aspect.
		const kind:int = mappingInfo.interestKindMap[componentType];
		
		switch ( kind ) {
			case AspectInfo.REQUIRED_KIND: // added required component of the aspect
				if ( !aspect ) {
					$createAspectOf( entity );
				}
				break;
			
			case AspectInfo.OPTIONAL_KIND: // added optional component of the aspect
				if ( aspect ) {
					const fieldName:String = mappingInfo.optionalMap[componentType];
					aspect[fieldName] = entity.get( componentType );
				}
				break;
			
			case AspectInfo.EXCLUDED_KIND: // added aspect exclusion component
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
		
		// the kind of interest to the added component by this aspect.
		const kind:int = mappingInfo.interestKindMap[componentType];
		
		switch ( kind ) {
			case AspectInfo.REQUIRED_KIND: // removed required component of the aspect
				if ( aspect ) {
					$removeAspectOf( entity );
				}
				break;
			
			case AspectInfo.OPTIONAL_KIND: // removed optional component of the aspect
				if ( aspect ) {
					const fieldName:String = mappingInfo.optionalMap[componentType];
					aspect[fieldName] = null;
				}
				break;
			
			case AspectInfo.EXCLUDED_KIND: // removed aspect exclusion component
				// check is the entity match the aspect now
				if ( !entity._sign.hasAllOf( exclusionSign ) ) {
					registerEntity( entity );
				}
				break;
			
			default:
				// the component is not interested, do nothing.
				break;
		}
	}
	
	/*public function onComponentAdded( entity:Entity, componentType:Class, component:* ):void {
		// The node of the entity if it belongs to this family.
		var node:Aspect = aspectByEntity[entity];
		
		// Check is new component excludes the entity from this family
		if ( excludedComponents && excludedComponents[componentType] ) {
			if ( node ) {
				$removeAspectOf( entity );
			}
			return;
		}
		
		// An optional component can't affect entity matching to the family.
		// If a component is optional just put the reference to the node property 
		if ( node && optionalComponents && optionalComponents[componentType] ) {
			var property:String = optionalComponents[componentType];
			node[property] = entity.get( componentType );
			return;
		}
		
		// do nothing if the entity already identified as member of this family or a component isn't required by this family
		if ( node || !propertyMap[componentType] ) {
			return;
		}
		
		$createAspectOf( entity );
	}
	
	public function onComponentRemoved( entity:Entity, componentType:Class, component:* ):void {
		// The node of the entity if it belongs to this family.
		var node:Aspect = aspectByEntity[entity];
		
		// Check is removed component makes the entity as a member of this family
		if ( excludedComponents && excludedComponents[component] ) {
			// no more unacceptable components?
			if ( !entity._sign.hasAllOf( exclusionSign ) ) {
				registerEntity( entity );
			}
			return;
		}
		
		// Removed optional component can't decline the entity from matching to a family,
		// so just set the node property to null
		if ( node && optionalComponents && optionalComponents[component] ) {
			var property:String = optionalComponents[component];
			node[property] = null;
			return;
		}
		
		if ( node && propertyMap[component] ) {
			$removeAspectOf( entity );
		}
	}*/
	
	/**
	 * Creates new family's aspect for the matched entity
	 * createNode() should be called after verification of existence all required components in the entity.
	 * @param entity
	 */
	[Inline]
	private final function $createAspectOf( entity:Entity ):void {
		// Create new aspect node and assign components from the entity to the aspect variables
		//var aspect:Node = nodePool.get();
		var aspect:Aspect
		if ( poolHead ) {
			aspect = poolHead;
			poolHead = poolHead.next;
			aspect.cacheNext = null;
		} else {
			aspect = new mappingInfo.type();
		}
		aspect.entity = entity;
		
		for ( var i:int = 0; i < mappingInfo.interestCount; i++ ) {
			const componentClass:Class = mappingInfo.interests[i];
			const kindOfInterest:int = mappingInfo.interestKindMap[componentClass];
			const fieldName:String = mappingInfo.requiredMap[componentClass];
			if ( kindOfInterest != AspectInfo.EXCLUDED_KIND ) {
				aspect[fieldName] = entity.get( componentClass )
			}
			
			//var property:String = propertyMap[componentClass] || optionalComponents[componentClass];
			//aspect[property] = entity.get( componentClass );
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
	
	private function releaseCache():void {
		while ( disposeCacheHead ) {
			const aspect:Aspect = disposeCacheHead;
			disposeCacheHead = disposeCacheHead.cacheNext;
			
			aspect.cacheNext = null;
			$disposeAspect( aspect );
		}
	}
	
	private final function $disposeAspect( aspect:Aspect ):void {
		for ( var i:int = 0; i < mappingInfo.interestCount; i++ ) {
			const componentClass:Class = mappingInfo.interests[i];
			// TODO: resolve field names in optionalMap
			const fieldName:String = mappingInfo.requiredMap[componentClass];
			aspect[fieldName] = null;
		}
		
		aspect.entity = null;
		aspect.prev = null;
		aspect.next = null;
		
		aspect.cacheNext = poolHead;
		poolHead = aspect;
	}
}
}
