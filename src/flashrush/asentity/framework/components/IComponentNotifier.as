/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.components {
import flashrush.asentity.framework.core.*;

public interface IComponentNotifier {
	function addComponentProcessor( observer:IComponentProcessor, componentType:Class ):void;

	function removeComponentProcessor( observer:IComponentProcessor, componentType:Class ):void;
}
}
