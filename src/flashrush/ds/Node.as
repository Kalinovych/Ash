/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.ds {

use namespace ds_internal;

public class Node {
	ds_internal var _item:*;
	ds_internal var _prev:Node;
	ds_internal var _next:Node;
	ds_internal var _order:int;

	/** For a pool and other transitional queues */
	internal var anchor:Node;

	public function Node( item:* = null ) {
		_item = item;
	}

	[Inline]
	public final function get item():* {
		return _item;
	}

	[Inline]
	public final function get prev():Node {
		return _prev;
	}

	[Inline]
	public final function get next():Node {
		return _next;
	}

	[Inline]
	public final function get order():* {
		return _order;
	}

}
}
