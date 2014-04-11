/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.threadsVersion {
public interface ISystemThread {
	function onSystemAdded( system:* ):void;

	function onSystemRemoved( system:* ):void;
}
}
