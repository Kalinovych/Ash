/**
 * Created by Alexander Kalinovych @2013.
 */
package com.flashrush.signatures {
import flash.utils.Dictionary;

public class BitSigner {
	public static var signClassProvider:Function = function(capacityLevel:uint):Class {
		if (capacityLevel == 1) {
			return Bit32Sign;
		}
		if (capacityLevel == 2) {
			return Bit64Sign;
		}
		return BitSign;
	}
	
	/** BitSigner Implementation */

	/**
	 * Can be the reference to a static pool of required sign class instances.
	 */
	internal var pool:Vector.<BitSign>;

	internal var elementIndex:uint = 1; // index 0 reserved. And first bit in sign always == 0
	internal var elementIndexMap:Dictionary = new Dictionary();
	
	private var elementCapacityLevel:uint;
	private var signClass:Class;
	
	public function BitSigner(elementCapacityLevel:uint = 1, pool:Vector.<BitSign> = null) {
		this.elementCapacityLevel = elementCapacityLevel;
		this.signClass = signClassProvider(elementCapacityLevel);
		this.pool = pool ? pool : new Vector.<BitSign>();
	}

	public function getSign(elementsAsKeys:Dictionary = null):BitSign {
		var sign:BitSign = pool.length > 0 ? pool.pop() : new signClass();
		sign.signer = this;
		sign.level = elementCapacityLevel;
		sign.reset();
		if (elementsAsKeys) {
			for (var element:* in elementsAsKeys) {
				sign.add(element)
			}
		}
		return sign;
	}

	public function recycleSign(sign:BitSign):void {
		sign.signer = null;
		pool.push(sign);
	}

	/*[Inline]
	public function addElement(sign:BitSign, element:*):void {
		var index:uint = elementIndexMap[element] ||= elementIndex++;
		sign.setBit(index);
	}

	[Inline]
	public function removeElement(sign:BitSign, element:*):void {
		var index:uint = elementIndexMap[element];
		sign.clearBit(index);
	}
	
	public function getIndexForElement(element:*):uint {
		return elementIndexMap[element] ||= elementIndex++;
	}
	
	internal function getElementIndex(element:*):uint {
		return elementIndexMap[element];
	}*/
}
}
