/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {

/**
 * Contains the information about a single trait(component) of the family. 
 */
public class FamilyTrait {
	public static const REQUIRED:int = 1;
	public static const OPTIONAL:int = 2;
	public static const EXCLUDED:int = 3;
	
	public/* readonly */var type:Class;
	public/* readonly */var kind:int;
	public/* readonly */var fieldName:String;
	
	public function FamilyTrait( componentType:Class, kind:int = REQUIRED, fieldName:String = null ) {
		CONFIG::debug{ $verifyKind(kind); }
		
		this.type = componentType;
		this.kind = kind;
		this.fieldName = fieldName;
	}
	
	public final function get isRequired():Boolean {
		return (kind == REQUIRED);
	}
	
	public final function get isOptional():Boolean {
		return (kind == OPTIONAL);
	}
	
	public final function get isExcluded():Boolean {
		return (kind == EXCLUDED);
	}
	
	public final function get isNotExcluded():Boolean {
		return (kind != EXCLUDED);
	}
	
	CONFIG::debug
	[Inline]
	protected final function $verifyKind( kind:int ):void {
		if ( kind < REQUIRED || kind > EXCLUDED ) {
			throw new ArgumentError( "Incorrect kind of a FamilyTrait: " + kind );
		}
	}
}
}
