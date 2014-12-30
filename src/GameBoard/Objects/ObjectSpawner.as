package GameBoard.Objects
{
	import flash.display.Sprite;

	public class ObjectSpawner extends GameObject
	{
		private var box:Sprite;
		private var spout:Sprite;
		public function ObjectSpawner(x:int,y:int,z:int)
		{
			
			spout = new Sprite();
			spout.rotationZ = -z; 
			spout.graphics.lineStyle(.5,0x000000);
			spout.graphics.drawRect(-17.5,0,35,35);
			addChild(spout);
			
			this.x = x;
			this.y = y;
			box = new Sprite();
			box.rotationZ = -z;
			box.graphics.beginFill(0xFFFFFF);
			box.graphics.lineStyle(1,0x000000);
			box.graphics.drawRect(-25,-25,50,50);
			box.graphics.endFill();
			addChild(box);
			
		
			
		}
		
		public override function update():void
		{
			
		}
	}
}