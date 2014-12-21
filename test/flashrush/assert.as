/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package flashrush {
public function assert( ...rest ):AssertMatcher {
	return matcher.forValues( rest );
}
}

import org.hamcrest.assertThat;
import org.hamcrest.core.not;
import org.hamcrest.object.IsNullMatcher;
import org.hamcrest.object.nullValue;

const matcher:AssertMatcher = new AssertMatcher();

class AssertMatcher {
	private var _values:Array;
	
	internal function forValues( values:Array ):AssertMatcher {
		_values = values;
		return this;
	}
	
	public function get isTrue():AssertMatcher {
		assertThat( _values[0], org.hamcrest.object.isTrue() );
		return this;
	}
	
	public function get isNull():Boolean {
		assertThat( _values[0], nullValue() );
		return true;
	}
	
	public function get isNotNull():AssertMatcher {
		assertThat( _values[0], not( new IsNullMatcher() ) );
		return this;
	}
	
	public function instanceOf( type:Class ):AssertMatcher {
		assertThat( _values[0], org.hamcrest.object.instanceOf(type));
		return this;
	}
	
}