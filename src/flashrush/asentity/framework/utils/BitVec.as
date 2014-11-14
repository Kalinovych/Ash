/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.utils {

public class BitVec {
	public static const EMPTY_FIELD:uint = 0x0;
	public static const FULL_FIELD:uint = 0xFFFFFFFF;
	
	protected static const BIT_INDEX_MASK:uint = 0x1F;
	protected static const FIELD_INDEX_SHIFT:uint = 5;
	
	internal var fields:Vector.<uint>;
	internal var fieldCount:uint;
	
	public function BitVec( bitFieldCount:uint = 1 ) {
		this.fieldCount = bitFieldCount || 1;
		fields = new Vector.<uint>( this.fieldCount );
	}
	
	public function set( index:uint ):void {
		fields[index >> 5] |= (1 << (index & BIT_INDEX_MASK));
	}
	
	public function setAll():void {
		var i:uint = 0;
		do {
			fields[i] = FULL_FIELD;
			++i;
		}
		while ( i < fieldCount );
	}
	
	public function unset( index:uint ):void {
		fields[index >>> FIELD_INDEX_SHIFT] &= ~(1 << (index & BIT_INDEX_MASK));
	}
	
	public function unsetAll():void {
		var i:uint = 0;
		do {
			fields[i] = EMPTY_FIELD;
			++i;
		}
		while ( i < fieldCount );
	}
	
	public function has( index:uint ):Boolean {
		return (fields[index >>> FIELD_INDEX_SHIFT] & (1 << (index & BIT_INDEX_MASK)));
	}
	
	public function hasAllOf( other:BitVec, mask:BitVec = null ):Boolean {
		if ( !$verifyCompareArg( other ) ) {
			return false;
		}
		var i:int;
		var otherField:uint;
		if ( mask ) {
			for ( i = 0; i < fieldCount; ++i ) {
				otherField = other.fields[i];
				if ( (fields[i] & otherField & mask.fields[i]) != otherField ) {
					return false;
				}
			}
		} else {
			for ( i = 0; i < fieldCount; ++i ) {
				otherField = other.fields[i];
				if ( (fields[i] & otherField) != otherField ) {
					return false;
				}
			}
		}
		
		return true;
	}
	
	public function hasNoneOf( other:BitVec ):Boolean {
		if ( !$verifyCompareArg( other ) ) {
			return false;
		}
		
		for ( var i:int = 0; i < fieldCount; ++i ) {
			const field:uint = fields[i];
			if ( (field & ~other.fields[i]) != field ) {
				return false;
			}
		}
		
		return true;
	}
	
	//-------------------------------------------
	// Protected methods
	//-------------------------------------------
	
	[Inline]
	protected final function $verifyCompareArg( other:BitVec ):Boolean {
		if ( !other ) {
			CONFIG::debug{ throw TypeError( "Bit vector can't be compared with null" ); }
			return false;
		}
		if ( other.fieldCount != fieldCount ) {
			CONFIG::debug{ throw new ArgumentError( "Bit vectors with different number of fields can't be compared!" ); }
			return false;
		}
		
		return true;
	}
}
}
