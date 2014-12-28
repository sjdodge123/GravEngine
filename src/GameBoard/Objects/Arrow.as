package GameBoard.Objects
{
	import flash.display.Sprite;

	public class Arrow extends Sprite
	{
		private var line:Sprite;
		public function Arrow(x:int,y:int)
		{
			this.x = x;
			this.y = y;
			line = new Sprite();
			line.graphics.lineStyle(1,0x000000);
			addChild(line);
		}
		
		public function update(mouseX:int,mouseY:int):void
		{
			removeChild(line);
			line = new Sprite();
			line.graphics.lineStyle(1,0x000000);
			line.graphics.lineTo(mouseX,mouseY);
			addChild(line);
		}
	}
}