/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.threads {
import ashx.engine.systems.threads.*;
import ashx.engine.api.IUpdateProcess;
import ashx.engine.ecse;
import ashx.engine.lists.ItemNode;

use namespace ecse;

public class UpdateThread extends AbstractThread {
	
	public function update( deltaTime:Number ):void {
		for ( var node:ItemNode = processList.$firstNode; node; node = node.next ) {
			var process:IUpdateProcess = node.item;
			process.update( deltaTime );
		}
	}
	
}
}
