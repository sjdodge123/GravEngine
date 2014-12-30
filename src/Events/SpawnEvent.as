package Events
{
	import flash.events.Event;
	public class SpawnEvent extends Event
	{
		public static const BALL:String = "ball";
		public var params:Object
		
		public function SpawnEvent(type:String,params:Object,bubbles:Boolean = false,cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			this.params = params;
		}
		public override function clone():Event
		{
			return new SpawnEvent(type, this.params, bubbles, cancelable);
		}
		public override function toString():String
		{
			return formatToString("CustomEvent", "params", "type", "bubbles", "cancelable");
		}
	}
}