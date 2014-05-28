/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.extensions.instanceManager {

import ashx.engine.api.ecse;
import ashx.lists.LinkedSet;
import ashx.lists.Node;

use namespace ecse;

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
