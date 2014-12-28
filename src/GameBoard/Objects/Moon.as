package GameBoard.Objects
{
	import flash.display.Sprite;

	public class Moon extends Sprite
	{
		public var radius:int = 50;
		private var circle:Sprite;
		public function Moon(x:int,y:int)
		{
			this.x = x;
			this.y = y;
			circle = new Sprite();
			circle.graphics.lineStyle(1,0x000000);
			circle.graphics.drawCircle(0,0,radius);
			addChild(circle);
		}
		
		
		public function getGravityConst():Number
		{
			return 5400;
		}
	}
}