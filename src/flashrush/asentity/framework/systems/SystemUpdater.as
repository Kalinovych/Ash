/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems {
import flashrush.asentity.framework.systems.api.IUpdatable;

public class SystemUpdater {
	private var _updatables:SystemList;
	
	public function SystemUpdater() {
	}
	
	public function update( time:Number ):void {
		var node:SystemNode = _updatables.firstNode;
		while ( node ) {
			node.system.update( time );
		}
	}
	
	public function add( system:IUpdatable ):void {
		
	}
}
}
