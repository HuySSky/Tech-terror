package state;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import song.SongData;

/** Placeholder. */
class PlayState extends FlxState
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
		var t = new FlxText(0, 0, FlxG.width, "PLAY (placeholder)\nEnter: Result | 7: Editor | P: Pause (temp) | Esc: Menu", 28);
		t.alignment = CENTER;
		t.screenCenter(Y);
		add(t);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ENTER) FlxG.switchState(ResultState.new);
		else if (FlxG.keys.justPressed.SEVEN) FlxG.switchState(() -> new EditorState(songData, difficulty));
		else if (FlxG.keys.anyJustPressed([P, ESCAPE, ENTER, SPACE]))
			openSubState(new PauseSubState());
		else if (FlxG.keys.anyJustPressed([Q, BACKSPACE])) FlxG.switchState(MenuState.new);
	}
}