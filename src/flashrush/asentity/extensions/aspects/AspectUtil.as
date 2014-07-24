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

	// cached data, shared between aspect observers
	private static var propertyMapByNode:Dictionary = new Dictionary();
	private static var componentInterestsByNode:Dictionary = new Dictionary();
	private static var excludedComponentsByNode:Dictionary = new Dictionary();
	private static var optionalComponentsByNode:Dictionary = new Dictionary();

	public static function describeAspect( type:Class, observer:AspectObserver ):void {
		var propertyMap:Dictionary = propertyMapByNode[type];
		var componentInterests:Vector.<Class> = componentInterestsByNode[type];
		var excludedComponents:Dictionary = excludedComponentsByNode[type];
		var optionalComponents:Dictionary = optionalComponentsByNode[type];

		if ( !propertyMap ) {
			propertyMap = new Dictionary();
			propertyMapByNode[type] = propertyMap;

			componentInterests = new Vector.<Class>();
			componentInterestsByNode[type] = componentInterests;

			var typeInfo:Object = DescribeTypeJSONCached.describeType( type, INCLUDE_VARIABLES | INCLUDE_METADATA | INCLUDE_TRAITS | USE_ITRAITS | HIDE_OBJECT );
			var propList:Array = [];
			if ( typeInfo.traits.variables ) {
				propList.push.apply( null, typeInfo.traits.variables );
			}

			// parse properties
			for ( var i:int = 0, len:int = propList.length; i < len; i++ ) {
				var property:Object = propList[i];
				var propertyName:String = property.name;
				if ( propertyName == "entity" || propertyName == "prev" || propertyName == "next" ) {
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
									excludedComponentsByNode[type] = excludedComponents;
								}
								excludedComponents[componentClass] = propertyName;
								break componentMapping;
							} else if ( metaName == OPTIONAL_META_TAG ) {
								if ( !optionalComponents ) {
									optionalComponents = new Dictionary();
									optionalComponentsByNode[type] = optionalComponents;
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