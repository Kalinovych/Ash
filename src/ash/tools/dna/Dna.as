/**
 * Created by Alexander Kalinovych @2013.
 */
package ash.tools.dna {
import flash.utils.Dictionary;

public class Dna {
	public static const CHAIN_LEN:uint = 32;

	protected var elementIndex:uint = 1;
	protected var indexByType:Dictionary = new Dictionary();
	
	protected var cellCount:uint = 0;

	public function Dna() {
	}

	public function createDNA(elementMap:Dictionary):Vector.<uint> {
		var dnaChain:Vector.<uint> = new Vector.<uint>(cellCount, true);
		for (var element:Class in elementMap) {
			addElementToDNA(dnaChain, element);
		}
		return dnaChain;
	}

	[Inline]
	public function addElementToDNA(chain:Vector.<uint>, element:Class):void {
		var index:uint = indexByType[element] ||= elementIndex++;
		var elementCell:uint = index / CHAIN_LEN;
		var bitIndex:uint = index - (elementCell * CHAIN_LEN);
		chain[elementCell] |= (0x00000001 << bitIndex);
	}

	[Inline]
	public function removeElementFromDNA(dnaChain:Vector.<uint>, element:Class):void {
		var index:uint = indexByType[element];
		var elementCell:uint = index / CHAIN_LEN;
		var bitIndex:uint = index - (elementCell * CHAIN_LEN);
		//chain[elementCell] ^= (0x00000001 << bitIndex);
		dnaChain[elementCell] &= ~(0x00000001 << bitIndex);
	}

	public function dnaBelongToFamily(dnaChain:Vector.<uint>, familyDnaChain:Vector.<uint>):Boolean {
		throw new Error(this["constructor"] + " method dnaBelongToFamily() is abstract and should be overridden");
		return false;
	}

}
}
