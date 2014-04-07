/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.lists {
import flash.utils.Dictionary;

public class ElementSet {
	private var registry:Dictionary = new Dictionary();
	
	public function ElementSet() {
	}
	
	public function add( element: * ):Boolean {
		if (registry[element]) {
			return false;
		}
		
		registry[element] = true;
	}
}
}
