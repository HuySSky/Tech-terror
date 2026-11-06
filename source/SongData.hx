package;

class SongData
{
	public var name:String;
	public var artist:String;
	public var bpm:Float;
	public var timeSignature:Array<Int>;
	public var previewStart:Float;
	public var scrollSpeed:Map<String, Float>;

	public function new() {}

	public static function fromJson(json:Dynamic):SongData
	{
		var d = new SongData();
		d.name = json.name;
		d.artist = json.artist;
		d.bpm = json.bpm;
		d.timeSignature = [Std.int(json.timeSignature[0]), Std.int(json.timeSignature[1])];
		d.previewStart = json.previewStart;

		d.scrollSpeed = new Map<String, Float>();
		for (key in Reflect.fields(json.scrollSpeed))
			d.scrollSpeed.set(key, Reflect.field(json.scrollSpeed, key));

		return d;
	}
}