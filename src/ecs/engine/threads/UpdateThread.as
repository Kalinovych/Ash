/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.threads {
import ecs.engine.processes.api.IUpdateable;

import flashrush.asentity.framework.api.asentity;

use namespace asentity;

public class UpdateThread extends AbstractThread {
	
	public function process( deltaTime:Number ):void {
		for ( var node:Node = processList.$firstNode; node; node = node.next ) {
			var process:IUpdateable = node.item;
			process.update( deltaTime );
		}
	}

}
}
