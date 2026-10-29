package;

import flixel.FlxG;
import flixel.util.FlxSave;

/** Global settings, persisted between game launches. */
class Config
{
	static var save:FlxSave;
	static var loaded:Bool = false;

	/** Safe to call many times; only the first call loads. */
	public static function load():Void
	{
		if (loaded)
			return;
		loaded = true;
		save = new FlxSave();
		save.bind("TechTerrorConfig");
		if (save.data.volume != null)
			FlxG.sound.volume = save.data.volume;
	}

	public static function setVolume(v:Float):Void
	{
		v = Math.max(0, Math.min(1, v));
		FlxG.sound.volume = v;
		if (save != null)
		{
			save.data.volume = v;
			save.flush();
		}
	}
}
