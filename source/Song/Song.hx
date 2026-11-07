package song;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Assets;

class Song extends FlxSprite
{
	public static inline var W = 175;
	public static inline var H = 325;

	static inline var COVER = 150;

	public var data(get, null):SongData;

	public function new(name:String)
	{
		super();
		var d = new SongData(name);
		this.data = d;

		// unique=true: stamp() ghi vào bitmap, không được share cache giữa các Song
		makeGraphic(W, H, FlxColor.GRAY, true);

		var cover = new FlxSprite();
		var coverPath = 'assets/songs/$name/$name.jpg';
		if (Assets.exists(coverPath))
			cover.loadGraphic(coverPath);
		else
			cover.makeGraphic(COVER, COVER, FlxColor.fromRGB(70, 70, 110));
		stamp(cover, Std.int((W - COVER) / 2), 30);

		var label = new FlxText(0, 0, W - 10, '${d.name}\n${d.artist}', 18);
		label.alignment = CENTER;
		stamp(label, 5, 200);
	}

	public function get_data():SongData
	{
		return this.data;
	}
}