/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush.asentity.framework.systems {
import flashrush.asentity.framework.api.asentity;
import flashrush.asentity.framework.systems.api.ISystemHandler;
import flashrush.collections.LinkedSet;
import flashrush.collections.fast.core.LinkedNode;

use namespace asentity;

public class SystemManager {
	private var _first:System;
	private var _last:System;
	private var _numSystems:uint;
	
	private var _handlers:LinkedSet = new LinkedSet();
	
	public function SystemManager() {
	}
	
	public function get numSystems():uint {return _numSystems;}
	
	public function get first():System {return _first;}
	
	public function get last():System {return _last;}
	
	public function add( system:System, order:int = 0 ):SystemManager {
		if (system == null) {
			throw new TypeError( "Parameter system must be non-null." );
		}
		
		if (system.manager) {
			throw ArgumentError( "The system " + system + " already added to a manager" );
		}
		
		++_numSystems;
		system.manager = this;
		system.order = order;
		link( system );
		for ( var handlerNode:LinkedNode = _handlers.firstNode; handlerNode; handlerNode = handlerNode.next ) {
			const handler:ISystemHandler = handlerNode.item;
			handler.onSystemAdded( system );
		}
		system.onAdded();
		return this;
	}
	
	public function remove( system:System ):void {
		if (system == null) {
			throw new TypeError( "Parameter system must be non-null." );
		}
		
		if (system.manager != this) {
			throw new ArgumentError( "The supplied System must be added to the caller." );
		}
		
		--_numSystems;
		unlink( system );
		for ( var handlerNode:LinkedNode = _handlers.lastNode; handlerNode; handlerNode = handlerNode.prev ) {
			const handler:ISystemHandler = handlerNode.item;
			handler.onSystemRemoved( system );
		}
		system.onRemoved();
		system.manager = null;
	}
	
	public function removeAll():void {
		while ( _first ) {
			const s:System = _first;
			_first = _first.next;
			s.prev = null;
			s.next = null;
			s.manager = null;
		}
		_first = null;
		_last = null;
		_numSystems = 0;
	}
	
	public function registerHandler( handler:ISystemHandler ):void {
		_handlers.add( handler );
	}

//-------------------------------------------
// Private
//-------------------------------------------
	
	private function link( system:System ):void {
		if (!_first) {
			_first = system;
			_last = system;
			system.prev = null;
			system.next = null;
		} else {
			var prev:System = _last;
			while ( prev && prev.order > system.order ) {
				prev = prev.prev;
			}
			
			if (prev) linkAfter( system, prev );
			else linkFirst( system );
		}
	}
	
	private function linkFirst( system:System ):void {
		system.prev = null;
		system.next = _first;
		
		if (_first) _first.prev = system;
		else _last = system;
		
		_first = system;
	}
	
	private function linkAfter( system:System, prev:System ):void {
		system.prev = prev;
		system.next = prev.next;
		
		prev.next = system;
		if (system.next) system.next.prev = system;
		else _last = system;
	}
	
	private function unlink( system:System ):void {
		if (system == _first) _first = system.next;
		if (system == _last) _last = system.prev;
		
		if (system.prev) system.prev.next = system.next;
		if (system.next) system.next.prev = system.prev;
	}
	
}
}
