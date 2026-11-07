package song;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import openfl.Assets;

class SongScrollLine extends FlxTypedSpriteGroup<Song>
{
	static inline var GAP = 50;

	public function new()
	{
		super();
		var songs = loadAll();
		for (i => name in songs)
		{
			var song = new Song(name);
			song.setPosition(i * (Song.W + GAP), FlxG.height / 4 - Song.H / 2);
			add(song);
		}
	}

	/** Scale the selected sprite to 1.2 and shift the whole line so it is centered on screen. */
	public function select(index:Int)
	{
		for (i => s in members)
			s.scale.set(i == index ? 1.2 : 1, i == index ? 1.2 : 1);
		x = FlxG.width / 2 - (index * (Song.W + GAP) + Song.W / 2);
	}

	public function get(index:Int):Song
	{
		return members[index];
	}

	private function loadAll():Array<String>
	{
		var result:Array<String> = [];
		var listText = Assets.getText("assets/songs/songs.txt");

		if (listText == null)
		{
			trace("[SongLoader] WARN: missing songs.txt");
			return result;
		}

		for (line in listText.split("\n"))
		{
			var songName = StringTools.trim(line);
			if (songName == "")
				continue;

			result.push(songName);
		}
		return result;
	}
}