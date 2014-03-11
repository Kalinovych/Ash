/**
 * Created by Alexander Kalinovych @ 2013
 */
package com.flashrush.signatures {

public class Bit64Sign extends BitSign {
	
	public function Bit64Sign() {
		super(2);
	}
	
	override public function match(sign:BitSign):Boolean {
		return ( valueList[0] == sign.valueList[0] && valueList[1] == sign.valueList[1] );
	}

	override public function partOf(sign:BitSign):Boolean {
		return ( valueList[0] == (valueList[0] & sign.valueList[0]) && valueList[1] == (valueList[1] & sign.valueList[1]) );
	}

	override public function contains(sign:BitSign):Boolean {
		return ( sign.valueList[0] == (sign.valueList[0] & valueList[0]) && sign.valueList[1] == (sign.valueList[1] & valueList[1]) );
	}
}
}
