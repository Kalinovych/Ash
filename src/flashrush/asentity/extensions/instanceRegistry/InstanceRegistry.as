/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.instanceRegistry {
import flash.utils.Dictionary;

import flashrush.asentity.extensions.instanceRegistry.api.IInstanceRegistry;
import flashrush.asentity.framework.api.asentity;

use namespace asentity;

public class InstanceRegistry implements IInstanceRegistry {
	protected var families:FamilyList = new FamilyList();
	protected var familyByType:Dictionary = new Dictionary();

	public function getInstancesOf( type:Class ):InstanceList {
		var family:InstanceFamily = familyByType[type];
		if ( family ) {
			var wrapper:InstanceList = new InstanceList();
			wrapper.type = family.type;
			wrapper.list = family.instances;
			wrapper.registry = this;
			family.referenceCount++;
			return wrapper;
		}
		return null;
	}

	/**
	 * Sets the InstanceManager to recognize all instances of the required type
	 * and collect them into a single InstanceList.
	 *
	 * @param type Interface, Class or super Class of instances to collect
	 */
	public function observe( type:Class ):void {
		var family:InstanceFamily = familyByType[type];
		if ( !family ) {
			family = new InstanceFamily();
			families.add( family );
			familyByType[type] = family;
		}
	}

	public function unObserve( type:Class ):void {
		var family:InstanceFamily = familyByType[type];
		if ( family ) {
			delete familyByType[type];
			families.remove( family );
			family.dispose();
		}
	}

	public function handleAdded( instance:* ):uint {
		var handleCount:uint = 0;
		var family:InstanceFamily = families.first;
		while ( family ) {
			if ( instance is family.type ) {
				if ( family.instances.add( instance ) ) {
					handleCount++;
				}
			}
		}
		return handleCount;
	}

	public function handleRemoved( instance:* ):uint {
		var handleCount:uint = 0;
		var family:InstanceFamily = families.first;
		while ( family ) {
			if ( instance is family.type ) {
				if ( family.instances.remove( instance ) ) {
					handleCount--;
				}
			}
		}
		return handleCount;
	}

	public function referenceDisposed( ref:InstanceList ):void {
		// TODO: refCount--
		var family:InstanceFamily = familyByType[ref.type];
		family.referenceCount--;
		ref.type = null;
		ref.list = null;
		ref.registry = null;
	}
}
}

import flashrush.asentity.extensions.instanceRegistry.InstanceList;
import flashrush.ds.LinkedSet;
import flashrush.ds.ListBase;

class InstanceFamily {
	public var type:Class;
	public var instances:LinkedSet = new LinkedSet();
	//public var instances:InstanceList = new InstanceList();
	public var referenceCount:int = 0;

	public var noReferencesCallback:Function;

	public var prev:InstanceFamily;
	public var next:InstanceFamily;

	public function getReference():InstanceList {
		// TODO: implement getReference here
		referenceCount++;
		var ref:InstanceList = new InstanceList();
		return ref;
	}

	public function disposeReference( ref:InstanceList ):void {
		// TODO: implement disposeReference here

		if ( referenceCount == 0 && noReferencesCallback != null ) {
			noReferencesCallback( this );
		}
	}

	public function dispose():void {
		type = null;
		instances = null;
		prev = null;
		next = null;
	}
}

class FamilyList extends ListBase {

	public function get first():InstanceFamily {
		return _firstNode;
	}

	public function get last():InstanceFamily {
		return _lastNode;
	}

	public function add( family:InstanceFamily ):InstanceFamily {
		return $attach( family );
	}

	public function remove( family:InstanceFamily ):InstanceFamily {
		return $detach( family );
	}
}