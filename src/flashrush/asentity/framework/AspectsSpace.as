/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework {
import flashrush.asentity.extensions.aspects.AspectManager;

public class AspectsSpace extends Space {
	protected var _aspectManager:AspectManager;
	
	public function AspectsSpace() {
		super();
		_aspectManager = new AspectManager( _entities, null );
	}
}
}
