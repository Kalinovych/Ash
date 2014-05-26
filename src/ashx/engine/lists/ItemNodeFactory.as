/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.lists {
import ashx.engine.ecse;

use namespace ecse;

public class ItemNodeFactory {
	private var last:ItemNode;
	private var _createdCount:uint = 0;
	private var _availableCount:uint = 0;

	public function ItemNodeFactory( initialAllocate:uint = 0) {
		if (initialAllocate) {
			allocate( initialAllocate );
		}
	}

	public function allocate( count:uint ):void {
		while ( count ) {
			--count;
			var node:ItemNode = new ItemNode();
			node.prevInFactory = last;
			last = node;
			++_createdCount;
			++_availableCount;
		}
	}

	public function get():ItemNode {
		var node:ItemNode = last;
		if ( node ) {
			last = node.prevInFactory;
			node.prevInFactory = null;
			--_availableCount;
		} else {
			node = new ItemNode();
			++_createdCount;
		}
		return node;
	}

	public function recycle( node:ItemNode ):void {
		node.prevInFactory = last;
		last = node;
		++_availableCount;
	}

	public function clearPool():void {
		while ( last ) {
			var prev:ItemNode = last.prevInFactory;
			last.prevInFactory = null;
			last = prev;
		}
		_createdCount = 0;
		_availableCount = 0;
	}

	public function get createdCount():uint {
		return _createdCount;
	}

	public function get availableCount():uint {
		return _availableCount;
	}
}
}
