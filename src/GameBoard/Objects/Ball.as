package GameBoard.Objects
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import GameBoard.PhysicsModels.BallPhysics;

	public class Ball extends Sprite
	{
		private var circle:Sprite;
		
		private var moon:Moon;
		private var freeToMove:Boolean = true;
		public var physics:BallPhysics;
		private var radius:int = 10;
		private var lifeTimer:Timer;
		private var totalLifeTime:int = 20;
		private var ballAlive:Boolean = true;
		
		public function Ball(x:int,y:int,moon:Moon)
		{
			this.x = x;
			this.y = y;
			this.moon = moon;
			lifeTimer = new Timer(1000*totalLifeTime);
			lifeTimer.start();
			lifeTimer.addEventListener(TimerEvent.TIMER,killBall);
			physics = new BallPhysics(x,y,moon);
			circle = new Sprite();
			circle.graphics.lineStyle(1,0x000000);
			circle.graphics.drawCircle(0,0,radius);
			addChild(circle);
		}
		
		protected function killBall(event:TimerEvent):void
		{
			ballAlive = false;
			if(this.contains(circle))
			{
				removeChild(circle);
			}
			
		}
		
		public function update():void
		{
			if(ballAlive)
			{
				var pos:Vector.<Number> = new Vector.<Number>;
				pos = physics.update();
				this.x = pos[0];
				this.y = pos[1];
			}
		}
	}
}