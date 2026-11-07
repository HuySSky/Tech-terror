package;

import flixel.FlxGame;
import openfl.display.Sprite;
import state.LoadingState;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(1280, 768, LoadingState));
	}
}