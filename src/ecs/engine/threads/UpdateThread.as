/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.threads {
import ecs.framework.api.ecsf;
import ecs.engine.processes.IUpdateProcess;
import ecs.lists.Node;

use namespace ecsf;

public class UpdateThread extends AbstractThread {

	public function update( deltaTime:Number ):void {
		for ( var node:Node = processList.$firstNode; node; node = node.next ) {
			var process:IUpdateProcess = node.content;
			process.update( deltaTime );
		}
	}

}
}
