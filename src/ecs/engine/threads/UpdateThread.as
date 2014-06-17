/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.threads {
import ecs.framework.api.ecs_core;
import ecs.engine.processes.api.IUpdateProcess;
import ecs.lists.Node;

use namespace ecs_core;

public class UpdateThread extends AbstractThread {
	
	public function process( deltaTime:Number ):void {
		for ( var node:Node = processList.$firstNode; node; node = node.next ) {
			var process:IUpdateProcess = node.content;
			process.update( deltaTime );
		}
	}

}
}
