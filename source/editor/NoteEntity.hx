package editor;

import flixel.FlxSprite;

class NoteEntity extends FlxSprite {
    public var line:String;       // line tạo ra nó (immutable)
    public var absBeat:Float;     // vị trí tuyệt đối, source of truth
    public var offset:Float = 0;  // ms, default 0

    public function getBar(bpm:Int):Int
        return Std.int(absBeat / bpm);
    public function getStepBeat(bpm:Int):Float
        return absBeat - getBar(bpm) * bpm;
}