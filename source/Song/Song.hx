package song;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Song extends FlxSprite
{
	public static inline var W = 175;
	public static inline var H = 325;

	public var data(get, null):SongData;

	public function new(name:String)
	{
		super();
		// Initialize with default or loaded data based on name
		this.data = new SongData(name);

		makeGraphic(W, H, FlxColor.GRAY);
	}

	public function get_data():SongData
	{
		return this.data;
	}
}