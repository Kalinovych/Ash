/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine {
import flash.utils.Dictionary;

import flashrush.asentity.framework.api.asentity;

use namespace asentity;

public class ContextBase {
	asentity var extensions:Dictionary = new Dictionary();
	asentity var sharedInstances:Dictionary = new Dictionary();

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
