/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.lists.iterators {
import ecs.framework.api.ecs_core;
import ecs.lists.ListBase;

use namespace ecs_core;

public class IteratorBase {
	protected var _list:ListBase;

	public function IteratorBase( list:ListBase ) {
		this._list = list;
	}

	ecs_core function get list():ListBase {
		return _list;
	}

	ecs_core function set list( value:ListBase ):void {
		_list = value;
	}

}
}
