/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.components {
/**
 * Design of ComponentManager public interface.
 * 
 * Purpose: provide a single place(facade) that handle space entities components
 * and provide all necessary methods to work with them.
 * 
 * Requirements:
 *  - provide a list of entities containing a component of the concrete type
 *  - provide the ability to subscribe for added/removed components of concrete type.
 *  
 */
public interface IComponentManager {
	
	/**
	 * Returns a list of filtered entities that contains a component of the specified type.
	 */
	function getFamily( type:Class ):*;
	
	/**
	 * 
	 */
	function addObserver( observer:IComponentProcessor, type:Class ):void;
	
}
}
