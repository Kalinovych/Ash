/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.extensions.aspects {
import avmplus.HIDE_OBJECT;
import avmplus.INCLUDE_ACCESSORS;
import avmplus.INCLUDE_METADATA;
import avmplus.INCLUDE_TRAITS;
import avmplus.INCLUDE_VARIABLES;
import avmplus.USE_ITRAITS;

import com.flashrush.utils.DescribeTypeJSONCached;

import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;

use namespace HIDE_OBJECT;

use namespace USE_ITRAITS;

use namespace INCLUDE_TRAITS;

use namespace INCLUDE_METADATA;

use namespace INCLUDE_VARIABLES;

use namespace INCLUDE_ACCESSORS;

public class AspectUtil {
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

			var type:Object = DescribeTypeJSONCached.describeType( type, INCLUDE_VARIABLES | INCLUDE_METADATA | INCLUDE_TRAITS | USE_ITRAITS | HIDE_OBJECT );
			var propList:Array = [];
			if ( type.traits.variables ) {
				propList.push.apply( null, type.traits.variables );
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
							if ( metaName == "Without" ) {
								if ( !excludedComponents ) {
									excludedComponents = new Dictionary();
									excludedComponentsByNode[type] = excludedComponents;
								}
								excludedComponents[componentClass] = propertyName;
								break componentMapping;
							} else if ( metaName == "Optional" ) {
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
