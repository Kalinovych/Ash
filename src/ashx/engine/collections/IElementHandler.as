/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.collections {
public interface IElementHandler {
	function handleElementAdded( element:* ):void;
	function handleElementRemoved( element:* ):void;
}
}
