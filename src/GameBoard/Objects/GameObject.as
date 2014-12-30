package GameBoard.Objects
{
	import flash.display.Sprite;
	import GameBoard.PhysicsModels.PhysicsModel;

	public class GameObject extends Sprite
	{
		public var physics:PhysicsModel;
		public function GameObject()
		{
			
		}
		
		public function update():void
		{
			physics.update();
		}
	}
}