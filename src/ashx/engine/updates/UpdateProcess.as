/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.updates {
import ashx.engine.UEngine;
import ashx.engine.api.*;
import ashx.engine.threadsVersion.IEngineComponent;

public class UpdateProcess implements IEngineProcess, IEngineComponentHandler {
	
	private var engine:UEngine;
	private var updateableList:Vector.<IUpdateable>;
	
	public function UpdateProcess() {
	}
	
	public function addedToEngine( engine:UEngine ):void {
		// get list of IUpdateable
		engine.addComponentHandler( this );
	}

	public function removedFromEngine( engine:UEngine ):void {
		
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