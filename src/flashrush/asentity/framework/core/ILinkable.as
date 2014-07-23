/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.core {
public interface ILinkable {
	function after( prev:ILinkable ):ILinkable;

	function before( next:ILinkable ):ILinkable;

	function detach():void;
}
}
