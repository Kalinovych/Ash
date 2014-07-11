/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.gdf.ds {
import flashrush.gdf.api.gdf_core;

use namespace gdf_core;

public class Node {
	public var item:*;
	public var prev:Node;
	public var next:Node;

	/** For ordered lists */
	gdf_core var order:int;

	internal var prevInFactory:Node;

	public function Node( item:* = null ) {
		this.item = item;
	}
}
}
