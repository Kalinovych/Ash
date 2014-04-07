/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */

package ash.engine.threadsVersion {
import ash.core.ProcessorList;
import ash.engine.api.IComponentProcessor;
import ash.engine.api.IEngineComponentHandler;
import ash.engine.api.IEnginePostUpdateHandler;
import ash.engine.api.IEnginePreUpdateHandler;
import ash.engine.api.IEngineUpdateHandler;
import ash.engine.api.IEntityProcessor;

public class ECSEngine {

	private var mEntityProcessorList:ProcessorList;
	private var mComponentProcessorList:ProcessorList;
	private var mEnginePreUpdateHandlerList:ProcessorList;
	private var mEngineUpdateHandlerList:ProcessorList;
	private var mEnginePostUpdateHandlerList:ProcessorList;


	private var mComponents:Vector.<IEngineComponent>;
	private var mThreads:Vector.<IEngineThread>;
	private var mComponentThreads:Vector.<IComponentThread>;

	public function ECSEngine() {
	}

	public function addThread( thread:IEngineThread, priority:int ):void {
		mThreads.push( thread );
		
		if (thread is IComponentThread) {
			mComponentThreads.push( thread );
		}
		
		/*
		if (thread is IEngineComponent) {
			mComponents.push( thread );
		}
		*/
	}
	
	public function addComponent( component:IEngineComponent ):void {
		
	}
}
}
