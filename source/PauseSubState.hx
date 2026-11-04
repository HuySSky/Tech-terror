package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

/** Stub. Real UI (resume/restart/volume) comes in M8. */
class PauseSubState extends FlxSubState
{
	public function new()
	{
		super(0x99000000);
	}

	override public function create():Void
	{
		super.create();
		var t = new FlxText(0, 0, FlxG.width, "PAUSE (stub)\nEsc: Resume", 28);
		t.alignment = CENTER;
		t.screenCenter(Y);
		add(t);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ESCAPE)
			close();
	}
}