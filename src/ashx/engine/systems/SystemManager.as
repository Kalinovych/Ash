/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.systems {
import ashx.engine.ecse;
import ashx.engine.lists.Node;
import ashx.engine.threads.IProcessThread;
import ashx.engine.threads.IThreadManager;

import flash.utils.Dictionary;

use namespace ecse;

public class SystemManager implements IThreadManager, ISystemManager {
	protected var _systems:SystemList;
	protected var _systemsByProcess:Dictionary = new Dictionary();

	/** thread by process type */
	protected var threadMap:Dictionary = new Dictionary();

	public function SystemManager() {
		_systems = new SystemList();
	}

	public function add( system:*, order:int ):void {
		_systems.add( system, order );

		for ( var processType:Class in _systemsByProcess ) {
			var list:SystemList = _systemsByProcess[processType];
			list.add( system, order );
		}
	}

	public function remove( system:* ):void {
		_systems.remove( system );
		
		for ( var processType:Class in _systemsByProcess ) {
			var list:SystemList = _systemsByProcess[processType];
			list.remove( system );
		}
	}

	ecse function getProcessSystems( processType:Class ):SystemList {
		var list:SystemList = _systemsByProcess[processType];
		if ( !list ) {
			list = new SystemList();
			_systemsByProcess[processType] = list;
			for ( var node:Node = _systems.firstNode; node; node = node.next ) {
				list.add( node.content, node.order );
			}
		}
		return list;
	}

	public function update( deltaTime:Number ):void {
		for ( var slot:Node = _systems.firstNode; slot; slot = slot.next ) {
			slot.content.udpate( deltaTime );
		}
	}

	public function registerProcessThread( processType:Class, handler:IProcessThread ):void {
		threadMap[processType] = handler;
	}

	public function unregisterProcessThread( processType:Class ):void {
		delete threadMap[processType];
	}
}
}
