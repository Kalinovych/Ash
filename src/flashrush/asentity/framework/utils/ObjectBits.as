/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.utils {
public class ObjectBits extends BitVec {
	private var indexMap:ObjectIndexer;
	
	public function ObjectBits( fieldCount:uint, indexMap:ObjectIndexer ) {
		super( fieldCount );
		this.indexMap = indexMap;
	}
	
	public function add( element:* ):void {
		set( indexMap.provide( element ) )
	}
	
	public function remove( element:* ):void {
		unset( indexMap.provide( element ) );
	}
}
}
