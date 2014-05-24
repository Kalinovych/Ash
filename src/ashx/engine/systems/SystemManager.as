/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.systems {
import ashx.engine.lists.ItemNode;
import ashx.engine.threads.IProcessThread;
import ashx.engine.threads.IThreadManager;

import flash.utils.Dictionary;

public class SystemManager implements IThreadManager, ISystemManager {
	protected var _list:SystemList;

	/** thread by process type */
	protected var threadMap:Dictionary = new Dictionary();

	public function SystemManager() {
		_list = new SystemList();
	}

	public function add( system:*, order:int ):void {
		_list.add( system, order );
	}

	public function remove( system:* ):void {
		_list.remove( system );
	}

	public function update( deltaTime:Number ):void {
		for ( var slot:ItemNode = _list.first; slot; slot = slot.next ) {
			slot.item.udpate( deltaTime );
		}
	}

	public function registerProcessThread( process:Class, handler:IProcessThread ):void {
		threadMap[process] = handler;
	}

	public function unregisterProcessThread( process:Class ):void {
		delete threadMap[process];
	}
}
}
