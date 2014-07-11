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
	protected var list:BindingList = new BindingList();
	protected var bindingByType:Dictionary = new Dictionary();

	public function getInstancesOf( type:Class ):InstanceList {
		var node:BindingNode = bindingByType[type];
		if ( node ) {
			var wrapper:InstanceList = new InstanceList();
			wrapper.type = node.type;
			wrapper.list = node.instances;
			wrapper.registry = this;
			node.referenceCount++;
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
		var node:BindingNode = bindingByType[type];
		if ( !node ) {
			node = new BindingNode();
			bindingByType[type] = node;
			list.add( node );
		}
	}

	public function unObserve( type:Class ):void {
		var node:BindingNode = bindingByType[type];
		if ( node ) {
			delete bindingByType[type];
			list.remove( node );
			node.dispose();
		}
	}

	public function handleAdded( instance:* ):uint {
		var handleCount:uint = 0;
		var node:BindingNode = list.first;
		while ( node ) {
			if ( instance is node.type ) {
				if ( node.instances.add( instance ) ) {
					handleCount++;
				}
			}
		}
		return handleCount;
	}

	public function handleRemoved( instance:* ):uint {
		var handleCount:uint = 0;
		var node:BindingNode = list.first;
		while ( node ) {
			if ( instance is node.type ) {
				if ( node.instances.remove( instance ) ) {
					handleCount--;
				}
			}
		}
		return handleCount;
	}

	public function referenceDisposed( ref:InstanceList ):void {
		// TODO: refCount--
		var node:BindingNode = bindingByType[ref.type];
		node.referenceCount--;
		ref.type = null;
		ref.list = null;
		ref.registry = null;
	}
}
}

import flashrush.asentity.extensions.instanceRegistry.InstanceList;
import flashrush.gdf.ds.LinkedSet;
import flashrush.gdf.ds.ListBase;

class BindingNode {
	public var type:Class;
	public var instances:LinkedSet = new LinkedSet();
	//public var instances:InstanceList = new InstanceList();
	public var referenceCount:int = 0;

	public var noReferencesCallback:Function;

	public var prev:BindingNode;
	public var next:BindingNode;

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

class BindingList extends ListBase {

	public function get first():BindingNode {
		return _firstNode;
	}

	public function get last():BindingNode {
		return _lastNode;
	}

	public function add( binding:BindingNode ):BindingNode {
		return $attach( binding );
	}

	public function remove( binding:BindingNode ):BindingNode {
		return $detach( binding );
	}
}