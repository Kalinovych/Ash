/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.lists {
import ashx.engine.api.ecse;

use namespace ecse;

public class ItemNodeFactory {
	private var head:Node;
	private var growthValue:uint = 1;
	private var _createdCount:uint = 0;
	private var _availableCount:uint = 0;

	public function ItemNodeFactory( preAllocate:uint = 0, growthValue:uint = 1 ) {
		this.growthValue = growthValue || 1;
		if ( preAllocate ) {
			allocate( preAllocate );
		}
	}

	public function get():Node {
		if ( !head ) {
			allocate( growthValue );
		}
		var node:Node = head;
		head = node.prevInFactory;
		node.prevInFactory = null;
		--_availableCount;
		return node;
	}

	public function recycle( node:Node ):void {
		node.prevInFactory = head;
		head = node;
		++_availableCount;
	}

	public function clearPool():void {
		while ( head ) {
			var prev:Node = head.prevInFactory;
			head.prevInFactory = null;
			head = prev;
		}
		_createdCount = 0;
		_availableCount = 0;
	}

	public function allocate( count:uint ):void {
		while ( count ) {
			--count;
			var node:Node = new Node();
			node.prevInFactory = head;
			head = node;
			++_createdCount;
			++_availableCount;
		}
	}

	public function get createdCount():uint {
		return _createdCount;
	}

	public function get availableCount():uint {
		return _availableCount;
	}
}
}
