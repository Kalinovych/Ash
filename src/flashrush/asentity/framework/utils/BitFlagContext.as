/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.utils {
public class BitFlagContext {
	private var indexMap:ObjectIndexer = new ObjectIndexer();
	private var vecFieldCount:uint;
	
	public function BitFlagContext( maxFlagCount:uint = 64 ) {
		vecFieldCount = 1 + ((maxFlagCount-1) >>> 5);
	}
	
	public function signNone():ObjectBits {
		const s:ObjectBits = new ObjectBits( vecFieldCount, indexMap );
		s.setAll();
		return s;
	}
	
	public function signFull():ObjectBits {
		return new ObjectBits( vecFieldCount, indexMap );
	}
	
	public function signElements( elements:Array ):ObjectBits {
		const sign:ObjectBits = new ObjectBits( vecFieldCount, indexMap );
		const elemCount:uint = (elements ? elements.length : 0);
		for (var i:int = 0; i < elemCount; ++i) {
			sign.add( elements[i] );
		}
		return sign;
	}
	
	public function signKeys( map:Object ):ObjectBits {
		const sign:ObjectBits = new ObjectBits( vecFieldCount, indexMap );
		for ( var key:* in map ) {
			sign.add( key );
		}
		return sign;
	}
}
}
