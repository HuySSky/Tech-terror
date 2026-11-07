package song;

import haxe.Json;
import openfl.Assets;

class SongData
{
	public var name:String;
	public var artist:String;
	public var bpm:Float;
	public var timeSignature:TimeSignature;
	public var previewStart:Float;
	public var scrollSpeed:Map<String, Float>;

	public function new(songName:String)
	{
		load(songName);
	}

	function load(songName:String)
	{
		var json = Json.parse(Assets.getText('assets/songs/$songName/${songName}_data.json'));

		this.name = json.name;
		this.artist = json.artist;
		this.bpm = json.bpm;
		this.timeSignature = new TimeSignature(json.timeSignature);
		this.previewStart = json.previewStart;

		this.scrollSpeed = new Map<String, Float>();
		for (diff in Reflect.fields(json.difficulty))
			this.scrollSpeed.set(diff, Reflect.field(Reflect.field(json.difficulty, diff), "scrollSpeed"));
	}
}