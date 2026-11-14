package editor;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import openfl.Assets;

class Instruments
{
	static inline var FALLBACK_SIZE = 40;

	static var cache:Map<String, FlxGraphic> = new Map();
	static var list:Array<String> = [];

	public static function loadAll():Void
	{
		cache.clear();
		list = [];

		for (line in Assets.getText("assets/images/instruments_name.txt").split("\n"))
		{
			if(line == null) return;
			var name = StringTools.trim(line);
			if (name == "")
				continue;

			list.push(name);
			var path = 'assets/images/$name.jpg';
			if (Assets.exists(path))
				cache.set(name, FlxGraphic.fromBitmapData(Assets.getBitmapData(path), false, 'instrument_$name'));
		}
	}

	public static function names():Array<String>
	{
		return list;
	}

	public static function graphic(name:String):FlxGraphic
	{
		var g = cache.get(name);
		if (g != null)
			return g;

		trace('[Instruments] WARN: missing graphic for "$name"');
		return FlxG.bitmap.create(FALLBACK_SIZE, FALLBACK_SIZE, FlxColor.GRAY, false, "instrument_missing");
	}
}