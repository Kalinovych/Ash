/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.aspects {
import ash.core.Entity;
import ash.core.NodeList;
import ash.engine.components.IComponentObserver;
import ash.engine.entity.IEntityObserver;
import ash.engine.lists.LinkedHashMap;

/**
 * A layer between engine and Aspect Observers.
 * Observe for added/removed entities and notify aspect observers.
 * 
 */
public class AspectsManager implements IComponentObserver, IEntityObserver {

	private var aspectObservers:LinkedHashMap = new LinkedHashMap();

	public function AspectsManager() {
	}

	public function onEntityAdded( entity:Entity ):void {
		for each( var aspect:AspectObserver in aspectObservers ) {
			if ( entityHasAspect( entity, aspect ) ) {
				aspect.onAspectEntityAdded( entity );
			}
		}
	}

	public function onEntityRemoved( entity:Entity ):void {
	}

	public function onComponentAdded( entity:Entity, component:*, componentType:* ):void {
	}

	public function onComponentRemoved( entity:Entity, component:*, componentType:* ):void {
	}

	public function getNodeList( nodeClass:Class ):NodeList {
		var observer:AspectObserver = aspectObservers.get( nodeClass );
		if ( !observer ) {
			observer = _createAspectObserver( nodeClass );
		}
		return observer.nodeList;
		//return ( familyMap[nodeClass] || inline_createFamily( nodeClass ) ).nodeList;
	}

	[Inline]
	protected final function _createAspectObserver( nodeClass:Class ):AspectObserver {
		var observer:AspectObserver = new AspectObserver( nodeClass );
		/*var family:Family = familyMap[nodeClass] = new Family( nodeClass, this );
		family.sign = signManager.signKeys( family.propertyMap );
		if ( family.excludedComponents ) {
			family.exclusionSign = signManager.signKeys( family.excludedComponents );
		}

		// find all entities matching to the new family
		for ( var entity:Entity = entityList.head; entity; entity = entity.next ) {
			if ( entityBelongToFamily( entity, family ) ) {
				family.addEntity( entity );
			}
		}

		// subscribe for handling added/removed components interested in
		for each( var componentClass:Class in family.componentInterests ) {
			var familyList:Vector.<Family> = familiesByComponent[componentClass] ||= new Vector.<Family>();
			familyList[familyList.length] = family;
		}

		return family;*/
	}

	[Inline]
	protected final function entityHasAspect( entity:Entity, aspect:AspectObserver ):Boolean {
		//return ( entity.sign.contains( family.sign ) && !( family.exclusionSign && entity.sign.contains( family.exclusionSign ) ) );
	}

}
}
