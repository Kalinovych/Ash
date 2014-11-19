/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flashrush.collections.LLNodeBase;

public class FamilyNode extends LLNodeBase {
	//protected namespace base = list_internal;
	
	public var prev:FamilyNode;
	public var next:FamilyNode;
	
	private var _family:AspectFamily;
	
	public function get family():AspectFamily {
		trace( "[FamilyNode] [get family]›", _family );
		return _family;
	}
	
	public function set family( value:AspectFamily ):void {
		trace( "[FamilyNode] [set family]›", value );
		_family = value;
	}
}
}
