/**
 * Created by Alexander Kalinovych @2013.
 */
package ash.tools.dna {
public class Dna64 extends Dna {
	
	public function Dna64() {
		super();
		cellCount = 2;
	}

	[Inline]
	override public function dnaBelongToFamily(dnaChain:Vector.<uint>, familyDnaChain:Vector.<uint>):Boolean {
		return ( (dnaChain[0] & familyDnaChain[0]) == familyDnaChain[0] && (dnaChain[1] & familyDnaChain[1]) == familyDnaChain[1] );
	}
}
}
