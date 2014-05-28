/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.lists {
import ashx.engine.api.ecse;

use namespace ecse;

public class Node {
	public var content:*;
	public var prev:Node;
	public var next:Node;

	/** Is node added to a list and not removed */
	ecse var isAttached:Boolean = false;

	/** A node id in the mapped list */
	ecse var id:uint;

	/** For ordered lists */
	ecse var order:int = 0;

	internal var prevInFactory:Node;

	public function Node( content:* = null ) {
		this.content = content;
	}
}
}
