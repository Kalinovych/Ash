/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.extensions.instanceManager {
import ecs.framework.api.ecsf;

import flash.utils.Dictionary;

use namespace ecsf;

public class InstanceManager {
	protected var list:BindingList = new BindingList();
	protected var bindingByType:Dictionary = new Dictionary();

	public function getInstancesOf( type:Class ):InstanceList {
		var node:BindingNode = bindingByType[type];
		if ( node ) {
			return node.instances;
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

	public function unobserve( type:Class ):void {
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
				if ( node.instances.list.add( instance ) ) {
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
				if ( node.instances.list.remove( instance ) ) {
					handleCount++;
				}
			}
		}
		return handleCount;
	}
}
}

import ecs.extensions.instanceManager.InstanceList;
import ecs.lists.ListBase;

class BindingNode {
	public var type:Class;
	public var instances:InstanceList = new InstanceList();

	public var prev:BindingNode;
	public var next:BindingNode;

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
		return $addNode( binding );
	}

	public function remove( binding:BindingNode ):BindingNode {
		return $removeNode( binding );
	}
}