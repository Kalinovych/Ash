/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.lists {
public class AnyElementIterator extends ElementIteratorBase {

	public function AnyElementIterator( elements:ItemList ) {
		super( elements );
	}

	[Inline]
	public final function get current():* {
		return _current;
	}

	public function next():* {
		return $next();
	}

	public function first():* {
		return $first();
	}

	public function last():* {
		return $last();
	}
}
}
