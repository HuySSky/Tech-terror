package editor;

import flixel.FlxSprite;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class Grid extends FlxSprite
{
    public var row:Int;
	public var col:Int;

	public function new(x:Float, y:Float, columnsPerBar:Int, row:Int, col:Int, isBeatBoundary:Bool, isFirst:Bool)
	{
		super(x, y);
		this.row = row;
		this.col = col;

		var w = Math.round(GRID_W / columnsPerBar - GRID_GAP);
		var h = ROW_H;

		makeGraphic(w, h, FlxColor.GRAY, true);

		// Nền trắng
		this.drawRect(0, 0, w, h, FlxColor.WHITE);

		// Đường phân cách bên phải
		if (isBeatBoundary)
			this.drawRect(w, 0, GRID_GAP, h, 0xFF4B4B4B);
		else
			this.drawRect(w, 0, GRID_GAP, h, 0xFF1B0408);

		// Đường viền trái của bảng
		if (isFirst)
			this.drawRect(0, 0, 4, h, FlxColor.BLACK);
	}
}