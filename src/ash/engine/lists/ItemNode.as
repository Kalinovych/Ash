/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.lists {
public class ItemNode {
	public var item:*;
	public var prev:ItemNode;
	public var next:ItemNode;
	/** Is node added to a list and not removed */
	public var isAttached:Boolean = false;
	/** A node id in the mapped list */
	public var id:uint;
	
	public function ItemNode( item:* = null ) {
		this.item = item;
	}
}
}
