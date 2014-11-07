/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flashrush.asentity.extensions.ECSigner;
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.core.ProcessingLock;
import flashrush.asentity.framework.entity.Entity;
import flashrush.asentity.framework.entity.EntityCollection;
import flashrush.asentity.framework.entity.api.IEntityHandler;
import flashrush.collections.LLNode;
import flashrush.collections.LinkedMap;
import flashrush.collections.cl_internal;
import flashrush.gdf.api.gdf_core;
import flashrush.signatures.api.ISignature;

use namespace cl_internal;

use namespace asentity;
use namespace gdf_core;

public class AspectManager implements IAspectManager, IEntityHandler {
	private var entities:EntityCollection;
	private var processingLock:ProcessingLock;
	//private var componentManager:IComponentObserver;
	private var mappers:LinkedMap/*<NodeClass, AspectObserver>*/ = new LinkedMap();
	private var _signer:ECSigner;
	//private var signTable:Vector.<ISignature>;
	
	public function AspectManager( entities:*, processingLock:ProcessingLock ) {
		this.entities = entities;
		this.processingLock = processingLock;
		//this.componentManager = componentManager;
		
		_signer = new ECSigner();
		//signTable = new Vector.<ISignature>( entities.entityCount );
		
		entities.registerHandler( _signer );
		entities.registerHandler( this );
	}
	
	public function getAspects( aspectDefinition:Class ):AspectList {
		var mapper:AspectMapper = mappers.get( aspectDefinition );
		if ( !mapper ) {
			mapper = createMapper( aspectDefinition );
			mappers.put( aspectDefinition, mapper );
		}
		return mapper.aspects;
	}
	
	/** @private **/
	public function handleEntityAdded( entity:Entity ):void {
		trace( "[AspectsManager.onEntityAdded]›", entity );
		//entity.sign = _signer.signKeys( entity.components );
		
		var id:uint = entity._id;
		/*if ( signTable.length <= id ) {
			signTable.length = id + 1;
		}
		var sign:ISignature = _signer.signKeys( entity._components );
		signTable[id] = sign;*/
		
		for ( var node:LLNode = mappers.firstNode; node; node = node.nextNode ) {
			var observer:AspectMapper = node.item;
			if ( $signMatchesAspect( entity._sign, observer ) ) {
				observer.registerEntity( entity );
			}
		}
	}
	
	/** @private **/
	public function handleEntityRemoved( entity:Entity ):void {
		//var sign:ISignature = signTable[entity._id];
		var sign:ISignature = entity._sign;
		for ( var node:LLNode = mappers.firstNode; node; node = node.cl_internal::next ) {
			var observer:AspectMapper = node.item;
			if ( $signMatchesAspect( sign, observer ) ) {
				observer.unRegisterEntity( entity );
			}
		}
		//_signer.disposeSign( sign );
		//entity._sign = null;
	}
	
	//-------------------------------------------
	// Protected methods
	//-------------------------------------------
	
	/** @private **/
	protected final function createMapper( aspectDefinition:Class ):AspectMapper {
		const aspectInfo:AspectInfo = AspectUtil.getInfo( aspectDefinition );
		const mapper:AspectMapper = new AspectMapper( aspectInfo, processingLock );
		
		mapper.sign = _signer.signer.signKeys( aspectInfo.requiredMap );
		
		if ( aspectInfo.excludedMap ) {
			mapper.exclusionSign = _signer.signer.signKeys( aspectInfo.excludedMap );
		}
		
		// check all entities that are already in the list
		for ( var entity:Entity = entities.first; entity; entity = entity.next ) {
			//var sign:ISignature = signTable[entity._id];
			var sign:ISignature = entity._sign;
			if ( $signMatchesAspect( sign, mapper ) ) {
				mapper.registerEntity( entity );
			}
		}
		
		// register the mapper as handler of each interested component
		for ( var i:int = 0; i < aspectInfo.interestCount; i++ ) {
			var componentClass:Class = aspectInfo.interests[i];
			// TODO: impl it without componentManager
			//componentManager.registerHandler( componentClass, mapper );
		}
		
		return mapper;
	}
	
	[Inline]
	protected final function $signMatchesAspect( sign:ISignature, aspect:AspectMapper ):Boolean {
		return ( sign.hasAllOf( aspect.sign ) && !( aspect.exclusionSign && sign.hasAllOf( aspect.exclusionSign ) ) );
		//return ( entity.sign.contains( aspect.sign ) && !( aspect.exclusionSign && entity.sign.contains( aspect.exclusionSign ) ) );
	}
}
}
