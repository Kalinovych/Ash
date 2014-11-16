/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.utils {
import flashrush.utils.ToString;

public class BitVec {
	public static const EMPTY_FIELD:uint = 0x0;
	public static const FULL_FIELD:uint = 0xFFFFFFFF;
	
	public static const BIT_INDEX_MASK:uint = 0x1F;
	public static const FIELD_INDEX_SHIFT:uint = 5;
	
	internal var _fields:Vector.<uint>;
	internal var _fieldCount:uint;
	
	/**
	 * Creates new BitVec with fixed number of bitfields for performance reason
	 * as itself created for.
	 * One bitfield can store up to 32 bit flags.
	 * @param bitFieldCount Number of bitfields to store flags.
	 */
	public function BitVec( bitFieldCount:uint = 1 ) {
		_fieldCount = bitFieldCount || 1;
		_fields = new Vector.<uint>( this._fieldCount );
	}
	
	public function get fieldCount():uint {
		return _fieldCount;
	}
	
	public function set( index:uint ):BitVec {
		_fields[index >> 5] |= (1 << (index & BIT_INDEX_MASK));
		return this;
	}
	
	public function setAll():BitVec {
		var i:uint = 0;
		do {
			_fields[i] = FULL_FIELD;
			++i;
		}
		while ( i < _fieldCount );
		return this;
	}
	
	public function unset( index:uint ):BitVec {
		_fields[index >>> FIELD_INDEX_SHIFT] &= ~(1 << (index & BIT_INDEX_MASK));
		return this;
	}
	
	public function unsetAll():BitVec {
		var i:uint = 0;
		do {
			_fields[i] = EMPTY_FIELD;
			++i;
		}
		while ( i < _fieldCount );
		return this;
	}
	
	public function has( index:uint ):Boolean {
		return (_fields[index >>> FIELD_INDEX_SHIFT] & (1 << (index & BIT_INDEX_MASK)));
	}
	
	public function hasAllOf( other:BitVec, mask:BitVec = null ):Boolean {
		if ( !$verifyCompareArg( other ) ) {
			return false;
		}
		var i:int;
		var otherField:uint;
		if ( mask ) {
			for ( i = 0; i < _fieldCount; ++i ) {
				otherField = other._fields[i];
				if ( (_fields[i] & otherField & mask._fields[i]) != otherField ) {
					return false;
				}
			}
		} else {
			for ( i = 0; i < _fieldCount; ++i ) {
				otherField = other._fields[i];
				if ( (_fields[i] & otherField) != otherField ) {
					return false;
				}
			}
		}
		
		return true;
	}
	
	public function hasNoneOf( other:BitVec, mask:BitVec = null ):Boolean {
		if ( !$verifyCompareArg( other ) ) {
			return false;
		}
		
		var i:int;
		var field:uint;
		if ( mask ) {
			for ( i = 0; i < _fieldCount; ++i ) {
				field = _fields[i];
				if ( (field & ~(other._fields[i] & mask._fields[i]) ) != field ) {
					return false;
				}
			}
		} else {
			for ( i = 0; i < _fieldCount; ++i ) {
				field = _fields[i];
				if ( (field & ~other._fields[i]) != field ) {
					return false;
				}
			}
		}
		
		return true;
	}
	
	public function toVector():Vector.<uint> {
		return _fields.slice();
	}
	
	public function toString():String {
		var str:String = "";
		for ( var i:int = _fieldCount - 1; i >= 0; --i ) {
			if ( str ) str += " ";
			str += ToString.binary( _fields[i], true, 4 );
		}
		return str;
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
		if ( other._fieldCount != _fieldCount ) {
			CONFIG::debug{ throw new ArgumentError( "Bit vectors with different number of fields can't be compared!" ); }
			return false;
		}
		
		return true;
	}
}
}
