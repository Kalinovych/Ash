/**
 * Created by Alexander Kalinovych @2013.
 */
package ash.tools.dna {
public class Dna32 extends Dna {
	
	public function Dna32() {
		super();
		cellCount = 1;
	}

	[Inline]
	override public function addElementToDNA(chain:Vector.<uint>, element:Class):void {
		var index:uint = indexByType[element] ||= elementIndex++;
		chain[0] |= (0x00000001 << index);
	}

	[Inline]
	override public function removeElementFromDNA(dnaChain:Vector.<uint>, element:Class):void {
		var index:uint = indexByType[element];
		dnaChain[0] &= ~(0x00000001 << index);
	}
	
	override public function dnaBelongToFamily(dnaChain:Vector.<uint>, familyDnaChain:Vector.<uint>):Boolean {
		return ( (dnaChain[0] & familyDnaChain[0]) == familyDnaChain[0] );
	}
}
}
