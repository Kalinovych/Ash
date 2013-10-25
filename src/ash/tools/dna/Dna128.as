/**
 * Created by Alexander Kalinovych @2013.
 */
package ash.tools.dna {
public class Dna128 extends Dna {
	
	public function Dna128() {
		super();
		cellCount = 4;
	}

	[Inline]
	override public function dnaBelongToFamily(dnaChain:Vector.<uint>, familyDnaChain:Vector.<uint>):Boolean {
		return ( (dnaChain[0] & familyDnaChain[0]) == familyDnaChain[0]
				&& (dnaChain[1] & familyDnaChain[1]) == familyDnaChain[1]
				&& (dnaChain[2] & familyDnaChain[2]) == familyDnaChain[2]
				&& (dnaChain[3] & familyDnaChain[3]) == familyDnaChain[3]
				);
	}
}
}
