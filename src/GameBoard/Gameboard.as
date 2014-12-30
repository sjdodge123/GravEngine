package GameBoard
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import Engines.CollisionEngine;
	import GameBoard.Objects.Arrow;
	import GameBoard.Objects.Ball;
	import GameBoard.Objects.Moon;
	import GameBoard.Objects.ObjectSpawner;
	import GameBoard.PhysicsModels.ObjectPhysics;

	public class Gameboard extends Sprite
	{
		private var moon:Moon;
		private var balls:Vector.<Ball>;
		private var arrow:Arrow;
		private var mouseX:int = 0;
		private var mouseY:int = 0;
		private var newMouseX:int = 0;
		private var newMouseY:int = 0;
		private var op:ObjectPhysics;
		private var ce:CollisionEngine;
		private var totalLifeTime:int = 20;
		private var hoseSpawnTime:Number = 500;
		private var mouseIsDown:Boolean = false;
		private var permaSpawn:Boolean = false;
		private var spawnNewBall:Timer;
		public function Gameboard(stage:Stage)
		{
			arrow = new Arrow(0,0);
			balls = new Vector.<Ball>;
			spawnNewBall = new Timer(hoseSpawnTime);
			spawnNewBall.addEventListener(TimerEvent.TIMER,spawnTimerExp);
			op = new ObjectPhysics;
			stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP,leftClick);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyPressed);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,mouseDown);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,rightClick);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,moveMouse);
			moon = new Moon(stage.stageWidth/2,stage.stageHeight/2);
			ce = new CollisionEngine(balls,moon);
			addChild(moon);
		}
		
		protected function keyPressed(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.SPACE)
			{
				clearScreen();		
			}
			
		}		
		
		private function clearScreen():void
		{
			if(numChildren > 0)
			{
				removeChildren(0,this.numChildren-1);
			}
			spawnNewBall.reset();
			permaSpawn = false;
			addChild(moon);
			
		}
		
		
		protected function moveMouse(event:MouseEvent):void
		{
			if(mouseIsDown)
			{
				newMouseX = event.stageX;
				newMouseY = event.stageY;
				arrow.update(newMouseX-mouseX,newMouseY-mouseY);
			}
		}
		
		public function update():void
		{
			for(var i:int=0;i<balls.length;i++)
			{
				balls[i].update();
				balls[i].checkMovement(ce.checkCollide(balls[i]));
			}
			
		}
		
		protected function mouseDown(event:MouseEvent):void
		{
			mouseIsDown = true;
			mouseX = event.stageX;
			mouseY = event.stageY;
			newMouseX = mouseX;
			newMouseY = mouseY;
			arrow = new Arrow(event.stageX,event.stageY);
			spawnNewBall.reset();
			permaSpawn = false;
			addChild(arrow);
		}
		
		protected function rightClick(event:MouseEvent):void
		{
			mouseIsDown = false;
			var math1:Vector.<Number> = new Vector.<Number>;
			var math2:Vector.<Number> = new Vector.<Number>;
			math1[0] = newMouseX - mouseX;
			math1[1] = newMouseY - mouseY;
			math2[0] = 0;
			math2[1] = 1;
			var mag1:Number = Math.sqrt(Math.pow(math1[0],2) + Math.pow(math1[1],2));
			var angle:Number = Math.acos((math1[0]*math2[0]+math1[1]*math2[1])/(mag1)) * 180/Math.PI;
			if(mouseX>newMouseX)
			{
				angle = -angle;
			}
			permaSpawn = true;
			spawnBall();
			spawnNewBall.start();
			var spawner:ObjectSpawner = new ObjectSpawner(mouseX,mouseY,angle);
			addChild(spawner);
		}
		
		protected function leftClick(event:MouseEvent):void
		{
			mouseIsDown = false;
			spawnBall();
		}		
		
		
		protected function spawnTimerExp(event:TimerEvent):void
		{
			if(permaSpawn)
			{
				spawnBall();
			}
			else
			{
				spawnNewBall.reset();
			}
		}
		
		protected function spawnBall():void
		{
			var ball:Ball = new Ball(mouseX,mouseY,moon);
			var lifeTimer:Timer = new Timer(1000*totalLifeTime);
			lifeTimer.start();
			lifeTimer.addEventListener(TimerEvent.TIMER,killBall);
			ball.timer = lifeTimer;
			calcVel(ball);
			balls.push(ball);
			addChild(ball);
			if(contains(arrow))
			{
				removeChild(arrow);
			}
		}
		
		protected function killBall(event:TimerEvent):void
		{
			for(var i:int=0;i<balls.length;i++)
			{
				if(event.target == balls[i].timer)
				{
					balls[i].killBall();
					balls.splice(i,1);
				}
			}
		}		
	
		
		private function calcVel(ball:Ball):void
		{
			calcDist(newMouseX,newMouseY,mouseX,mouseY);
			if(op.dist != 0)
			{
				op.velocityDirX = op.distX/op.dist;
				op.velocityDirY = op.distY/op.dist;
				ball.physics.op.velX  = .025 * op.dist * op.velocityDirX;
				ball.physics.op.velY  = .025 * op.dist * op.velocityDirY;
			}
		}
		
		protected function calcDist(x1:int,y1:int,x2:int,y2:int):void
		{
			op.distX = x1 - x2;
			op.distY = y1 - y2;
			op.dist = Math.sqrt(Math.pow(op.distX,2)+Math.pow(op.distY,2));
		}
	}
}