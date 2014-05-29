/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.threads {
import ecs.framework.api.ecsf;
import ecs.engine.processes.IProcess;
import ecs.lists.LinkedSet;
import ecs.lists.Node;

use namespace ecsf;

public class AbstractThread implements IProcessThread {
	protected var processList:LinkedSet = new LinkedSet();

	[Inline]
	protected final function $forEach( callback:Function ):void {
		for ( var node:Node = processList.$firstNode; node; node = node.next ) {
			callback( node.content );
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
