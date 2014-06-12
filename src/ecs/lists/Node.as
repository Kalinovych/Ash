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

	/** For ordered lists */
	ecs_core var order:int;

	/** Node currently attached a list */
	ecs_core var isAttached:Boolean;

	internal var prevInFactory:Node;

	public function Node( content:* = null ) {
		this.content = content;
	}
}
}
