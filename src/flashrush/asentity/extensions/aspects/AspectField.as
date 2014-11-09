/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
public class AspectField {
	public static const REQUIRED:int = 1;
	public static const OPTIONAL:int = 2;
	public static const EXCLUDED:int = 3;
	
	public/* readonly */var type:Class;
	public/* readonly */var name:String;
	public/* readonly */var kind:int;
	
	public function AspectField( type:Class, name:String, kind:int ) {
		CONFIG::debug{ $verifyKind(kind); }
		
		this.type = type;
		this.name = name;
		this.kind = kind;
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
	
	public final function get isRequiredOrOptional():Boolean {
		return (kind == REQUIRED || kind == OPTIONAL);
	}
	
	CONFIG::debug
	[Inline]
	protected final function $verifyKind( kind:int ):void {
		if ( kind < REQUIRED || kind > EXCLUDED ) {
			throw new ArgumentError( "Incorrect AspectField kind value passed: " + kind );
		}
	}
}
}
