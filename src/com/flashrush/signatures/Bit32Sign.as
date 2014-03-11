/**
 * Created by Alexander Kalinovych @2013.
 */
package com.flashrush.signatures {

/**
 * Bit32Sign class implemented to improve performance for small element groups.
 * With Bit32Sign can be signed only 32 different elements
 */
public class Bit32Sign extends BitSign {

	/** Use single member variable instead of vector for faster value access */
	internal var value:uint;

	public function Bit32Sign() {
		super( 0 );
	}

	override protected function initialize():void {
		value = 0x0;
	}

	override internal function reset():void {
		value = 0x0;
	}

	override public function match( sign:BitSign ):Boolean {
		return (value == (sign as Bit32Sign).value);
	}

	override public function partOf( sign:BitSign ):Boolean {
		return (value == (value & (sign as Bit32Sign).value));
	}

	override public function contains( sign:BitSign ):Boolean {
		aux = (sign as Bit32Sign).value;
		return (aux == (aux & value));
	}

	[Inline]
	override internal function setBit( index:uint ):void {
		value |= (0x00000001 << index);
	}

	[Inline]
	override internal function clearBit( index:uint ):void {
		value &= ~(0x00000001 << index);
	}

	override public function toString( fullLength:Boolean = false ):String {
		return "[" + formatValue( value ) + "]";
	}
}
}
