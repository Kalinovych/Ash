/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core {
import ecs.engine.core.ESUnit;
import ecs.framework.api.ecs_core;
import ecs.lists.IOrdered;
import ecs.lists.api.INode;

public class ProcessUnit extends ESUnit implements INode, IOrdered {
	ecs_core var order:int;
	
	public function ProcessUnit() {
	}

	public function get order():int {
		return ecs_core::order;
	}
}
}
