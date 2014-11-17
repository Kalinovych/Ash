/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.componentProcessorMap {
import flashrush.asentity.framework.components.*;

public class ComponentProcessorMapping {
	
	public var processor:IComponentProcessor;
	
	public function ComponentProcessorMapping( processor:IComponentProcessor ) {
		this.processor = processor;
	}
}
}
