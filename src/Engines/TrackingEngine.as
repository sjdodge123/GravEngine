package Engines
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class TrackingEngine
	{
		private var frames:int;
		private var curTimer:Number;
		private var prevTimer:Number;
		private var gameStage:Stage;
		private var newFrame:int = 0;
		private var newCount:int = 0;
		private var FPSBox:TextField;
		private var countBox:TextField;
		private var displayUpdate:Timer;
		public function TrackingEngine(gameStage:Stage)
		{
			this.gameStage = gameStage;
			buildFPSDisplay();
			buildCountDisplay();
			
			displayUpdate = new Timer(200);
			displayUpdate.addEventListener(TimerEvent.TIMER,updateDisplays);
			displayUpdate.start();
		}
		
		public function update(newCount:int):void
		{
			performFrameTest();
			this.newCount = newCount;
		}
		
		protected function updateDisplays(event:TimerEvent):void
		{
			FPSBox.text ="FPS: " + newFrame.toString();
			countBox.text = "Count: " + newCount.toString();
		}
		
		private function buildFPSDisplay():void
		{
			FPSBox = new TextField();
			FPSBox.x = 100;
			FPSBox.y = 100;
			FPSBox.textColor = 0x000000;
			FPSBox.text = "FPS = 30";
			gameStage.addChild(FPSBox);
		}
		
		private function buildCountDisplay():void
		{
			countBox = new TextField();
			countBox.x = 100;
			countBox.y = 120;
			countBox.textColor = 0x000000;
			countBox.text = "Count: 0";
			gameStage.addChild(countBox);
		}
		
		
		
		private function performFrameTest():void 
		{
			frames++;
			curTimer=getTimer();
			newFrame = (Math.round(frames*1000/(curTimer-prevTimer)));
			prevTimer=curTimer;
			frames=0;
		}
		
		
		
	}
}