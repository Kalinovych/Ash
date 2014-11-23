/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.extensions.componentMap.api {
import flashrush.asentity.framework.components.IComponentHandler;

public interface IComponentHandlerMapper {
	function toHandler( handler:IComponentHandler ):IComponentHandlerMapping;
}
}
