package GameBoard.PhysicsModels
{
	import GameBoard.Objects.Moon;

	public class PhysicsModel
	{
		public var op:ObjectPhysics;
		public var x:int = 0;
		public var y:int= 0;
		private var moon:Moon;
		public function PhysicsModel(x:int, y:int, moon:Moon)
		{
			this.x = x;
			this.y = y;
			this.moon = moon;
			op = new ObjectPhysics();
			op.newX = x;
			op.newY = y;
		}
		
		public function update():void
		{
			calculateGravity();
			updateVelocity(1);
			predictPosition(1);
		}
		public function checkMovement(canMove:Boolean):Vector.<Number>
		{
			if(canMove)
			{
				moveFreely(1);
			}
			else
			{
				moveReactively(1);
				moveFreely(1);
			}
			var pos:Vector.<Number> = new Vector.<Number>;
			pos[0] = x;
			pos[1] = y;
			return pos;
		}
		
		private function moveReactively(deltaT:Number):void
		{
			var normal:Vector.<Number> = new Vector.<Number>;
			normal[0] = this.x - moon.x;
			normal[1] = this.y - moon.y;
			
			var normalMag:Number = Math.sqrt(Math.pow(normal[0],2)+Math.pow(normal[1],2));
			normal[0] = normal[0]/normalMag;
			normal[1] = normal[1]/normalMag;
			
			var tangent:Vector.<Number> = new Vector.<Number>;
			tangent[0] = normal[1];
			tangent[1] = -normal[0];
			
			var theta:Number = Math.acos((op.velocityDirX*tangent[0] + op.velocityDirY*tangent[1]));
			var alpha:Number = 2*theta;
			
			var velInitial:Vector.<Number> = new Vector.<Number>;
			velInitial[0] = op.velX;
			velInitial[1] = op.velY;
			
			
			op.velX = 0.7*(velInitial[0]*Math.cos(alpha) - velInitial[1]*Math.sin(alpha));
			op.velY = 0.7*(velInitial[0]*Math.sin(alpha) + velInitial[1]*Math.cos(alpha));
			
			predictBounce(deltaT);
			
		}
		
		private function predictBounce(deltaT:Number):void
		{
			op.newX = this.x + op.velX*deltaT;
			op.newY = this.y + op.velY+deltaT;
		}
		private function predictPosition(deltaT:Number):void
		{
			op.newX += op.velX*deltaT;
			op.newY += op.velY*deltaT;
			
		}
		
		private function calculateGravity():void
		{
			calcDist(moon);
			if(op.dist>50)
			{
				calcGravAccel(moon);
			}
		}
		
		protected function calcDist(moon:Moon):void
		{
			op.distX = moon.x - this.x;
			op.distY = moon.y - this.y;
			op.dist = Math.sqrt(Math.pow(op.distX,2)+Math.pow(op.distY,2));
		}
		protected function moveFreely(deltaT:Number):void
		{
			this.x = op.newX;
			this.y = op.newY;
		}
		private function updateVelocity(deltaT:Number):void
		{
			if (op.velocity < op.velocityMax)
			{
				op.velX += op.thrustAccelX*deltaT + op.gravAccelX*deltaT;// - .005*op.velX;
				op.velY += op.thrustAccelY*deltaT + op.gravAccelY*deltaT;// - .005*op.velY;
			}
			if (op.velocity > op.velocityMax)
			{
				op.velX += op.thrustAccelX*deltaT + op.gravAccelX*deltaT;// - .025*op.velX;
				op.velY += op.thrustAccelY*deltaT + op.gravAccelY*deltaT;// - .025*op.velY;
			}
			op.velocity = Math.sqrt(Math.pow(op.velX, 2) + Math.pow(op.velY, 2));
			op.velocityDirX = op.velX/op.velocity;
			op.velocityDirY = op.velY/op.velocity;
			op.gravAccelX = 0;
			op.gravAccelY = 0;
			
		}
		private function calcGravAccel(moon:Moon):void
		{
			op.gravAccelContribution = moon.getGravityConst()/Math.pow(op.dist,2);
			op.gravAccelX += op.gravAccelContribution*op.distX/op.dist;
			op.gravAccelY += op.gravAccelContribution*op.distY/op.dist;
		}
	}
}