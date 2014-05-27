/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.threads {
import ashx.engine.api.IProcess;
import ashx.engine.ecse;
import ashx.engine.lists.Node;
import ashx.engine.lists.LinkedSet;

use namespace ecse;

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
