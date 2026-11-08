package editor;

import flixel.FlxSprite;

class NoteEntity extends FlxSprite {
    public var line:String;       // line tạo ra nó (immutable)
    public var absBeat:Float;     // vị trí tuyệt đối, source of truth
	public var offsetMs:Float = 0; // ms, default 0

	public function new()
	{
		super();
	}

	public function getBar(beatsPerMeasure:Int):Int
		return Std.int(absBeat / beatsPerMeasure);

	public function getStepBeat(beatsPerMeasure:Int):Float
		return absBeat - getBar(beatsPerMeasure) * beatsPerMeasure;
}