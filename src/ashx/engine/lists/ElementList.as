/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.lists {
import ashx.engine.ecse;

import com.flashrush.utils.lists.core.LinkedNodeListBase;

public class ElementList extends LinkedNodeListBase {
	public function ElementList() {
	}

	/*[Inline]
	public final function get firstNode():ItemNode {
		return _first;
	}

	[Inline]
	public final function get lastNode():ItemNode {
		return _last;
	}*/

	[Inline]
	ecse final function get _firstNode():ItemNode {
		return _first;
	}

	[Inline]
	ecse final function get _lastNode():ItemNode {
		return _last;
	}
}
}
