/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.entity {
import ash.core.Entity;
import ash.engine.lists.ElementIteratorBase;
import ash.engine.lists.ElementList;

public class EntityIterator extends ElementIteratorBase {

	public function EntityIterator( entities:ElementList ) {
		super( entities );
	}

	[Inline]
	public final function get current():Entity {
		return _current;
	}

	public function next():Entity {
		return _next();
	}

	public function first():Entity {
		return _first();
	}

	public function last():Entity {
		return _last();
	}
}
}
