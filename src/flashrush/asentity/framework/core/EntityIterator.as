/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.core {
import flashrush.asentity.framework.entity.Entity;

public class EntityIterator {
	private var _source:EntityLinker;
	
	public function EntityIterator( source:EntityLinker ) {
		_source = source;
	}
	
	public final function get first():Entity {
		return _source.first;
	}
	
	public final function get last():Entity {
		return _source.last;
	}
	
	public final function length():uint {
		return _source.length;
	}
}
}
