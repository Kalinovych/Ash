/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.entity {
public class EntityContainer extends Entity {
	private var _children:EntityCollection = new EntityCollection();

	public function EntityContainer() {
		super();
	}

	public function get children():EntityCollection {
		return _children;
	}
	
	public function addChild( entity:Entity ):Entity {
		return _children.add( entity );
	}

	public function removeChild( entity:Entity ):Entity {
		return _children.remove( entity );
	}

	public function contains( entity:Entity ):Boolean {
		return _children.contains( entity );
	}

}
}
