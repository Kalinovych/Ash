/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.threads {
import ashx.engine.api.IUpdateProcess;
import ashx.engine.ecse;
import ashx.engine.lists.Node;

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
