package state;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import song.*;

class MenuState extends FlxState
{
	static var difficulties = ["easy", "medium", "hard"];

	var scrollLine:SongScrollLine;
	var infoText:FlxText;
	var numberOfSong:Int;
	var songData:SongData;
	var difficulty:String;
	var selected = 0;
	var diff = 0;

	override public function create():Void
	{
		super.create();

		scrollLine = new SongScrollLine();
		add(scrollLine);

		numberOfSong = scrollLine.members.length;

		add(new FlxSprite(0, FlxG.height / 2).makeGraphic(FlxG.width, Std.int(FlxG.height / 2), 0xFF202020));
		infoText = new FlxText(20, FlxG.height / 2 + 20, FlxG.width - 40, "", 24);
		add(infoText);

		refresh();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustPressed([LEFT, RIGHT]))
		{
			selected = Std.int(FlxMath.bound(selected + (FlxG.keys.justPressed.RIGHT ? 1 : -1), 0, numberOfSong - 1));
			refresh();
		}
		else if (FlxG.keys.justPressed.TAB)
		{
			diff = (diff + 1) % difficulties.length;
			refresh();
		}
		else if (FlxG.keys.justPressed.ENTER)
			open(PlayState.new);
		else if (FlxG.keys.justPressed.SEVEN)
			open(EditorState.new);
		else if (FlxG.keys.justPressed.ESCAPE) FlxG.switchState(LoadingState.new);
	}

	function open(next:(SongData, String) -> FlxState)
	{
		// capture local: state này bị destroy trước khi state mới được tạo
		var s = songData;
		var d = difficulty;
		FlxG.switchState(() -> next(s, d));
	}

	function refresh()
	{
		songData = scrollLine.get(selected).data;
		difficulty = difficulties[diff];
		scrollLine.select(selected);
		var sec = Std.int(songData.duration);
		var duration = Std.int(sec / 60) + ":" + StringTools.lpad(Std.string(sec % 60), "0", 2);
		infoText.text = '${songData.name}\n${songData.artist}\nBPM: ${songData.bpm}\nDuration: $duration\nDifficulty: ${difficulty.toUpperCase()}';
	}
}