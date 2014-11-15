/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flash.utils.Dictionary;

/**
 * Contains the information that describes an aspect of an entity.
 */
public class AspectInfo {
	public var type:Class = Aspect;
	
	public const traits:Vector.<FamilyTrait> = new <FamilyTrait>[];
	
	public const traitMap:Dictionary/*<(component)Class, AspectTrait>*/ = new Dictionary();
	
	public var traitCount:uint = 0;
	
	public var hasExcluded:Boolean = false;
	
	/**
	 * Constructor
	 * @param nodeClass The Class of the described aspect
	 */
	public function AspectInfo( nodeClass:Class = null ) {
		this.type = nodeClass || Aspect;
	}
	
	public function addTrait( trait:FamilyTrait ):void {
		traits[traitCount] = trait;
		traitMap[trait.type] = trait;
		hasExcluded ||= (trait.kind == FamilyTrait.EXCLUDED);
		++traitCount;
	}
}
}