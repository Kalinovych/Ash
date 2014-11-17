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
	
	public function signNone():BitSign {
		return new BitSign( vecFieldCount, indexMap );
	}
	
	public function signAll():BitSign {
		return new BitSign( vecFieldCount, indexMap ).setAll() as BitSign;
	}
	
	public function sign( items:Array ):BitSign {
		const bits:BitSign = new BitSign( vecFieldCount, indexMap );
		if (items) bits.addAll( items );
		return bits;
	}
	
	public function signKeys( map:Object ):BitSign {
		const sign:BitSign = new BitSign( vecFieldCount, indexMap );
		for ( var key:* in map ) {
			sign.add( key );
		}
		return sign;
	}
}
}
