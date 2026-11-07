package state;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import song.*;

class MenuState extends FlxState
{
	static var numberOfSong:Int = 0;

	static var difficulties = ["easy", "medium", "hard"];

	var scrollLine:SongScrollLine;
	var infoText:FlxText;
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

		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT)
		{
			selected = Std.int(FlxMath.bound(selected + (FlxG.keys.justPressed.RIGHT ? 1 : -1), 0, numberOfSong - 1));
			refresh();
		}
		else if (FlxG.keys.justPressed.TAB)
		{
			diff = (diff + 1) % difficulties.length;
			refresh();
		}
		else if (FlxG.keys.justPressed.ENTER) FlxG.switchState(PlayState.new);
		else if (FlxG.keys.justPressed.SEVEN) FlxG.switchState(EditorState.new);
		else if (FlxG.keys.justPressed.ESCAPE) FlxG.switchState(LoadingState.new);
	}

	function refresh()
	{
		var selectedDifficulty = difficulties[diff];
		var selectedSongData = scrollLine.get(selected).data;
		scrollLine.select(selected);
		infoText.text = '${selectedSongData.name}\n${selectedSongData.artist}\nBPM: ${selectedSongData.bpm}\nDifficulty: ${selectedDifficulty.toUpperCase()}';
	}
}