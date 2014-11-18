/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flashrush.asentity.framework.entity.Entity;

public class Aspect {
	
	//-------------------------------------------
	// Properties
	//-------------------------------------------
	
	public var entity:Entity;

	public var prev/*<Aspect>*/:*;

	public var next/*<Aspect>*/:*;
	
	//-------------------------------------------
	// Internals
	//-------------------------------------------
	
	internal var cacheNext:Aspect;
	
	//-------------------------------------------
	// Protected Namespace
	//-------------------------------------------
	
	protected namespace trait = aspect_trait_ns;
	
}
}
