/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.utils {
import flash.utils.Dictionary;

public class ObjectIndexer {
	private var indexMap:Dictionary = new Dictionary();
	private var objectIndex:uint = 0;
	
	[Inline]
	public final function provide( object:* ):uint {
		var index:* = indexMap[object];
		if (index === undefined) {
			index = objectIndex;
			indexMap[object] = index;
			++objectIndex;
		}
		return index;
	}
}
}
