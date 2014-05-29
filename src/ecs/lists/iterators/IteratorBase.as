/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.lists.iterators {
import ecs.framework.api.ecsf;
import ecs.lists.ListBase;

use namespace ecsf;

public class IteratorBase {
	protected var _list:ListBase;

	public function IteratorBase( list:ListBase ) {
		this._list = list;
	}

	ecsf function get list():ListBase {
		return _list;
	}

	ecsf function set list( value:ListBase ):void {
		_list = value;
	}

}
}
