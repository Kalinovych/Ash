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

public class AspectUtil {
	private static const OPTIONAL_META_TAG:String = "Optional";
	private static const EXCLUDE_META_TAG:String = "Without";
	
	private static const skipProperties:Object = {entity: true, prev: true, next: true};
	
	// cached data, shared between aspect observers
	private static var propertyMapByType:Dictionary = new Dictionary();
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
				if ( skipProperties[propertyName] ) {
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
	}
}
}
