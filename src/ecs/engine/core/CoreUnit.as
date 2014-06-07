/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.core {
import ecs.framework.api.ecs_core;

use namespace ecs_core;

public class CoreUnit {
	ecs_core var prev:CoreUnit;
	ecs_core var next:CoreUnit;

	ecs_core function after( prevUnit:CoreUnit ):CoreUnit {
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

	ecs_core function before( nextUnit:CoreUnit ):CoreUnit {
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
