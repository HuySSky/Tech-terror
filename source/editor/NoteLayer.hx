package editor;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.input.mouse.FlxMouseEvent;

class NoteLayer extends FlxTypedSpriteGroup<NoteEntity>
{
    // 1. Data
    public var currentBar(default, set):Int = 0;
    
    // Hover state
    var lastHovered:NoteEntity = null;

    public function new() { 
        super(); 
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);


    }

    override public function add(note: NoteEntity):NoteEntity
    {
        FlxMouseEvent.add(note, toggle, null, onNoteHover, onNoteOut);
        return super.add(note);
    }

    // 3. Logic Toggle (Xóa)
    function toggle(note: NoteEntity):Void {
        // Tìm note có cùng line và absBeat (sai số epsilon = grid.subBeat * 0.1)
        // Nếu có: remove khỏi entities, remove khỏi group, destroy()
        // Nếu không: tạo new NoteEntity, gán line/absBeat, add vào entities, add vào group
        // Cuối cùng: gọi refreshVisuals()
    }

    function onNoteHover(note: NoteEntity):Void {
        // Gọi onHover.dispatch(note)
    }

    function onNoteOut(note: NoteEntity):Void {
        // Gọi onHoverEnd.dispatch()
    }

    // // 4. Logic Xóa theo Line
    // public function clearLine(line:String):Void {
    //     // Duyệt ngược mảng entities. Nếu note.line == line thì xóa/destroy.
    // }

    // // 5. Logic Render (QUAN TRỌNG NHẤT)
    // public function refreshVisuals():Void {
    //     // Duyệt mảng entities:
    //     // 1. Lấy lineIdx = grid.getLineIndex(n.line). Nếu -1 -> ẩn.
    //     // 2. Tính beatInBar = n.absBeat - (grid.currentBar * grid.beatsPerMeasure)
    //     // 3. Nếu beatInBar < 0 hoặc >= grid.beatsPerMeasure -> ẩn (visible = false)
    //     // 4. Nếu hợp lệ: visible = true.
    //     //    - n.x = grid.gridX + (beatInBar / grid.beatsPerMeasure) * grid.gridW
    //     //    - n.y = grid.rowY + (lineIdx * grid.rowPitch) + 2
    //     //    - n.setGraphicSize(Std.int(grid.getNoteWidth()), Std.int(grid.rowH - 4));
    // }

    // // 6. Logic Hover
    // override public function update(elapsed:Float):Void {
    //     super.update(elapsed);
    //     // Nếu mouse.justMoved hoặc justPressed:
    //     // Tìm xem chuột có overlaps với entity nào đang visible không.
    //     // Nếu hovered != lastHovered:
    //     //   - Nếu lastHovered != null -> onHoverEnd.dispatch()
    //     //   - Nếu hovered != null -> onHover.dispatch(hovered)
    //     //   - Gán lastHovered = hovered
    // }

    // // 7. Getter cho Save
    // public function getAll():Array<NoteEntity> {
    //     return entities;
    // }

    public function set_currentBar(value:Int):Int {
        this.currentBar = value;
        // refreshVisuals();
        return this.currentBar;
    }
}