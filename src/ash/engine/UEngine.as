/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine {
import ash.engine.api.IEngineTickHandler;

public class UEngine extends EEngine {
	private var mTickHandlers:Vector.<IEngineTickHandler>;

	public function UEngine() {
		mTickHandlers = new <IEngineTickHandler>[];
		configure( mTickHandlers );
	}

	protected function configure( engineTickHandlers:Vector.<IEngineTickHandler> ):void {

	}

	public function tick():void {
		for ( var i:int = 0, len:int = mTickHandlers.length; i < len; i++ ) {
			mTickHandlers[i].tick();
		}
	}

	/*public function addTickHandler( handler:IEngineTickHandler ):void {
		mTickHandlers[mTickHandlers.length] = handler;
	}*/

}
}
