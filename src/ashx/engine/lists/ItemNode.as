/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.lists {
import ashx.engine.ecse;

use namespace ecse;

public class ItemNode {
	public var item:*;
	public var prev:ItemNode;
	public var next:ItemNode;
	
	/** Is node added to a list and not removed */
	ecse var isAttached:Boolean = false;
	
	/** A node id in the mapped list */
	ecse var id:uint;
	
	/** For prioritised lists */
	ecse var priority:int = 0;
	
	internal var prevInFactory:ItemNode;
	
	public function ItemNode( item:* = null ) {
		this.item = item;
	}
}
}
