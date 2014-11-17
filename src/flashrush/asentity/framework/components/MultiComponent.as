/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.components {
import flashrush.asentity.framework.api.asentity;

/**
 * Interface for multi-component implementation
 */
public class MultiComponent {
	asentity var prev:MultiComponent;
	asentity var next:MultiComponent;
}
}
