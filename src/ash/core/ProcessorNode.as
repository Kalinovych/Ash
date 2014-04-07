/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.core {
internal class ProcessorNode {
	public var processor:*;
	public var priority:int = 0;
	
	public var prev:ProcessorNode;
	public var next:ProcessorNode;
}
}
