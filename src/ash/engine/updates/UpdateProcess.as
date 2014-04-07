/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.updates {
import ash.core.Engine;
import ash.engine.ECSEngine;
import ash.engine.api.*;
import ash.engine.threadsVersion.IEngineComponent;

public class UpdateProcess implements IEngineProcess, IEngineComponentHandler {
	
	private var engine:ECSEngine;
	private var updateableList:Vector.<IUpdateable>;
	
	public function UpdateProcess() {
	}
	
	public function addedToEngine( engine:ECSEngine ):void {
		// get list of IUpdateable
		engine.addComponentHandler( this );
	}

	public function removedFromEngine( engine:ECSEngine ):void {
		
	}

	public function update( deltaTime:Number ):void {
		for each(var updateable:IUpdateable in updateableList) {
			updateable.update( deltaTime );
		}
	}

	public function handleAddedEngineComponent( component:IEngineComponent ):void {
	}

	public function handleRemovedEngineComponent( component:IEngineComponent ):void {
	}
}
}
