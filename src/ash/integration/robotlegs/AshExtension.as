package ash.integration.robotlegs
{
import ash.core.Engine;
import ash.integration.swiftsuspenders.SwiftSuspendersEngine;

import com.genome2d.context.IContext;

/**
	 * A Robotlegs extension to enable the use of Ash inside a Robotlegs project. This
	 * wraps the SwiftSuspenders integration, passing the Robotlegs context's injector to
	 * the engine for injecting into systems.
	 */
	public class AshExtension implements IExtension
	{
		private const _uid : String = UID.create( AshExtension );

		public function extend( context : IContext ) : void
		{
			context.injector.map( Engine ).toValue( new SwiftSuspendersEngine( context.injector ) );
		}

		public function toString() : String
		{
			return _uid;
		}
	}
}
