/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine {
import ecs.framework.api.ecsf;

import flash.utils.Dictionary;

use namespace ecsf;

public class ContextBase {
	ecsf var extensions:Dictionary = new Dictionary();
	ecsf var sharedInstances:Dictionary = new Dictionary();

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
