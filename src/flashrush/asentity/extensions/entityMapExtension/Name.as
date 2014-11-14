/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.entityMapExtension {
public class Name {
	private var _name:String;
	
	public function Name( name:String ) {
		_name = name;
	}

	public final function get name():String {
		return _name;
	}
}
}
