/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.extensions.instanceRegistry {

import ecs.framework.api.ecs_core;
import ecs.lists.LinkedSet;
import ecs.lists.Node;

use namespace ecs_core;

/**
 * TODO: make this class as access interface to the list and count such references to the list
 */
public class InstanceList {
	internal var type:Class;
	internal var list:LinkedSet;// = new LinkedSet();
	internal var registry:InstanceRegistry;

	public final function get firstNode():Node {
		return list.$firstNode;
	}

	public final function get lastNode():Node {
		return list.$lastNode;
	}

	public final function get length():uint {
		return list.$length;
	}

	public function InstanceList() {}

	public function dispose():void {
		registry.referenceDisposed( this );
	}
}
}
