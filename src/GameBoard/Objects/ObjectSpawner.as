package GameBoard.Objects
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import Events.SpawnEvent;

	public class ObjectSpawner extends GameObject
	{
		private var box:Sprite;
		private var spout:Sprite;
		private var spawnNewBall:Timer;
		private var hoseSpawnTime:Number = 500;
		private var newX:int= 0;
		private var newY:int =0;
		
		public function ObjectSpawner(x:int,y:int,newX:int,newY:int,z:int)
		{
			spout = new Sprite();
			spout.rotationZ = -z; 
			spout.graphics.lineStyle(.5,0x000000);
			spout.graphics.drawRect(-17.5,0,35,35);
			addChild(spout);
			
			this.x = x;
			this.y = y;
			this.newX = newX;
			this.newY = newY;
			box = new Sprite();
			box.rotationZ = -z;
			box.graphics.beginFill(0xFFFFFF);
			box.graphics.lineStyle(1,0x000000);
			box.graphics.drawRect(-25,-25,50,50);
			box.graphics.endFill();
			addChild(box);
			
			spawnNewBall = new Timer(hoseSpawnTime);
			spawnNewBall.addEventListener(TimerEvent.TIMER,spawnTimerExp);
			spawnNewBall.start();
		}
		
		protected function spawnTimerExp(event:TimerEvent):void
		{
			var spawnLoc:Array = new Array();
			spawnLoc[0] = x;
			spawnLoc[1] = y;
			spawnLoc[2] = newX;
			spawnLoc[3] = newY;
			dispatchEvent(new SpawnEvent(SpawnEvent.BALL,spawnLoc));			
		}		
		
		
		public override function update():void
		{
			
		}
		
	}
}