package editor;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.input.mouse.FlxMouseEvent;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class EditorGrid extends FlxTypedSpriteGroup<FlxSprite>
{
	static inline var NOTE_H = 0.8;

	public var totalBars:Int;
	public var subBeat:Float = 0.25;
	public var currentBar(default, set):Int = 0;
	public var onIconClick:Int->Void;

	public var beatsPerMeasure(default, set):Int;
	var lines:Array<String>;
	var columnsPerBar:Int;
	var icons:Array<FlxSprite> = [];
	public var noteLayer(default, set):NoteLayer;

	public function new()
	{
		super();
	}

	public function load(beatsPerMeasure:Int, totalBars:Int, lines:Array<String>, subBeat:Float):Void
	{
		this.beatsPerMeasure = beatsPerMeasure;
		this.totalBars = totalBars;
		this.lines = lines;
		this.subBeat = subBeat;
		columnsPerBar = Std.int(beatsPerMeasure / subBeat);

		var colW:Float = GRID_W / columnsPerBar;
		var stepsPerBeat = Std.int(1 / subBeat);

		for (c in 0...columnsPerBar)
		{
			var num = new FlxText(GRID_X + c * colW, ROW_Y - 20, colW, Std.string(c + 1), 12);
			num.color = FlxColor.BLACK;
			num.alignment = CENTER;
			add(num);
		}

		for (r in 0...lines.length)
		{
			var y = ROW_Y + r * ROW_PITCH;

			var icon = new FlxSprite(SPRITE_X, y + (ROW_H - SPRITE_SIZE) / 2);
			applyInstrument(icon, lines[r], SPRITE_SIZE, SPRITE_SIZE);
			FlxMouseEvent.add(icon, null, _ ->
			{
				if (FlxG.state.subState == null)
					onIconClick(r);
			});
			add(icon);
			icons.push(icon);

			for (c in 0...columnsPerBar)
			{
				var cell = new Grid(GRID_X + c * colW, y, columnsPerBar, r, c, (c + 1) % stepsPerBeat == 0, c == 0);
				FlxMouseEvent.add(cell, null, gridOnClick);
				add(cell);
			}
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	function applyInstrument(sprite:FlxSprite, name:String, w:Int, h:Int):Void
	{
		sprite.loadGraphic(Instruments.graphic(name));
		sprite.setGraphicSize(w, h);
		sprite.updateHitbox();
	}

	public function applyRename(row:Int, newName:String):Void
	{
		var oldName = lines[row];
		if (oldName == newName)
			return;

		lines[row] = newName;
		applyInstrument(icons[row], newName, SPRITE_SIZE, SPRITE_SIZE);

		for (note in noteLayer.members)
		{
			if (note.line == oldName)
			{
				note.line = newName;
				applyInstrument(note, newName, Math.round(GRID_W / 32), Math.round(ROW_H * NOTE_H));
			}
		}
		noteLayer.refreshVisuals();
	}

	function gridOnClick(cell:Grid):Void
	{
		if (FlxG.state.subState != null)
			return;

		var row = cell.row;
		var col = cell.col;

		var absoluteTime = currentBar * beatsPerMeasure + col * subBeat;
		var note = noteLayer.recycle(NoteEntity.new);

		note.line = lines[row];
		note.absBeat = absoluteTime;
		applyInstrument(note, lines[row], Math.round(GRID_W / 32), Math.round(ROW_H * NOTE_H));
		note.x = GRID_X + (col + 0.1) * (GRID_W / columnsPerBar);
		note.y = ROW_Y + (row + (1 - NOTE_H) / 2) * ROW_PITCH;

		noteLayer.add(note);

	}

	function set_currentBar(value:Int):Int
	{
		currentBar = Std.int(FlxMath.bound(value, 0, totalBars - 1));
		if (noteLayer != null)
			noteLayer.currentBar = currentBar;
		return currentBar;
	}
	function set_beatsPerMeasure(value:Int):Int
	{
		beatsPerMeasure = value;
		if (noteLayer != null)
			noteLayer.beatsPerMeasure = beatsPerMeasure;
		return beatsPerMeasure;
	}

	function set_noteLayer(value:NoteLayer):NoteLayer
	{
		noteLayer = value;
		noteLayer.beatsPerMeasure = beatsPerMeasure;
		noteLayer.currentBar = currentBar;
		return noteLayer;
	}
}