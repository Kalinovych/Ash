/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine {
import ecs.framework.api.ecs_core;

import flash.utils.Dictionary;

use namespace ecs_core;

public class ContextBase {
	ecs_core var extensions:Dictionary = new Dictionary();
	ecs_core var sharedInstances:Dictionary = new Dictionary();

	public function install( ...extensions ):void {
		for each( var ext:* in extensions ) {
			var type:Class = (ext is Class ? ext : ext.constructor );
			if ( extensions[type] ) {
				continue;
			}
			if ( ext is Class ) {
				ext = new ext();
			}
			extensions[type] = ext;
			ext.extend( this );
		}
	}

	public function share( object:* ):* {
		sharedInstances[object.constructor] = object;
	}

	public function getShared( objectType:Class ):* {
		return sharedInstances[objectType];
	}

	public function unshare( object:* ):* {
		var objectType:Class = ( object is Class ? object : object.constructor );
		object = sharedInstances[objectType];
		delete sharedInstances[objectType];
		return object;
	}
}
}
