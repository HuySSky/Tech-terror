package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

/** Placeholder. */
class ResultState extends FlxState
{
	override public function create():Void
	{
		super.create();
		var t = new FlxText(0, 0, FlxG.width, "RESULT (placeholder)\nEnter / Esc / Space: Menu", 28);
		t.alignment = CENTER;
		t.screenCenter(Y);
		add(t);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([ENTER, ESCAPE, SPACE])) FlxG.switchState(MenuState.new);
	}
}
