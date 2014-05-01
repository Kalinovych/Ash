/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.entity {
import ashx.engine.lists.ElementIteratorBase;
import ashx.engine.lists.ElementList;

public class EntityNodeListIterator extends ElementIteratorBase {

	public function EntityNodeListIterator( entities:ElementList ) {
		super( entities );
	}

	[Inline]
	public final function get current():Entity {
		return _current;
	}

	public function next():Entity {
		return $next();
	}

	public function first():Entity {
		return $first();
	}

	public function last():Entity {
		return $last();
	}
}
}
