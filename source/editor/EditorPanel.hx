package editor;

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

	var infoText:FlxText;

	public function new(initialBpm:Float)
	{
		super();

		var panel = new FlxSprite(PANEL_X, PANEL_Y).makeGraphic(PANEL_W, PANEL_H, 0xFFFFF176, true);
		panel.drawRect(4, 4, PANEL_W - 8, PANEL_H - 8, 0xFF202020);
		add(panel);

		infoText = new FlxText(PANEL_X + 20, PANEL_Y + 15, PANEL_W - 40, 'BPM: $initialBpm', 28);
		infoText.color = FlxColor.WHITE;
		add(infoText);
	}

	public function updateInfo(bar:Int, totalBars:Int, bpm:Float, beatsPerMeasure:Int):Void
	{
		infoText.text = 'Bar ${bar + 1} / $totalBars  |  BPM: $bpm  |  Beat 1..$beatsPerMeasure';
	}
}