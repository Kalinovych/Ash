/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.framework {
import ashx.engine.api.ecse;

import flash.utils.Dictionary;

use namespace ecse;

public class ContextBase {
	ecse var extensions:Dictionary = new Dictionary();
	ecse var sharedInstances:Dictionary = new Dictionary();

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

	public function share( instance:* ):* {
		sharedInstances[instance.constructor] = instance;
	}

	public function getShared( instanceType:Class ):* {
		return sharedInstances[instanceType];
	}

	public function unshare( instanceType:Class ):* {
		return sharedInstances[instanceType];
	}
}
}
