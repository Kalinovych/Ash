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
	
	/**
	 * Enum kinds of interest
	 */
	public static const NONE_KIND:int = 0;
	public static const REQUIRED_KIND:int = 1;
	public static const OPTIONAL_KIND:int = 2;
	public static const EXCLUDED_KIND:int = 3;
	
	/**
	 * The Class of described aspect
	 */
	public var type:Class;
	
	/**
	 * The map of property field names of the Aspect class by the component types.
	 */
	public var requiredMap:Dictionary/*<Class, String fieldName>*/ = new Dictionary();
	
	/**
	 * The components that do not affect the aspect on an entity.
	 */
	public var optionalMap:Dictionary/*<Class, String fieldName>*/;
	
	/**
	 * The components that discard the aspect of an entity
	 */
	public var excludedMap:Dictionary/*<Class, String fieldName>*/;
	
	/**
	 * The list of components the aspect interested in.
	 */
	public var interests:Vector.<Class> = new <Class>[];
	
	/**
	 * The map of kind of interest to a component types/
	 */
	public var interestKindMap:Dictionary/*<Class, int>*/ = new Dictionary();
	
	/**
	 * The total number of components that describes an aspect.
	 * It is equals to the interests.length.
	 */
	public var interestCount:uint = 0;
	
	/**
	 * Constructor
	 * @param type The Class of the described aspect
	 */
	public function AspectInfo( type:Class ) {
		this.type = type;
	}
	
	/**
	 * @internal
	 */
	internal function addTrait( type:Class, fieldName:String, kind:int ):void {
		switch (kind) {
			case REQUIRED_KIND:
				requiredMap[type] = fieldName;
				break;
			case OPTIONAL_KIND:
				optionalMap ||= new Dictionary();
				optionalMap[type] = fieldName;
				break;
			case EXCLUDED_KIND:
				excludedMap ||= new Dictionary();
				excludedMap[type] = fieldName;
				break;
			default:
				throw new ArgumentError("A component info " + type + " with kind '" + kind + "' can't be added!");
				break;
		}
		
		interests[interestCount++] = type;
		interestKindMap[type] = kind;
	}
}
}
