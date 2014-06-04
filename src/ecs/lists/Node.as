/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.lists {
import ecs.framework.api.ecs_core;

use namespace ecs_core;

public class Node {
	public var content:*;
	public var prev:Node;
	public var next:Node;

	/** A node id in the mapped list */
	ecs_core var id:uint;

	/** For ordered lists */
	ecs_core var order:int = 0;

	/** Is node added to a list and not removed */
	ecs_core var isAttached:Boolean = false;

	internal var prevInFactory:Node;

	public function Node( content:* = null ) {
		this.content = content;
	}
}
}
