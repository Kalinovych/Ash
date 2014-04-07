/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine {
import ash.core.ProcessorList;
import ash.engine.api.IComponentProcessor;
import ash.engine.api.IEngineComponentHandler;
import ash.engine.api.IEnginePostUpdateHandler;
import ash.engine.api.IEnginePreUpdateHandler;
import ash.engine.api.IEngineProcess;
import ash.engine.api.IEngineUpdateHandler;
import ash.engine.api.IEntityProcessor;

public class ECSEngine {

	private var mEntityProcessorList:ProcessorList;
	private var mComponentProcessorList:ProcessorList;
	private var mEnginePreUpdateHandlerList:ProcessorList;
	private var mEngineUpdateHandlerList:ProcessorList;
	private var mEnginePostUpdateHandlerList:ProcessorList;
	
	
	private var mThreads:Array;
	private var mComponents:Array;
	
	public function ECSEngine() {
	}

	public function addComponentHandler( handler:IEngineComponentHandler ):void {
		
	}

	public function addProcess(process:IEngineProcess, priority:int):void {
		if (process is IEntityProcessor) mEntityProcessorList.add(process, priority);
		if (process is IComponentProcessor) mComponentProcessorList.add(process, priority);
		if (process is IEnginePreUpdateHandler) mEnginePreUpdateHandlerList.add(process, priority);
		if (process is IEngineUpdateHandler) mEngineUpdateHandlerList.add(process, priority);
		if (process is IEnginePostUpdateHandler) mEnginePostUpdateHandlerList.add(process, priority);

		process.addedToEngine( this );
	}
}
}
