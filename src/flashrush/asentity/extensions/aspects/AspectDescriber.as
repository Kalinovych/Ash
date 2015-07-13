/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.aspects {
import avmplus.HIDE_OBJECT;
import avmplus.INCLUDE_METADATA;
import avmplus.INCLUDE_TRAITS;
import avmplus.INCLUDE_VARIABLES;
import avmplus.USE_ITRAITS;

import com.flashrush.utils.DescribeTypeJSONCached;

import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;

public class AspectDescriber {
	private static const OPTIONAL_META_TAG:String = "Optional";
	private static const EXCLUDE_META_TAG:String = "Without";
	
	// map of field names to skip when building aspect info.
	private static const SKIP_FIELDS:Object = {"entity": true, "prev": true, "next": true};
	
	private static const _infoMap:Dictionary = new Dictionary();
	
	public static function describe( aspectClass:Class ):AspectInfo {
		var info:AspectInfo = _infoMap[aspectClass];
		if ( !info ) {
			info = _describe( aspectClass );
			_infoMap[aspectClass] = info;
		}
		return info;
	}
	
	//-------------------------------------------
	// Internals
	//-------------------------------------------
	
	private static function _describe( aspectClass:Class ):AspectInfo {
		const info:AspectInfo = new AspectInfo();
		
		// describe type
		const typeData:Object = DescribeTypeJSONCached.describe( aspectClass, INCLUDE_VARIABLES | INCLUDE_METADATA | INCLUDE_TRAITS | USE_ITRAITS | HIDE_OBJECT );
		
		// list of field descriptions
		var fieldDataList:Array = [];
		
		const varsData:Array = typeData.traits.variables;
		if ( varsData ) {
			fieldDataList = fieldDataList.concat( varsData );
		}
		
		// reflect fields to info
		const fieldCount:uint = fieldDataList.length;
		for ( var i:int = 0; i < fieldCount; i++ ) {
			const field:Object = fieldDataList[i];
			const fieldName:String = field.name;
			if ( SKIP_FIELDS[fieldName] ) {
				continue;
			}
			
			const componentClass:Class = getDefinitionByName( field.type ) as Class;
			const inclusionKind:int = retrieveInclusionKind( field.metadata );
			info.addTrait( new AspectTrait( componentClass, inclusionKind, new QName(field.uri || "", fieldName)) );
		}
		
		return info;
	}
	
	private static function retrieveInclusionKind( metadata:Array ):int {
		const annotationCount:uint = ( metadata ? metadata.length : 0 );
		for ( var i:int = 0; i < annotationCount; i++ ) {
			const tagName:String = metadata[i].name;
			if ( tagName == EXCLUDE_META_TAG ) {
				return AspectTrait.EXCLUDED;
			}
			if ( tagName == OPTIONAL_META_TAG ) {
				return AspectTrait.OPTIONAL;
			}
		}
		return AspectTrait.REQUIRED;
	}
	
	
	// cached data, shared between aspect observers
	/*private static var propertyMapByType:Dictionary = new Dictionary();
	private static var componentInterestsByType:Dictionary = new Dictionary();
	private static var excludedComponentsByType:Dictionary = new Dictionary();
	private static var optionalComponentsByType:Dictionary = new Dictionary();
	
	public static function describeAspect( type:Class, observer:AspectObserver ):void {
		var propertyMap:Dictionary = propertyMapByType[type];
		var componentInterests:Vector.<Class> = componentInterestsByType[type];
		var excludedComponents:Dictionary = excludedComponentsByType[type];
		var optionalComponents:Dictionary = optionalComponentsByType[type];
		
		if ( !propertyMap ) {
			propertyMap = new Dictionary();
			propertyMapByType[type] = propertyMap;
			
			componentInterests = new Vector.<Class>();
			componentInterestsByType[type] = componentInterests;
			
			var typeInfo:Object = DescribeTypeJSONCached.describe( type, INCLUDE_VARIABLES | INCLUDE_METADATA | INCLUDE_TRAITS | USE_ITRAITS | HIDE_OBJECT );
			var propList:Array = [];
			if ( typeInfo.traits.variables ) {
				propList.push.apply( null, typeInfo.traits.variables );
			}
			
			// parse properties
			for ( var i:int = 0, len:int = propList.length; i < len; i++ ) {
				var property:Object = propList[i];
				var propertyName:String = property.name;
				//if ( propertyName == "entity" || propertyName == "prev" || propertyName == "next" ) {
				if ( SKIP_FIELDS[propertyName] ) {
					continue;
				}
				
				var componentClass:Class = getDefinitionByName( property.type ) as Class;
				componentInterests[componentInterests.length] = componentClass;
				
				componentMapping: {
					var metaList:Array = property.metadata;
					if ( metaList && metaList.length ) {
						for each( var md:Object in metaList ) {
							var metaName:String = md.name;
							if ( metaName == EXCLUDE_META_TAG ) {
								if ( !excludedComponents ) {
									excludedComponents = new Dictionary();
									excludedComponentsByType[type] = excludedComponents;
								}
								excludedComponents[componentClass] = propertyName;
								break componentMapping;
							} else if ( metaName == OPTIONAL_META_TAG ) {
								if ( !optionalComponents ) {
									optionalComponents = new Dictionary();
									optionalComponentsByType[type] = optionalComponents;
								}
								optionalComponents[componentClass] = propertyName;
								break componentMapping;
							}
						}
					}
					// if component is not excluded and not is optional add it to regular property map 
					propertyMap[componentClass] = propertyName;
				}
			}
		}
		
		observer.propertyMap = propertyMap;
		observer.componentInterests = componentInterests;
		observer.excludedComponents = excludedComponents;
		observer.optionalComponents = optionalComponents;
	}*/
	
}
}