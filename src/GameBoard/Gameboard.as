package GameBoard
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import Engines.CollisionEngine;
	
	import Events.SpawnEvent;
	
	import GameBoard.Objects.Arrow;
	import GameBoard.Objects.Ball;
	import GameBoard.Objects.Moon;
	import GameBoard.Objects.ObjectSpawner;
	import GameBoard.PhysicsModels.ObjectPhysics;

	public class Gameboard extends Sprite
	{
		private var moon:Moon;
		private var balls:Vector.<Ball>;
		private var spawners:Vector.<ObjectSpawner>;
		private var arrow:Arrow;
		private var mouseX:int = 0;
		private var mouseY:int = 0;
		private var newMouseX:int = 0;
		private var newMouseY:int = 0;
		private var op:ObjectPhysics;
		private var ce:CollisionEngine;
		private var totalLifeTime:int = 20;
		private var mouseIsDown:Boolean = false;
		private var spawnContainer:Sprite = new Sprite();
		public function Gameboard(stage:Stage)
		{
			arrow = new Arrow(0,0);
			balls = new Vector.<Ball>;
			spawners = new Vector.<ObjectSpawner>;
			
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
			//addChild(spawnContainer);
			//spawnContainer.addEventListener(SpawnEvent.BALL,spawnBall,true);
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
			balls = new Vector.<Ball>;
			for(var i:int =0; i<spawners.length;i++)
			{
				spawners[i].removeEventListener(SpawnEvent.BALL,spawnBall);
			}
			spawners = new Vector.<ObjectSpawner>;
			moon = new Moon(stage.stageWidth/2,stage.stageHeight/2);
			ce = new CollisionEngine(balls,moon);
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
			for(var j:int=0;j<spawners.length;j++)
			{
				spawners[j].update();
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
			var spawner:ObjectSpawner = new ObjectSpawner(mouseX,mouseY,newMouseX,newMouseY,angle);
			spawner.addEventListener(SpawnEvent.BALL,spawnBall);
			spawners.push(spawner);
			addChild(spawner);
			if(contains(arrow))
			{
				removeChild(arrow);
			}
		}
		
		protected function leftClick(event:MouseEvent):void
		{
			mouseIsDown = false;
			var spawnLoc:Array = new Array();
			spawnLoc[0] = mouseX;
			spawnLoc[1] = mouseY;
			spawnLoc[2] = newMouseX;
			spawnLoc[3] = newMouseY;
			spawnBall(new SpawnEvent(SpawnEvent.BALL,spawnLoc));
			if(contains(arrow))
			{
				removeChild(arrow);
			}
		}		
		
		protected function spawnBall(event:SpawnEvent):void
		{
			var ball:Ball;
			ball = new Ball(event.params[0],event.params[1],moon);
			var lifeTimer:Timer = new Timer(1000*totalLifeTime);
			lifeTimer.start();
			lifeTimer.addEventListener(TimerEvent.TIMER,killBall);
			ball.timer = lifeTimer;
			calcVel(event,ball);
			balls.push(ball);
			addChildAt(ball,0);
			
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
	
		
		private function calcVel(event:SpawnEvent,ball:Ball):void
		{
			calcDist(event.params[2],event.params[3],event.params[0],event.params[1]);
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