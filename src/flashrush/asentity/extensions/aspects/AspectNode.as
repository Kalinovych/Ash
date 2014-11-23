/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flashrush.asentity.framework.entity.Entity;

public class AspectNode {
	
//-------------------------------------------
// Properties
//-------------------------------------------
	
	public var entity:Entity;

	public var prev/*<AspectNode>*/:*;

	public var next/*<AspectNode>*/:*;
	
//-------------------------------------------
// Internals
//-------------------------------------------
	
	internal var cacheNext:AspectNode;
	
//-------------------------------------------
// Protected
//-------------------------------------------
	
	protected namespace trait = aspect_trait_ns;
	
}
}
