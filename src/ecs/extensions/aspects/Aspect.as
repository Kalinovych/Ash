/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.extensions.aspects {
import ecs.framework.entity.Entity;

public class Aspect {
	public var entity:Entity;

	public var prev/*<AspectNode>*/:*;

	public var next/*<AspectNode>*/:*;
}
}
