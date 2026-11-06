package;

import haxe.Json;
import openfl.Assets;

class SongLoader
{
	public static function loadAll():Array<SongData>
	{
		var result:Array<SongData> = [];
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

			var path = 'assets/songs/$songName/${songName}_data.json';
			try
			{
				var data = SongData.fromJson(Json.parse(Assets.getText(path)));
				result.push(data);
				trace('[SongLoader] OK: ${data.name} | bpm=${data.bpm}');
			}
			catch (e:Dynamic)
			{
				trace('[SongLoader] WARN: failed to load $path: $e');
			}
		}
		return result;
	}
}