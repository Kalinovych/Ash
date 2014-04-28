/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.collections {

/**
 * @private
 */
internal class HandlerNode {
	public var handler:*;
	public var priority:int = 0;
	
	public var prev:HandlerNode;
	public var next:HandlerNode;
}
}
