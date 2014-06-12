/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.extensions.entityNames {
public class Name {
	private var _name:String;
	
	public function Name( name:String ) {
		_name = name;
	}

	public function get name():String {
		return _name;
	}
}
}
