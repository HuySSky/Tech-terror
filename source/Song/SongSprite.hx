package song;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class SongSprite extends FlxSprite
{
	public static inline var W = 175;
	public static inline var H = 325;

	public var data:SongData;

	public function new(data:SongData)
	{
		super();
		this.data = data;
		makeGraphic(W, H, FlxColor.GRAY);
	}
}