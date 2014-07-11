/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems {
public class SystemNode {
	public var system:*;
	public var prev:SystemNode;
	public var next:SystemNode;
	public var order:SystemNode;
}
}
