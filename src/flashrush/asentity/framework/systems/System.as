/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems {
import flashrush.asentity.extensions.aspects.Aspect;
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.systems.api.ISystem;

public/* abstract */class System implements ISystem {
	
	public function System() {}
	
	public function initialize():void {}
	
	public function onAdded():void {}
	
	public function onEnable():void {}
	
	public function update( delta:Number ):void {}
	
	public function onDisable():void {}
	
	public function onRemoved():void {}
	
	public function destroy():void {}
	
	//-------------------------------------------
	// Internals
	//-------------------------------------------
	
	asentity var priority:int = 0;
	
	
	
	
	// v2 design idea
	
	public namespace callback;
	
	[AspectHandler(Aspect1,Aspect2)]
	callback function onAspectAdded( aspect:Aspect ):void {
		
	}
	
	/*
		Engine callbacks under namespace
	 */
	
	protected namespace event;
	
	/**
	 * Once initialize the system
	 */
	event function onInitialize():void {}
	
	/**
	 * The system just added to a space. Space property contains the reference to the space.
	 */
	event function onAddedToSpace():void {}
	
	/**
	 * Called right after onAddedToSpace or when system becomes enabled if it was disabled before.
	 */
	event function onEnable():void {}
	
	/**
	 * 
	 */
	//public function update( deltaTime:Number ):void {}
	
	/**
	 * Called right before onRemovedFromSpace or when system becomes disabled.
	 */
	event function onDisable():void {}
	
	/**
	 * The system removed from space. The reference to the space stay accessible within the function call.
	 */
	event function onRemovedFromSpace():void {}
}
}
