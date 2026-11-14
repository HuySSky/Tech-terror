package editor;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class InstrumentPickerState extends FlxSubState
{
	static inline var PANEL_W = 400;
	static inline var ITEM_H = 40;
	static inline var PAD = 20;

	var onPick:String->Void;
	var items:Array<FlxText> = [];

	public function new(onPick:String->Void)
	{
		super(0x99000000);
		this.onPick = onPick;
	}

	override public function create():Void
	{
		super.create();

		var names = Instruments.names();
		var h = names.length * ITEM_H + PAD * 2;

		var panel = new FlxSprite().makeGraphic(PANEL_W, h, 0xFFFFF176, true);
		panel.drawRect(4, 4, PANEL_W - 8, h - 8, 0xFF202020);
		panel.screenCenter();
		add(panel);

		for (i => name in names)
		{
			var t = new FlxText(panel.x + PAD, panel.y + PAD + i * ITEM_H, PANEL_W - PAD * 2, name, 24);
			t.color = FlxColor.WHITE;
			add(t);
			items.push(t);
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			close();
			return;
		}

		if (!FlxG.mouse.justReleased)
			return;

		for (t in items)
		{
			if (FlxG.mouse.overlaps(t))
			{
				onPick(t.text);
				close();
				return;
			}
		}
	}
}