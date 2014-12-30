package GameBoard.Objects
{
	import flash.display.Sprite;
	import flash.utils.Timer;
	import GameBoard.PhysicsModels.PhysicsModel;

	public class Ball extends GameObject
	{
		private var circle:Sprite;
		private var moon:Moon;
		private var freeToMove:Boolean = true;
		private var radius:int = 10;
		private var ballAlive:Boolean = true;
		public var timer:Timer;
		
		public function Ball(x:int,y:int,moon:Moon)
		{
			this.x = x;
			this.y = y;
			this.moon = moon;
			physics = new PhysicsModel(x,y,moon);
			circle = new Sprite();
			circle.graphics.lineStyle(1,0x000000);
			circle.graphics.drawCircle(0,0,radius);
			addChild(circle);
		}
		
		public override function  update():void
		{
			physics.update();
		}
		
		public function killBall():void
		{
			ballAlive = false;
			if(this.contains(circle))
			{
				removeChild(circle);
			}
			
		}
		
		public function checkMovement(canMove:Boolean):void
		{
			if(ballAlive)
			{
				var pos:Vector.<Number> = new Vector.<Number>;
				pos = physics.checkMovement(canMove);
				this.x = pos[0];
				this.y = pos[1];
			}
			
		}
	}
}