/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.core {
public interface IComponentNotifier {
	function addComponentHandler( observer:IComponentObserver, componentType:Class ):void;

	function removeComponentHandler( observer:IComponentObserver, componentType:Class ):void;
}
}
