/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine {
import ashx.engine.api.IEngineTickHandler;
import ashx.engine.lists.AnyElementIterator;
import ashx.engine.lists.LinkedSet;
import ashx.engine.threadsVersion.ISystemThread;
import ashx.engine.updates.IUpdateable;

public class UpdateThread implements IEngineTickHandler,ISystemThread {
	private var mUpdateableList:LinkedSet;
	private var mIterator:AnyElementIterator;
	
	public var deltaTime:Number = 1.0;
	public var timeScale:Number = 1.0;

	public function UpdateThread() {
		mUpdateableList = new LinkedSet();
		mIterator = new AnyElementIterator( mUpdateableList );
	}

	public function tick():void {
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
