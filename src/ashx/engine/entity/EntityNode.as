/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.entity {
import ashx.engine.entity.Entity;

public class EntityNode {
	public var entity:Entity;
	
	public var prev:*; //<EntityNode>
	
	public var next:*; //<EntityNode>
}
}
