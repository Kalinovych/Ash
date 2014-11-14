/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.core {
public interface IComponentNotifier {
	function addComponentHandler( componentType:Class, observer:IComponentObserver ):void;

	function removeComponentHandler( componentType:Class, observer:IComponentObserver ):void;
}
}
