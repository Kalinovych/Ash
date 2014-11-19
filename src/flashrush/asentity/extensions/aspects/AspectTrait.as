/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import flashrush.utils.getClassName;

/**
 * Contains the information about a family's single trait(component).
 */
public class AspectTrait {
	public static const REQUIRED:int = 1;
	public static const OPTIONAL:int = 2;
	public static const EXCLUDED:int = 3;
	
	public/* readonly */var type:Class;
	public/* readonly */var kind:int;
	public/* readonly */var fieldName:QName;
	public/* readonly */var autoInject:Boolean;
	
	public function AspectTrait( componentType:Class, kind:int = REQUIRED, fieldName:QName = null ) {
		CONFIG::debug{ $verifyKind( kind ); }
		
		this.type = componentType;
		this.kind = kind;
		this.fieldName = fieldName;
		this.autoInject = (kind != EXCLUDED && fieldName && fieldName.uri != aspect_trait_ns.uri);
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
	
	public function toString():String {
		var kindName:String = "required";
		if ( isOptional ) kindName = "optional";
		else if ( isExcluded ) kindName = "exclude";
		return "[AspectTrait " + fieldName.localName + ":" + getClassName( type )
				+ ",attrs:" + kindName + (autoInject ? "" : ",trait") + "]";
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
