/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.extensions.instanceManager {

import ecs.framework.api.ecs_core;
import ecs.lists.LinkedSet;
import ecs.lists.Node;

use namespace ecs_core;

public class InstanceList {
	internal var list:LinkedSet = new LinkedSet();
	
	public final function get firstNode():Node {
		return list.$firstNode;
	}

	public final function get lastNode():Node {
		return list.$lastNode;
	}

	public final function get length():uint {
		return list.$length;
	}
}
}
