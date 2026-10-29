package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

/** Placeholder. */
class MenuState extends FlxState
{
	override public function create():Void
	{
		super.create();
		var t = new FlxText(0, 0, FlxG.width, "MENU (placeholder)\nEnter: Play | 7: Editor | Esc: Loading", 28);
		t.alignment = CENTER;
		t.screenCenter(Y);
		add(t);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ENTER) FlxG.switchState(PlayState.new);
		else if (FlxG.keys.justPressed.SEVEN) FlxG.switchState(EditorState.new);
		else if (FlxG.keys.justPressed.ESCAPE) FlxG.switchState(LoadingState.new);
	}
}
