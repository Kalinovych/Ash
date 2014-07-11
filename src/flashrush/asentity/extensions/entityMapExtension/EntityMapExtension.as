/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.entityMapExtension {
public class EntityMapExtension {
	protected var _map:SimpleEntityMap;

	public function EntityMapExtension() {
	}

	public function get entityMap():EntityMap {
		return _map;
	}

	public function install( context:* ):void {
		_map = new SimpleEntityMap();
		context.entities.registerHandler( _map );
	}

	public function uninstall( context:* ):void {
		context.entities.unregisterHandler( _map );
		_map.dispose();
	}
}
}
