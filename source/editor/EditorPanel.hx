package editor;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

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

	var bpm:Float;
	var scrollSpeed:Float;
	var diffIndex:Int;

	var onChangeBpm:Float->Void;
	var onChangeScroll:Float->Void;
	var onChangeDiff:String->Void;
	var onSave:Void->Void;
	var onLoad:Void->Void;

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

	public function new(initialBpm:Float, initialScrollSpeed:Float, initialDiff:String, onChangeBpm:Float->Void, onChangeScroll:Float->Void,
			onChangeDiff:String->Void, onSave:Void->Void, onLoad:Void->Void)
	{
		super();
		bpm = initialBpm;
		scrollSpeed = initialScrollSpeed;
		diffIndex = Std.int(Math.max(0, difficulties.indexOf(initialDiff)));
		this.onChangeBpm = onChangeBpm;
		this.onChangeScroll = onChangeScroll;
		this.onChangeDiff = onChangeDiff;
		this.onSave = onSave;
		this.onLoad = onLoad;

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

		refreshValues();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (!FlxG.mouse.justPressed)
			return;

		if (FlxG.mouse.overlaps(bpmDown))
			setBpm(bpm - 1);
		else if (FlxG.mouse.overlaps(bpmUp))
			setBpm(bpm + 1);
		else if (FlxG.mouse.overlaps(scrollDown))
			setScroll(scrollSpeed - 0.1);
		else if (FlxG.mouse.overlaps(scrollUp))
			setScroll(scrollSpeed + 0.1);
		else if (FlxG.mouse.overlaps(diffDown))
			setDiff(-1);
		else if (FlxG.mouse.overlaps(diffUp))
			setDiff(1);
		else if (FlxG.mouse.overlaps(saveBtn))
			onSave();
		else if (FlxG.mouse.overlaps(loadBtn))
			onLoad();
	}

	public function updateInfo(bar:Int, totalBars:Int, beatsPerMeasure:Int):Void
	{
		infoText.text = 'Bar ${bar + 1} / $totalBars  |  Beat 1..$beatsPerMeasure';
	}

	function setBpm(v:Float):Void
	{
		bpm = Math.max(1, v);
		refreshValues();
		onChangeBpm(bpm);
	}

	function setScroll(v:Float):Void
	{
		scrollSpeed = Math.max(0.1, Math.round(v * 10) / 10);
		refreshValues();
		onChangeScroll(scrollSpeed);
	}

	function setDiff(dir:Int):Void
	{
		diffIndex = (diffIndex + dir + difficulties.length) % difficulties.length;
		refreshValues();
		onChangeDiff(difficulties[diffIndex]);
	}

	function refreshValues():Void
	{
		bpmText.text = Std.string(bpm);
		scrollText.text = Std.string(scrollSpeed);
		diffText.text = difficulties[diffIndex].toUpperCase();
	}

	function label(x:Float, y:Float, w:Float, text:String):FlxText
	{
		var t = new FlxText(x, y, w, text, 24);
		t.color = FlxColor.WHITE;
		add(t);
		return t;
	}
}