/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentHandlerMap.api {
public interface IComponentHandlerMap {
	function map( componentType:Class ):IComponentHandlerMapper;
	
	function unmap( componentType:Class ):IComponentHandlerUnmapper;
}
}
