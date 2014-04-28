/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine {
import ashx.engine.aspects.AspectsManager;

import flash.sampler.getMasterString;

use namespace ecse;

public class AEngine extends EEngine {
	
	ecse var mAspectsManager:AspectsManager;
	
	public function AEngine() {
		super();
		
		mAspectsManager = new AspectsManager();
	}
}
}
