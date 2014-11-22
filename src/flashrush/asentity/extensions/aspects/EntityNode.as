/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flashrush.asentity.framework.entity.Entity;

public class EntityNode {
	
//-------------------------------------------
// Properties
//-------------------------------------------
	
	public var entity:Entity;

	public var prev/*<EntityNode>*/:*;

	public var next/*<EntityNode>*/:*;
	
//-------------------------------------------
// Internals
//-------------------------------------------
	
	internal var cacheNext:EntityNode;
	
//-------------------------------------------
// Protected
//-------------------------------------------
	
	protected namespace trait = aspect_trait_ns;
	
}
}
