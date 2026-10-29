package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

/** Placeholder welcome screen. Enter/Space -> Menu. */
class LoadingState extends FlxState
{
	override public function create():Void
	{
		super.create();

		var t = new FlxText(0, 0, FlxG.width, "Press enter to play", 32);
		t.alignment = CENTER;
		t.screenCenter(Y);
		add(t);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([ENTER, SPACE]))
			FlxG.switchState(MenuState.new);
	}
}
