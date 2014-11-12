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
	public const fieldList:Vector.<AspectField> = new <AspectField>[];
	
	public const fieldMap:Dictionary/*<Class, String fieldName>*/ = new Dictionary();
	
	public var fieldCount:uint = 0;
	
	public var hasExcluded:Boolean = false;
	
	/**
	 * Constructor
	 * @param type The Class of the described aspect
	 */
	public function AspectInfo() {
	}
	
	/**
	 * @internal
	 */
	internal function addField( type:Class, name:String, kind:int ):void {
		const field:AspectField = new AspectField(type, name, kind );
		fieldList[fieldCount] = field;
		fieldMap[type] = field;
		fieldCount++;
		hasExcluded ||= (kind == AspectField.EXCLUDED);
	}
}
}