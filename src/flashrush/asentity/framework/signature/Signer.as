/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.signature {
import flashrush.asentity.framework.utils.ObjectIndexer;
import flashrush.asentity.framework.utils.SetBits;

public class Signer {
	private var indexMap:ObjectIndexer = new ObjectIndexer();
	private var fieldsPerVec:uint;
	
	public function Signer( maxElements:uint = 64 ) {
		if (maxElements == 0) maxElements = 32;
		fieldsPerVec = 1 + ((maxElements-1) >>> 5);
	}
	
	public function signNone():SetBits {
		const s:SetBits = new SetBits( fieldsPerVec, indexMap );
		s.setAll();
		return s;
	}
	
	public function signFull():SetBits {
		return new SetBits( fieldsPerVec, indexMap );
	}
	
	public function signElements( elements:Array ):SetBits {
		const sign:SetBits = new SetBits( fieldsPerVec, indexMap );
		const elemCount:uint = (elements ? elements.length : 0);
		for (var i:int = 0; i < elemCount; ++i) {
			sign.add( elements[i] );
		}
		return sign;
	}
	
	public function signKeys( map:Object ):SetBits {
		const sign:SetBits = new SetBits( fieldsPerVec, indexMap );
		for ( var key:* in map ) {
			sign.add( key );
		}
		return sign;
	}
}
}
