package state;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import song.SongData;

/** Placeholder. */
class EditorState extends FlxState
{
	var songData:SongData;
	var difficulty:String;

	public function new(songData:SongData, difficulty:String)
	{
		super();
		this.songData = songData;
		this.difficulty = difficulty;
	}

	override public function create():Void
	{
		super.create();
		var t = new FlxText(0, 0, FlxG.width, "EDITOR (placeholder)\nEsc: Menu", 28);
		t.alignment = CENTER;
		t.screenCenter(Y);
		add(t);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ESCAPE) FlxG.switchState(MenuState.new);
	}
}