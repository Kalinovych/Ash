/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.framework.threads {
import ashx.engine.api.ecse;
import ashx.framework.processes.IUpdateProcess;
import ashx.lists.Node;

use namespace ecse;

public class UpdateThread extends AbstractThread {

	public function update( deltaTime:Number ):void {
		for ( var node:Node = processList.$firstNode; node; node = node.next ) {
			var process:IUpdateProcess = node.content;
			process.update( deltaTime );
		}
	}

}
}
