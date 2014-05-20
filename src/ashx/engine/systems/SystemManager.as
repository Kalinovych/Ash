/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.systems {
import ashx.engine.lists.ItemNode;

public class SystemManager {
	protected var _list:SystemList;

	public function SystemManager() {
		_list = new SystemList();
	}

	public function add( system:ESystem, order:int ):void {
		_list.add( system, order );
	}

	public function remove( system:ESystem ):void {
		_list.removeSystem( system );
	}

	public function update( deltaTime:Number ):void {
		for ( var slot:ItemNode = _list.first; slot; slot = slot.next ) {
			slot.item.udpate( deltaTime );
		}
	}
}
}
