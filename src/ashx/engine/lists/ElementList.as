/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.lists {
import ashx.engine.ecse;

import com.flashrush.utils.lists.core.LinkedNodeListBase;

public class ElementList extends ListBase {
	public function ElementList() {
	}
	
	[Inline]
	ecse final function get $firstNode():ItemNode {
		return _firstNode;
	}

	[Inline]
	ecse final function get $lastNode():ItemNode {
		return _lastNode;
	}
}
}
