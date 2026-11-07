package song;

import haxe.Json;
import openfl.Assets;

class SongData
{
	public var name:String;
	public var artist:String;
	public var bpm:Float;
	public var timeSignature:String;
	public var previewStart:Float;
	public var scrollSpeed:Map<String, Float>;

	public function new(name:String)
	{
		var rawJson = Assets.getText("assets/songs/" + name + "_data.json");
		var json = Json.parse(rawJson);

		this.name = json.name;
		this.artist = json.artist;
		this.bpm = json.bpm;
		this.timeSignature = json.timeSignature;
		this.previewStart = json.previewStart;

		this.scrollSpeed = new Map<String, Float>();
		for (key in Reflect.fields(json.scrollSpeed))
			this.scrollSpeed.set(key, Reflect.field(json.scrollSpeed, key));
	}

}