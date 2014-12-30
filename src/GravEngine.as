package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import GameBoard.Gameboard;

	[SWF(backgroundColor= "0xFFFFFF", width="1920", height ="1080", frameRate='60')]
	public class GravEngine extends Sprite
	{
		private var gameBoard:Gameboard;
		
		
		public function GravEngine()
		{
			gameBoard = new Gameboard(stage);
			addChild(gameBoard);
			stage.addEventListener(Event.ENTER_FRAME,update);
		}
		
		protected function update(event:Event):void
		{
			gameBoard.update();		
		}
	}
}