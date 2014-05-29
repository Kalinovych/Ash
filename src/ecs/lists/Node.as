/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.lists {
import ecs.framework.api.ecsf;

use namespace ecsf;

public class Node {
	public var content:*;
	public var prev:Node;
	public var next:Node;

	/** A node id in the mapped list */
	ecsf var id:uint;

	/** For ordered lists */
	ecsf var order:int = 0;

	/** Is node added to a list and not removed */
	ecsf var isAttached:Boolean = false;

	internal var prevInFactory:Node;

	public function Node( content:* = null ) {
		this.content = content;
	}
}
}
