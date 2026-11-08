package editor;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;

using flixel.util.FlxSpriteUtil;

class EditorPanel extends FlxTypedSpriteGroup<FlxSprite>
{
	static inline var PANEL_X = 90;
	static inline var PANEL_Y = 40;
	static inline var PANEL_W = 900;
	static inline var PANEL_H = 230;
	static inline var ROW_PITCH = 40;
	static inline var VALUE_X = 330;
	static inline var VALUE_W = 140;
	static inline var BTN_DX = 60;

	static var difficulties = ["easy", "medium", "hard"];

	var bpm(default, set):Float;
	var scrollSpeed(default, set):Float;
	var diffIndex(default, set):Int;

	var infoText:FlxText;
	var bpmText:FlxText;
	var scrollText:FlxText;
	var diffText:FlxText;

	var bpmDown:FlxText;
	var bpmUp:FlxText;
	var scrollDown:FlxText;
	var scrollUp:FlxText;
	var diffDown:FlxText;
	var diffUp:FlxText;
	var saveBtn:FlxText;
	var loadBtn:FlxText;

	public function new()
	{
		super();

		var panel = new FlxSprite(PANEL_X, PANEL_Y).makeGraphic(PANEL_W, PANEL_H, 0xFFFFF176, true);
		panel.drawRect(4, 4, PANEL_W - 8, PANEL_H - 8, 0xFF202020);
		add(panel);

		var x = PANEL_X + 20;
		var y = PANEL_Y + 12;

		infoText = label(x, y, 800, "");

		label(x, y + ROW_PITCH, 250, "BPM:");
		bpmDown = label(PANEL_X + VALUE_X - BTN_DX, y + ROW_PITCH, 0, "<");
		bpmText = label(PANEL_X + VALUE_X, y + ROW_PITCH, VALUE_W, "");
		bpmText.alignment = CENTER;
		bpmUp = label(PANEL_X + VALUE_X + VALUE_W + 10, y + ROW_PITCH, 0, ">");

		label(x, y + ROW_PITCH * 2, 250, "ScrollSpeed:");
		scrollDown = label(PANEL_X + VALUE_X - BTN_DX, y + ROW_PITCH * 2, 0, "<");
		scrollText = label(PANEL_X + VALUE_X, y + ROW_PITCH * 2, VALUE_W, "");
		scrollText.alignment = CENTER;
		scrollUp = label(PANEL_X + VALUE_X + VALUE_W + 10, y + ROW_PITCH * 2, 0, ">");

		label(x, y + ROW_PITCH * 3, 250, "Difficulty:");
		diffDown = label(PANEL_X + VALUE_X - BTN_DX, y + ROW_PITCH * 3, 0, "<");
		diffText = label(PANEL_X + VALUE_X, y + ROW_PITCH * 3, VALUE_W, "");
		diffText.alignment = CENTER;
		diffUp = label(PANEL_X + VALUE_X + VALUE_W + 10, y + ROW_PITCH * 3, 0, ">");

		saveBtn = label(x, y + ROW_PITCH * 4, 0, "[ SAVE ]");
		loadBtn = label(x + 160, y + ROW_PITCH * 4, 0, "[ LOAD ]");
	}

	public function init(initialBpm:Float, initialScrollSpeed:Float, initialDiff:String):Void
	{
		bpm = initialBpm;
		scrollSpeed = initialScrollSpeed;
		diffIndex = FlxMath.maxInt(0, difficulties.indexOf(initialDiff));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (!FlxG.mouse.justPressed)
			return;

		if (FlxG.mouse.overlaps(bpmDown))
			bpm -= 1;
		else if (FlxG.mouse.overlaps(bpmUp))
			bpm += 1;
		else if (FlxG.mouse.overlaps(scrollDown))
			scrollSpeed -= 0.1;
		else if (FlxG.mouse.overlaps(scrollUp))
			scrollSpeed += 0.1;
		else if (FlxG.mouse.overlaps(diffDown))
			diffIndex -= 1;
		else if (FlxG.mouse.overlaps(diffUp))
			diffIndex += 1;
		else if (FlxG.mouse.overlaps(saveBtn))
			continue;
		// onSave.dispatch();
		else if (FlxG.mouse.overlaps(loadBtn))
			continue;
		// onLoad.dispatch();
	}

	public function updateInfo(bar:Int, totalBars:Int, beatsPerMeasure:Int):Void
	{
		infoText.text = 'Bar ${bar + 1} / $totalBars  |  Beat 1..$beatsPerMeasure';
	}

	function set_bpm(value:Float):Float
	{
		bpm = Math.max(1, value);
		bpmText.text = Std.string(bpm);
		return bpm;
	}

	function set_scrollSpeed(value:Float):Float
	{
		scrollSpeed = Math.max(0.1, Math.round(value * 10) / 10);
		scrollText.text = Std.string(scrollSpeed);
		return scrollSpeed;
	}

	function set_diffIndex(value:Int):Int
	{
		diffIndex = (value + difficulties.length) % difficulties.length;
		diffText.text = difficulties[diffIndex].toUpperCase();
		return diffIndex;
	}

	function label(x:Float, y:Float, w:Float, text:String):FlxText
	{
		var t = new FlxText(x, y, w, text, 24);
		t.color = FlxColor.WHITE;
		add(t);
		return t;
	}
}