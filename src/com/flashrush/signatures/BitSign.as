/**
 * Created by Alexander Kalinovych @2013.
 */
package com.flashrush.signatures {

public class BitSign {
	internal static const BITS_PER_CELL:uint = 32;

	internal var valueList:Vector.<uint>;
	internal var level:uint;
	internal var signer:BitSigner;

	// aux variables declaration for iterations :)
	internal var i:int;
	internal var aux:uint;

	/**
	 * 32 elements per level.
	 * If (elements / 32) will be more then cells an error will occur.
	 * @param level
	 */
	public function BitSign( level:uint = 4 ) {
		this.level = level;
		initialize();
	}

	protected function initialize():void {
		valueList = new Vector.<uint>( level );
	}

	internal function reset():void {
		valueList.length = 0;
		valueList.length = level;
	}

	public function add( element:* ):void {
		setBit( signer.elementIndexMap[element] ||= signer.elementIndex++ );
	}

	public function remove( element:* ):void {
		var index:* = signer.elementIndexMap[element];
		// clear if index defined and > 0
		if ( index ) {
			clearBit( index );
		}
	}

	/**
	 * Determines whether the signature specified in the <p>sign</p> parameter is equal to this signature.
	 * @param sign
	 * @return
	 */
	public function match( sign:BitSign ):Boolean {
		for ( i = 0; i < level; i++ ) {
			if ( valueList[i] != sign.valueList[i] ) {
				return false;
			}
		}
		return true;
	}

	/**
	 * Determines whether the signature specified in the <p>sign</p> have all elements of this signature.
	 * @param sign
	 * @return
	 */
	public function partOf( sign:BitSign ):Boolean {
		for ( i = 0; i < level; i++ ) {
			aux = valueList[i];
			if ( aux != (aux & sign.valueList[i]) ) {
				return false;
			}
		}
		return true;
	}

	/**
	 * Determines whether this signature have all elements of the <p>sign</p>
	 * @param sign
	 * @return
	 */
	public function contains( sign:BitSign ):Boolean {
		for ( i = 0; i < level; i++ ) {
			aux = sign.valueList[i];
			if ( aux != (aux & valueList[i]) ) {
				return false;
			}
		}
		return true;
	}

	internal function setBit( index:uint ):void {
		var cellIndex:uint = index / BITS_PER_CELL;
		var bitIndex:uint = index - (cellIndex * BITS_PER_CELL);
		valueList[cellIndex] |= (0x00000001 << bitIndex);
	}

	internal function clearBit( index:uint ):void {
		var cellIndex:uint = index / BITS_PER_CELL;
		var bitIndex:uint = index - (cellIndex * BITS_PER_CELL);
		valueList[cellIndex] &= ~(0x00000001 << bitIndex);
	}

	public function toString( fullLength:Boolean = false ):String {
		var str:String = "[";
		for ( i = 0; i < level; i++ ) {
			//str += valueList[i].toString(2);
			str += formatValue( valueList[i] );
		}
		return str + "]";
	}

	protected function formatValue( value:uint, fullLength:Boolean = false ):String {
		var str:String = value.toString( 2 );
		if ( fullLength ) {
			var zerosToAdd:int = 32 - str.length;
			for ( var i:int = 0; i < zerosToAdd; i++ ) {
				str = "0" + str;
			}
		}
		return str;
	}
}
}
