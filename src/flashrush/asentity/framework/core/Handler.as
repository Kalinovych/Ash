/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.core {
public class Handler {
	public var target:*;
	public var prev:Handler;
	public var next:Handler;

	public function Handler( target:* ) {
		this.target = target;
	}

	public function after( prev:Handler ):Handler {
		if ( this.prev ) {
			this.prev.next = null;
		}
		this.prev = prev;
		if ( prev ) {
			if ( prev.next ) {
				this.next = prev.next;
				this.next.prev = this;
			}
			prev.next = this;
		}
		return this;
	}

	public function before( next:Handler ):Handler {
		if ( this.next ) {
			this.next.prev = null;
		}
		this.next = next;
		if ( next ) {
			if ( next.prev ) {
				this.prev = next.prev;
				this.prev.next = this;
			}
			next.prev = this;
		}
		return this;
	}

	public function detach():void {
		prev && ( prev.next = next );
		next && ( next.prev = prev );
		prev = null;
		next = null;
	}

	public function dispose():void {
		detach();
		target = null;
	}
}
}