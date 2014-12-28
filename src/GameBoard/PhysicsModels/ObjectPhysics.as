package GameBoard.PhysicsModels
{
	public class ObjectPhysics
	{
		public var velocity:Number = 0;
		public var velocityMax:Number = 150 ;
		public var velX:Number =0;
		public var velY:Number=0;
		public var velocityDirX:Number=0;
		public var velocityDirY:Number=0;
		public var gravAccelX:Number=0;
		public var gravAccelY:Number=0;
		public var thrustAccelY:Number=0;
		public var thrustAccelX:Number=0;
		public var gravAccelContribution:Number=0;
		public var distX:Number=0;
		public var dist:Number=1;
		public var distY:Number=0;
		public var newX:Number = 0;
		public var newY:Number = 0;
		public function ObjectPhysics()
		{
			
		}
	}
}