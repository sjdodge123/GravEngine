package Engines
{
	import GameBoard.Objects.Ball;
	import GameBoard.Objects.GameObject;
	import GameBoard.Objects.Moon;
	import GameBoard.PhysicsModels.ObjectPhysics;

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
			var c:Vector.<Number> = new Vector.<Number>;
			c[0] = otherObject.x - thisBall.x;
			c[1] = otherObject.y - thisBall.y;
			
			var cMag:Number = Math.sqrt(Math.pow(c[0],2)+Math.pow(c[1],2));
			c[0] = c[0]/cMag;
			c[1] = c[1]/cMag;
			
			var normal:Vector.<Number> = new Vector.<Number>;
			normal[0] = -c[1];
			normal[1] = c[0];
			
			var thisVelB:Vector.<Number> = new Vector.<Number>;
			var dotProd1N:Number = thisBall.physics.op.velX*normal[0]+thisBall.physics.op.velY*normal[1];
			thisVelB[0] = normal[0]*dotProd1N;
			thisVelB[1] = normal[1]*dotProd1N;
			
			var thisVelA:Vector.<Number> = new Vector.<Number>;
			var dotProd1C:Number = thisBall.physics.op.velX*c[0]+thisBall.physics.op.velY*c[1];
			thisVelA[0] = c[0]*dotProd1C;
			thisVelA[1] = c[1]*dotProd1C;
			
			var otherVelB:Vector.<Number> = new Vector.<Number>;
			var dotProd2N:Number = otherObject.physics.op.velX*normal[0]+otherObject.physics.op.velY*normal[1];
			otherVelB[0] = normal[0]*dotProd2N;
			otherVelB[1] = normal[1]*dotProd2N;
			
			
			var otherVelA:Vector.<Number> = new Vector.<Number>;
			var dotProd2C:Number = otherObject.physics.op.velX*c[0]+otherObject.physics.op.velY*c[1];
			otherVelA[0] = c[0]*dotProd2C;
			otherVelA[1] = c[1]*dotProd2C;
			
			thisBall.physics.op.velX = thisVelB[0] + otherVelA[0];
			thisBall.physics.op.velY = thisVelB[1] + otherVelA[1];
			
			otherObject.physics.op.velX = thisVelA[0] + otherVelB[0];
			otherObject.physics.op.velY = thisVelA[1] + otherVelB[1];

			predictBounce(deltaT,thisBall);
			predictBounce(deltaT,otherObject);
		}
		
		private function dotProduct(a:Vector.<Number>,b:Vector.<Number>):Number
		{
			return a[0]*b[0] + a[1]*b[1];
		}
		
		
		private function predictBounce(deltaT:Number,thisBall:GameObject):void
		{
			thisBall.physics.op.newX = thisBall.x + thisBall.physics.op.velX*deltaT;
			thisBall.physics.op.newY = thisBall.y + thisBall.physics.op.velY+deltaT;
		}		
		
		
	}
}