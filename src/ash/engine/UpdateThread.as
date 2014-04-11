/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine {
import ash.engine.api.IEngineTickHandler;
import ash.engine.lists.AnyElementIterator;
import ash.engine.lists.LinkedHashSet;
import ash.engine.threadsVersion.ISystemThread;
import ash.engine.updates.IUpdateable;

public class UpdateThread implements IEngineTickHandler,ISystemThread {
	private var mUpdateableList:LinkedHashSet;
	private var mIterator:AnyElementIterator;

	public var timeScale:Number = 1.0;

	public function UpdateThread() {
		mUpdateableList = new LinkedHashSet();
		mIterator = new AnyElementIterator( mUpdateableList );
	}

	public function tick():void {
		var deltaTime:Number = 1.0;
		while ( mIterator.next() ) {
			var process:IUpdateable = mIterator.current;
			process.update( deltaTime * timeScale );
		}
	}

	/**
	 * @private
	 */
	public function onSystemAdded( process:* ):void {
		mUpdateableList.add( process );
	}


	/**
	 * @private
	 */
	public function onSystemRemoved( process:* ):void {
		mUpdateableList.remove( process );
	}
}
}
