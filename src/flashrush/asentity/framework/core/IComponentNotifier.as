/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.core {
public interface IComponentNotifier {
	function addObserver( componentType:Class, observer:IComponentObserver ):void;

	function removeObserver( componentType:Class, observer:IComponentObserver ):void;
}
}
