/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems {
import flashrush.asentity.framework.systems.api.ISystem;

public class SystemNode {
	public var system:ISystem;
	public var order:int;
	
	public var prev:SystemNode;
	public var next:SystemNode;
}
}
