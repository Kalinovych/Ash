/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */

package flashrush.gdf.ds {
import flashrush.gdf.api.gdf_core;

use namespace gdf_core;

public class Iterator {
	gdf_core var _factory:*;

	protected var _list:InternalList;
	protected var _node:Node = undefined;
	protected var _item:* = undefined;
	//protected var _nextNode:Node;

	public function Iterator( list:InternalList ) {
		_list = list;
	}

	/**
	 * Return a content of the current node
	 */
	[Inline]
	public final function get current():* {
		return _item;
	}


	/*
	TODO: What to do if withing iteration loop, current and next nodes will be removed by third party?
	 */

	public function pickNext():Boolean {
		var next:Node = (_node && _node.next ? _node.next : ( _node === undefined ? _list.$firstNode : null ) );
		if ( next ) {
			_node = next;
			_item = _node.item;
			return true;
		}
		return false;
	}

	public function reset():void {
		_node = null;
		_item = undefined;
	}

	public function dispose():void {
		_list = null;
		_node = null;
		_item = null;
		//_nextNode = null;

		_factory && _factory.recycle( this );
	}
}
}
