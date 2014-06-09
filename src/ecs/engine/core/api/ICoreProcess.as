/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core.api {
import ecs.lists.IOrdered;
import ecs.lists.api.INode;

public interface ICoreProcess extends INode, IOrdered {
	function tick():void;
}
}
