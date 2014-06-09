/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core {
import ecs.framework.api.ecs_core;
import ecs.lists.api.INode;

use namespace ecs_core;

public class ESUnit implements INode {
	ecs_core var prev:ESUnit;
	ecs_core var next:ESUnit;

	ecs_core function after( prevUnit:ESUnit ):ESUnit {
		if ( this.prev ) {
			this.prev.next = null;
		}
		
		this.prev = prevUnit;
		
		if ( prevUnit ) {
			if ( prevUnit.next ) {
				this.next = prevUnit.next;
				this.next.prev = this;
			}
			prevUnit.next = this;
		}
		return this;
	}

	ecs_core function before( nextUnit:ESUnit ):ESUnit {
		if ( this.next ) {
			this.next.prev = null;
		}
		
		this.next = nextUnit;
		
		if ( nextUnit ) {
			if ( nextUnit.prev ) {
				this.prev = nextUnit.prev;
				this.prev.next = this;
			}
			nextUnit.prev = this;
		}
		return this;
	}

	ecs_core function detach():void {
		if ( prev ) {
			prev.next = next;
		}

		if ( next ) {
			next.prev = prev;
		}

		//this.prev = null;
		//this.next = null;
	}
}
}
