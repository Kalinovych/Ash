/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.componentEngine {
import ash.engine.api.IComponentProcessor;

public class ComponentEngine {
	private var mComponents:Vector.<*>;
	private var mProcessors:Vector.<IComponentProcessor>;

	public function ComponentEngine() {
	}

	public function add( component:*, typeId:* = null ):void {
		// add cp to list
		// get typeId processors and pass cp to componentAdded
	}
	
	public function registerProcessor(typeId:*, processor:IComponentProcessor):void {
		
	}
}
}
