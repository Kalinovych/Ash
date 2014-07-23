/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.threads {
import ecs.engine.processes.api.IProcess;

import flashrush.asentity.framework.api.asentity;
import flashrush.ds.LinkedSet;
import flashrush.ds.Node;
import flashrush.ds.ds_internal;

use namespace asentity;

public class AbstractThread implements IProcessThread {
	protected var processList:LinkedSet = new LinkedSet();

	[Inline]
	protected final function $forEach( callback:Function ):void {
		for ( var node:Node = processList.firstNode; node; node = node.ds_internal::_next ) {
			callback( node.ds_internal::_item );
		}
	}

	public function processAdded( process:IProcess ):void {
		processList.add( process );
	}

	public function processRemoved( process:IProcess ):void {
		processList.remove( process );
	}
	
}
}
