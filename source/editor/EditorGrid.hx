package editor;

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

	public var totalBars:Int = 1;

	var bpm:Float;
	var beatsPerMeasure:Int;
	var lines:Array<String>;
	var subBeat:Float;
	var columnsPerBar:Int;
	var currentBar:Int = 0;

	public function new(initialBpm:Float, initialBeatsPerMeasure:Int, lines:Array<String>, subBeat:Float)
	{
		super();
		this.lines = lines;
		this.subBeat = subBeat;
		rebuild(initialBpm, initialBeatsPerMeasure);
	}

	public function rebuild(newBpm:Float, newBeatsPerMeasure:Int):Void
	{
		bpm = newBpm;
		beatsPerMeasure = newBeatsPerMeasure;
		columnsPerBar = Std.int(beatsPerMeasure / subBeat);

		for (m in members.copy())
		{
			remove(m, true);
			m.destroy();
		}

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
		}
	}

	public function changeBar(amount:Int):Void
	{
		currentBar = Std.int(FlxMath.bound(currentBar + amount, 0, totalBars - 1));
		rebuild(bpm, beatsPerMeasure);
	}

	public function getCurrentBar():Int
	{
		return currentBar;
	}
}