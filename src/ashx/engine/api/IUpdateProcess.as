/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.api {
public interface IUpdateProcess extends IProcess {
	function update( deltaTime:Number ):void;
}
}
