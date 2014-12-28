package GameBoard
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import GameBoard.PhysicsModels.ObjectPhysics;
	import GameBoard.Objects.Ball;
	import GameBoard.Objects.Arrow;
	import GameBoard.Objects.Moon;

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
		public function Gameboard(stage:Stage)
		{
			arrow = new Arrow(0,0);
			balls = new Vector.<Ball>;
			op = new ObjectPhysics;
			stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP,releaseClick);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,moveMouse);
			moon = new Moon(stage.stageWidth/2,stage.stageHeight/2);
			addChild(moon);
			
		}
		
		protected function moveMouse(event:MouseEvent):void
		{
			newMouseX = event.stageX;
			newMouseY = event.stageY;
			arrow.update(newMouseX-mouseX,newMouseY-mouseY);
		}
		
		public function update():void
		{
			for(var i:int=0;i<balls.length;i++)
			{
				balls[i].update();
			}
		}
		
		protected function mouseDown(event:MouseEvent):void
		{
			mouseX = event.stageX;
			mouseY = event.stageY;
			newMouseX = mouseX;
			newMouseY = mouseY;
			arrow = new Arrow(event.stageX,event.stageY);
			addChild(arrow);
		}
		protected function releaseClick(event:MouseEvent):void
		{
			var ball:Ball = new Ball(mouseX,mouseY,moon);
			calcVel(ball);
			balls.push(ball);
			addChild(ball);
			removeChild(arrow);
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