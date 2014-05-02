/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.aspects {
import ashx.engine.api.IAspectManager;
import ashx.engine.components.IComponentObserver;
import ashx.engine.ecse;
import ashx.engine.entity.Entity;
import ashx.engine.entity.EntityList;
import ashx.engine.entity.IEntityHandler;
import ashx.engine.lists.ItemNode;
import ashx.engine.lists.LinkedHashMap;

import com.flashrush.signatures.BitSignManager;

use namespace ecse;

public class AspectsManager implements IAspectManager, IEntityHandler {
	private var entities:EntityList;
	private var componentObserver:IComponentObserver;
	private var signManager:BitSignManager;
	private var matchers:LinkedHashMap/*<NodeClass, AspectMatcher>*/ = new LinkedHashMap();

	public function AspectsManager( entities:EntityList, componentObserver:IComponentObserver ) {
		this.entities = entities;
		this.componentObserver = componentObserver;
		signManager = new BitSignManager();
		
		entities.addHandler( this );
	}

	public function getAspects( familyIdentifier:Class ):AspectList {
		var matcher:AspectMatcher = matchers.get( familyIdentifier );
		if ( !matcher ) {
			matcher = createMatcher( familyIdentifier );
			matchers.set( familyIdentifier, matcher );
		}
		return matcher.nodeList;
	}
	
	/** @private **/
	public function onEntityAdded( entity:Entity ):void {
		trace("[AspectsManager.onEntityAdded]›", entity);
		entity.sign = signManager.signKeys( entity.components );
		for ( var node:ItemNode = matchers.$firstNode; node; node = node.next ) {
			var matcher:AspectMatcher = node.item;
			if ( _entityMatchAspect( entity, matcher ) ) {
				matcher.addMatchedEntity( entity );
			}
		}
	}
	
	/** @private **/
	public function onEntityRemoved( entity:Entity ):void {
		for ( var node:ItemNode = matchers.$firstNode; node; node = node.next ) {
			var matcher:AspectMatcher = node.item;
			if ( _entityMatchAspect( entity, matcher ) ) {
				matcher.removeMatchedEntity( entity );
			}
		}

		signManager.recycleSign( entity.sign );
		entity.sign = null;
	}

	/** @private **/
	protected final function createMatcher( nodeClass:Class ):AspectMatcher {
		var matcher:AspectMatcher = new AspectMatcher( nodeClass );
		matcher.sign = signManager.signKeys( matcher.propertyMap );
		if ( matcher.excludedComponents ) {
			matcher.exclusionSign = signManager.signKeys( matcher.excludedComponents );
		}

		// check all entities that are already in the list
		for ( var entity:Entity = entities.first; entity; entity = entity.next ) {
			if ( _entityMatchAspect( entity, matcher ) ) {
				matcher.addMatchedEntity( entity );
			}
		}

		// add matcher as observer of each component in the node
		var interests:Vector.<Class> = matcher.componentInterests;
		for ( var i:int = 0, len:int = interests.length; i < len; i++ ) {
			var componentClass:Class = interests[i];
			componentObserver.addHandler( componentClass, matcher );
		}

		return matcher;
	}

	[Inline]
	protected final function _entityMatchAspect( entity:Entity, aspect:AspectMatcher ):Boolean {
		return ( entity.sign.contains( aspect.sign ) && !( aspect.exclusionSign && entity.sign.contains( aspect.exclusionSign ) ) );
	}
}
}
