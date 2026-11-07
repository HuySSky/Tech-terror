package editor;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class EditorNavigation extends FlxTypedSpriteGroup<FlxSprite>
{
	var left:FlxText;
	var right:FlxText;
	var onNavigate:Int->Void;

	public function new(onNavigate:Int->Void)
	{
		super();
		this.onNavigate = onNavigate;

		left = new FlxText(1030, 130, 0, "<", 64);
		left.color = FlxColor.BLACK;
		add(left);

		right = new FlxText(1110, 130, 0, ">", 64);
		right.color = FlxColor.BLACK;
		add(right);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.overlaps(left))
				onNavigate(-1);
			else if (FlxG.mouse.overlaps(right))
				onNavigate(1);
		}
	}
}