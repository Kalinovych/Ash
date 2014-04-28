/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.lists {
public class ItemNode {
	public var item:*;
	public var prev:ItemNode;
	public var next:ItemNode;
	
	/** Is node added to a list and not removed */
	public var isAttached:Boolean = false;
	/** A node id in the mapped list */
	public var id:uint;
	/** For prioritised lists */
	public var priority:int = 0;

	public function ItemNode( item:* = null ) {
		this.item = item;
	}
}
}
