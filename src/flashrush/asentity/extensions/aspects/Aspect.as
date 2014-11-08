/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flashrush.asentity.framework.entity.Entity;
import flashrush.collections.base.Linkable;

public class Aspect extends Linkable {
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
}
}
