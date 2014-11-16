/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.utils {
public class ElementBits extends BitVec {
	private var indexMap:ObjectIndexer;
	
	public function ElementBits( fieldCount:uint, elementIndexProvider:ObjectIndexer ) {
		super( fieldCount );
		this.indexMap = elementIndexProvider;
	}
	
	public function add( element:* ):void {
		set( indexMap.provide( element ) )
	}
	
	public function addAll( elements:Array ):void {
		const elemCount:uint = elements.length;
		for (var i:int = 0; i < elemCount; ++i) {
			add( elements[i] );
		}
	}
	
	public function remove( element:* ):void {
		unset( indexMap.provide( element ) );
	}
}
}
