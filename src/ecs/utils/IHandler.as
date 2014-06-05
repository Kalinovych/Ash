/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.utils {
public interface IHandler {
	function after( prev:IHandler ):IHandler;

	function before( next:IHandler ):IHandler;

	function detach():void;
}
}
