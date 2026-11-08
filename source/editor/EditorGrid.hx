package editor;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class EditorGrid extends FlxTypedSpriteGroup<FlxSprite>
{
	static inline var ROW_Y = 400;
	static inline var ROW_H = 50;
	static inline var ROW_PITCH = 70;
	static inline var SPRITE_X = 60;
	static inline var SPRITE_SIZE = 40;
	static inline var GRID_X = 130;
	static inline var GRID_W = 1100;
	static inline var EPSILON = 0.01;

	public var totalBars:Int;
	public var notes:Map<String, Array<Float>> = new Map();
	public var subBeat:Float = 0.25;
	public var currentBar(default, set):Int = 0;

	var beatsPerMeasure:Int;
	var lines:Array<String>;
	var columnsPerBar:Int;
	var cells:Array<Array<FlxSprite>> = [];

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
		for (l in lines)
			notes.set(l, []);

		var colW:Float = GRID_W / columnsPerBar;
		var beatCols = Std.int(1 / subBeat);

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

			var icon = new FlxSprite(SPRITE_X, y + (ROW_H - SPRITE_SIZE) / 2).makeGraphic(SPRITE_SIZE, SPRITE_SIZE, FlxColor.GRAY, true);
			icon.drawRect(4, 4, SPRITE_SIZE - 8, SPRITE_SIZE - 8, 0xFFE8E8E8);
			add(icon);

			var row = new FlxSprite(GRID_X, y).makeGraphic(GRID_W, ROW_H, FlxColor.GRAY, true);
			row.drawRect(2, 2, GRID_W - 4, ROW_H - 4, FlxColor.WHITE);
			for (c in 1...columnsPerBar)
			{
				if (c % beatCols == 0)
					row.drawRect(c * colW - 1, 0, 2, ROW_H, 0xFF404040);
				else
					row.drawRect(c * colW, 2, 1, ROW_H - 4, 0xFFAAAAAA);
			}
			row.drawRect(0, 0, 4, ROW_H, FlxColor.BLACK);
			add(row);
			var rowCells:Array<FlxSprite> = [];
			for (c in 0...columnsPerBar)
			{
				var note = new FlxSprite(GRID_X + c * colW + 2, y + 2).makeGraphic(Std.int(colW) - 4, ROW_H - 4, FlxColor.RED);
				note.visible = false;
				add(note);
				rowCells.push(note);
			}
			cells.push(rowCells);
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (!FlxG.mouse.justPressed)
			return;

		var mx = FlxG.mouse.x;
		var my = FlxG.mouse.y;
		if (mx < GRID_X || mx >= GRID_X + GRID_W || my < ROW_Y || my >= ROW_Y + lines.length * ROW_PITCH)
			return;

		var row = Std.int((my - ROW_Y) / ROW_PITCH);
		if ((my - ROW_Y) - row * ROW_PITCH >= ROW_H)
			return;
		var col = Std.int((mx - GRID_X) / (GRID_W / columnsPerBar));

		var absoluteTime = (currentBar * beatsPerMeasure) + (col * subBeat);
		var list = notes.get(lines[row]);
		var existing = Lambda.find(list, t -> Math.abs(t - absoluteTime) < EPSILON);
		if (existing != null)
			list.remove(existing);
		else
			list.push(absoluteTime);
		cells[row][col].visible = existing == null;
	}

	function set_currentBar(value:Int):Int
	{
		currentBar = Std.int(FlxMath.bound(value, 0, totalBars - 1));

		for (r in 0...lines.length)
		{
			for (cell in cells[r])
				cell.visible = false;
			for (t in notes.get(lines[r]))
			{
				var col = Math.round((t - currentBar * beatsPerMeasure) / subBeat);
				if (col >= 0 && col < columnsPerBar)
					cells[r][col].visible = true;
			}
		}
		return currentBar;
	}
}