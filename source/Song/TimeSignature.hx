package song;

class TimeSignature
{
	public var name:String;
	public var id:Int;
	public var beatsPerMeasure:Int;
	public var strongBeats:Array<Int>;
	public var mediumBeats:Array<Int>;

	public function new(signature:String)
	{
		var parts = signature.split("/");
		var numerator = Std.parseInt(parts[0]);
		var denominator = Std.parseInt(parts[1]);

		name = signature;
		id = numerator * 100 + denominator;
		beatsPerMeasure = numerator;
		strongBeats = [0];
		mediumBeats = numerator % 2 == 0 ? [Std.int(numerator / 2)] : [];
	}
}