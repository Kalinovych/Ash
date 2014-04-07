/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.lists {
public class ItemNode {
	public var item:*;
	public var prev:ItemNode;
	public var next:ItemNode;
	
	public function ItemNode( item:* = null ) {
		this.item = item;
	}
}
}
