/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ash.engine.threadsVersion {
public interface IProcessThread {
	function handleAddedProcess(process:*):void;
	function handleRemovedProcess(process:*):void;
	
}
}
