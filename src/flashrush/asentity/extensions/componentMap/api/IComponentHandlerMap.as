/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentMap.api {
public interface IComponentHandlerMap {
	function map( componentType:Class ):IComponentHandlerMapper;
	
	function unmap( componentType:Class ):IComponentHandlerUnmapper;
	
	function unmapAll():void;
}
}
