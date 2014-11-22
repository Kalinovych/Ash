/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flashrush.collections.LLNodeBase;

public class FamilyNode extends LLNodeBase {
	public var family:AspectFamily;
	
	public var prev:FamilyNode;
	public var next:FamilyNode;
}
}
