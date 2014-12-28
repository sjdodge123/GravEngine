package Engines
{
	import GameBoard.PhysicsModels.ObjectPhysics;
	import GameBoard.PhysicsModels.BallPhysics;
	import GameBoard.Objects.Moon;

	public class CollisionEngine
	{
		public var op:ObjectPhysics;

		public function CollisionEngine()
		{
			op = new ObjectPhysics();
		}
		
		public function checkMove(moon:Moon, other:BallPhysics):Boolean
		{
			// If collison occurs return false; else return true;
			op.dist = Math.sqrt(Math.pow(moon.x-other.op.newX,2) + Math.pow(moon.y-other.op.newY,2));
			var dist:Number = Math.sqrt(Math.pow(moon.x-other.x,2) + Math.pow(moon.y-other.y,2));
			if(op.dist <= moon.radius+10 && dist <= moon.radius+30)
			{
				return false;
			}
			else
			{
				return true;
			}
			
		}
	}
}