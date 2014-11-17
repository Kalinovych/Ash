/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspectMap {
public class AspectMap {
	public function AspectMap() {
	}
	
	public function map( type:Class ):AspectMapper {
		const mapper:AspectMapper;
		return mapper;
	}
}
}

class AspectMapper {
	public function toAspect( aspectClass:Class ):AspectMapping {
		
	}
}

class AspectMapping {
	
}