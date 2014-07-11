/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.gdf.ds {
import flashrush.gdf.api.gdf_core;
import flashrush.gdf.ds.InternalList;
import flashrush.gdf.ds.Node;

use namespace gdf_core;

/**
 * Node content iterator
 */
public class ItemIterator {
	gdf_core var list:InternalList;
	gdf_core var currentNode:Node;
	gdf_core var currentItem:*;

	public function ItemIterator( list:InternalList ) {
		this.list = list;
	}

	[Inline]
	public final function get current():* {
		return currentItem;
	}

	public function next():* {
		currentNode = ( currentNode ? currentNode.next : list.$firstNode );
		currentItem = ( currentNode ? currentNode.item : null );
		return currentItem;
	}

	public function first():* {
		currentNode = list.$firstNode;
		currentItem = ( currentNode ? currentNode.item : null );
		return currentItem;
	}

	public function last():* {
		currentNode = list.$lastNode;
		currentItem = ( currentNode ? currentNode.item : null );
		return currentItem;
	}

	public function dispose():void {
		list = null;
		currentNode = null;
		currentItem = null;
	}
}
}
