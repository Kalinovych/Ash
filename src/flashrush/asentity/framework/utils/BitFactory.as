/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.utils {
public class BitFactory {
	private var indexMap:ObjectIndexer = new ObjectIndexer();
	private var vecFieldCount:uint;
	
	public function BitFactory( maxFlagCount:uint = 64 ) {
		vecFieldCount = 1 + ((maxFlagCount-1) >>> BitVec.FIELD_INDEX_SHIFT);
	}
	
	public function signNone():ElementBits {
		return new ElementBits( vecFieldCount, indexMap );
	}
	
	public function signAll():ElementBits {
		return new ElementBits( vecFieldCount, indexMap ).setAll() as ElementBits;
	}
	
	public function sign( items:Array ):ElementBits {
		const bits:ElementBits = new ElementBits( vecFieldCount, indexMap );
		if (items) bits.addAll( items );
		return bits;
	}
	
	public function signKeys( map:Object ):ElementBits {
		const sign:ElementBits = new ElementBits( vecFieldCount, indexMap );
		for ( var key:* in map ) {
			sign.add( key );
		}
		return sign;
	}
}
}
