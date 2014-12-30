package Engines
{
	import GameBoard.Objects.Ball;
	import GameBoard.Objects.Moon;
	import GameBoard.PhysicsModels.ObjectPhysics;
	import GameBoard.Objects.GameObject;

	public class CollisionEngine
	{
		public var op:ObjectPhysics;
		private var balls:Vector.<Ball>;
		private var moon:Moon;
		public function CollisionEngine(balls:Vector.<Ball>,moon:Moon)
		{
			op = new ObjectPhysics();
			this.moon = moon;
			this.balls = balls;
		}
		
		public function checkMoonCollide(other:Ball):Boolean
		{
			op.dist = Math.sqrt(Math.pow(moon.x-other.physics.op.newX,2) + Math.pow(moon.y-other.physics.op.newY,2));
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
		
		public function checkCollide(ball:Ball):Boolean
		{
			var canMove:Boolean = true;
			canMove = checkMoonCollide(ball);
			if(!canMove)
			{
				return false;
			}
			checkBallCollide(ball);
			return true;
		}
		
		private function checkBallCollide(ball:Ball):void
		{
			
			for(var i:int=0;i<balls.length;i++)
			{
				if(balls[i] != ball)
				{
					var thisBall:Ball = ball;
					var otherBall:Ball = balls[i];
					var dist1:Number = Math.sqrt(Math.pow(otherBall.x-thisBall.physics.op.newX,2) + Math.pow(otherBall.y-thisBall.physics.op.newY,2));
					var dist2:Number = Math.sqrt(Math.pow(otherBall.x-thisBall.x,2) + Math.pow(otherBall.y-thisBall.y,2));
					if(dist2 <= 30 && dist1 <=20)
					{
						moveReactively(thisBall,otherBall,1);
					}
				}
			}
		}
		
		private function moveReactively(thisBall:GameObject,otherObject:GameObject, deltaT:Number):void
		{
			var normal:Vector.<Number> = new Vector.<Number>;
			normal[0] = thisBall.x - otherObject.x;
			normal[1] = thisBall.y - otherObject.y;
			
			var normalMag:Number = Math.sqrt(Math.pow(normal[0],2)+Math.pow(normal[1],2));
			normal[0] = normal[0]/normalMag;
			normal[1] = normal[1]/normalMag;
			
			var tangent:Vector.<Number> = new Vector.<Number>;
			tangent[0] = normal[1];
			tangent[1] = -normal[0];
			
			var theta:Number = Math.acos((thisBall.physics.op.velocityDirX*tangent[0] + thisBall.physics.op.velocityDirY*tangent[1]));
			var alpha:Number = 2*theta;
			
			var velInitial:Vector.<Number> = new Vector.<Number>;
			velInitial[0] = thisBall.physics.op.velX;
			velInitial[1] = thisBall.physics.op.velY;
			
			var velInitial2:Vector.<Number> = new Vector.<Number>;
			velInitial2[0] = otherObject.physics.op.velX;
			velInitial2[1] = otherObject.physics.op.velY;
			
			
			thisBall.physics.op.velX = 0.7*(velInitial[0]*Math.cos(alpha) - velInitial[1]*Math.sin(alpha));
			thisBall.physics.op.velY = 0.7*(velInitial[0]*Math.sin(alpha) + velInitial[1]*Math.cos(alpha));
			
			otherObject.physics.op.velX = 0.7*(velInitial2[0]*Math.cos(alpha) - velInitial2[1]*Math.sin(alpha));
			otherObject.physics.op.velY = 0.7*(velInitial2[0]*Math.sin(alpha) + velInitial2[1]*Math.cos(alpha));

			predictBounce(deltaT,thisBall);
		}
		private function predictBounce(deltaT:Number,thisBall:GameObject):void
		{
			thisBall.physics.op.newX = thisBall.x + thisBall.physics.op.velX*deltaT;
			thisBall.physics.op.newY = thisBall.y + thisBall.physics.op.velY+deltaT;
		}		
		
		
	}
}