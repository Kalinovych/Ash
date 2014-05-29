/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.extensions.aspects {
public interface IAspectManager {
	function getAspects( aspectClass:Class ):AspectList;
}
}
