/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.aspects {
import ashx.engine.entity.Entity;

public class Aspect {
	public var entity:Entity;

	public var prev:*; //<AspectNode>

	public var next:*; //<AspectNode>
}
}
