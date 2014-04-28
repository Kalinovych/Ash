/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.lists {
public class AnyElementIterator extends ElementIteratorBase {

	public function AnyElementIterator( elements:ElementList ) {
		super( elements );
	}

	[Inline]
	public final function get current():* {
		return _current;
	}

	public function next():* {
		return _next();
	}

	public function first():* {
		return _first();
	}

	public function last():* {
		return _last();
	}
}
}
