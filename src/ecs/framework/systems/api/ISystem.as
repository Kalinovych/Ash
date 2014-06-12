/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.framework.systems.api {
public interface ISystem {
	function added():void;

	function removed():void;
}
}
