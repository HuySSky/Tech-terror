package song;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class SongScrollLine extends FlxTypedSpriteGroup<SongSprite>
{
	static inline var GAP = 50;

	public function new(songs:Array<SongData>)
	{
		super();
		for (i => d in songs)
		{
			var s = new SongSprite(d);
			s.setPosition(i * (SongSprite.W + GAP), FlxG.height / 4 - SongSprite.H / 2);
			add(s);
		}
	}

	/** Scale the selected sprite to 1.2 and shift the whole line so it is centered on screen. */
	public function select(index:Int)
	{
		for (i => s in members)
			s.scale.set(i == index ? 1.2 : 1, i == index ? 1.2 : 1);
		x = FlxG.width / 2 - (index * (SongSprite.W + GAP) + SongSprite.W / 2);
	}
}