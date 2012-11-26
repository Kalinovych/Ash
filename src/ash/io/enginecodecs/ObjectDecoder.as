package ash.io.enginecodecs
{
	import ash.core.Engine;
	import ash.core.Entity;
	import ash.io.objectcodecs.CodecManager;
	import ash.io.objectcodecs.IObjectCodec;
	import flash.utils.getDefinitionByName;

	internal class ObjectDecoder
	{
		private var codecManager : CodecManager;
		private var componentMap : Array;

		public function ObjectDecoder( codecManager : CodecManager )
		{
			this.codecManager = codecManager;
			componentMap = new Array();
		}

		public function reset() : void
		{
		}

		public function decodeEngine( encodedData : Object, engine : Engine ) : void
		{
			for each ( var encodedComponent : Object in encodedData.components )
			{
				decodeComponent( encodedComponent );
			}

			for each ( var encodedEntity : Object in encodedData.entities )
			{
				engine.addEntity( decodeEntity( encodedEntity ) );
			}
		}

		private function decodeEntity( encodedEntity : Object ) : Entity
		{
			var entity : Entity = new Entity();
			if ( encodedEntity.hasOwnProperty( "name" ) )
			{
				entity.name = encodedEntity.name;
			}
			for each ( var componentId : int in encodedEntity.components )
			{
				if ( componentMap.hasOwnProperty( componentId ) )
				{
					entity.add( componentMap[componentId] );
				}
			}
			return entity;
		}

		private function decodeComponent( encodedComponent : Object ) : void
		{
			var codec : IObjectCodec = codecManager.getCodecForComponent( getDefinitionByName( encodedComponent.type ) );
			if( codec )
			{
				componentMap[encodedComponent.id] = codecManager.decodeComponent( encodedComponent );
			}
		}
	}
}