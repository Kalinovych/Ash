/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.lists.iterators {
import ashx.engine.api.ecse;
import ashx.lists.ListBase;

use namespace ecse;

public class IteratorBase {
	protected var _list:ListBase;

	public function IteratorBase( list:ListBase ) {
		this._list = list;
	}

	ecse function get list():ListBase {
		return _list;
	}

	ecse function set list( value:ListBase ):void {
		_list = value;
	}

}
}
