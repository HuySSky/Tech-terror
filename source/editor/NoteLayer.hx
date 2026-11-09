package editor;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.input.mouse.FlxMouseEvent;

class NoteLayer extends FlxTypedSpriteGroup<NoteEntity>
{
    // 1. Data
    public var currentBar(default, set):Int = 0;
	public var beatsPerMeasure:Int = 4;

    // Hover state
	public var lastHovered(default, null):Null<NoteEntity> = null;

    public function new() { 
        super(); 
    }

    override public function update(elapsed:Float)
    {
		super.update(elapsed);

    }

    override public function add(note: NoteEntity):NoteEntity
    {
		FlxMouseEvent.add(note, null, null, onNoteHover, onNoteOut);
        return super.add(note);
    }

	public function findAt(line:String, absBeat:Float, eps:Float):Null<NoteEntity>
	{
		for (i in 0...length)
		{
			var note = members[i];
			if (note.line == line && Math.abs(note.absBeat - absBeat) < eps)
				return note;
		}
		return null;
	}

	public function removeNote(note:NoteEntity):Void
	{
		if (lastHovered == note)
			lastHovered = null;
		FlxMouseEvent.remove(note);
		remove(note, true);
		note.destroy();
		refreshVisuals();
	}

    function onNoteHover(note: NoteEntity):Void {
		lastHovered = note;
    }

    function onNoteOut(note: NoteEntity):Void {
		if (lastHovered == note)
			lastHovered = null;
    }

    // // 4. Logic Xóa theo Line
    // public function clearLine(line:String):Void {
    //     // Duyệt ngược mảng entities. Nếu note.line == line thì xóa/destroy.
    // }

	// 5. Logic Render (QUAN TRỌNG NHẤT)
	public function refreshVisuals():Void
	{
		for (note in members)
		{
			note.visible = note.getBar(beatsPerMeasure) == currentBar;
		}
	}

    // // 7. Getter cho Save
    // public function getAll():Array<NoteEntity> {
    //     return entities;
    // }

    public function set_currentBar(value:Int):Int {
        this.currentBar = value;
		refreshVisuals();
        return this.currentBar;
    }
}