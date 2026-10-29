package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

/** Placeholder. */
class PlayState extends FlxState
{
	override public function create():Void
	{
		super.create();
		var t = new FlxText(0, 0, FlxG.width, "PLAY (placeholder)\nEnter: Result | 7: Editor | Esc: Menu", 28);
		t.alignment = CENTER;
		t.screenCenter(Y);
		add(t);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ENTER) FlxG.switchState(ResultState.new);
		else if (FlxG.keys.justPressed.SEVEN) FlxG.switchState(EditorState.new);
		else if (FlxG.keys.justPressed.ESCAPE) FlxG.switchState(MenuState.new);
	}
}
