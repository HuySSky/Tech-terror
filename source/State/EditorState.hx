package state;

import editor.*;
import flixel.FlxG;
import flixel.FlxState;
import song.SongData;

class EditorState extends FlxState
{
	static inline var SUB_BEAT = 0.25;

	var songData:SongData;
	var difficulty:String;

	var lines:Array<String> = ["Kick", "Snare", "Hat", "Ride"];
	var bpm:Float;
	var beatsPerMeasure:Int;
	var totalBars:Int;

	var panel:EditorPanel;
	var grid:EditorGrid;
	var nav:EditorNavigation;

	public function new(songData:SongData, difficulty:String)
	{
		super();
		this.songData = songData;
		this.difficulty = difficulty;
	}

	override public function create():Void
	{
		super.create();

		FlxG.camera.bgColor = 0xFFE8E8E8;

		bpm = songData.bpm;
		beatsPerMeasure = songData.timeSignature.beatsPerMeasure;
		totalBars = Math.ceil(songData.duration / (60 / bpm * beatsPerMeasure));

		grid = new EditorGrid(bpm, beatsPerMeasure, totalBars, lines, SUB_BEAT);
		add(grid);

		panel = new EditorPanel(bpm, 1.0, difficulty, function(newBpm)
		{
			trace("New BPM: " + newBpm);
		}, function(newScroll)
		{
			trace("New Scroll: " + newScroll);
		}, function(newDiff)
		{
			trace("New Diff: " + newDiff);
		}, function()
		{
			trace("SAVE clicked");
		}, function()
		{
			trace("LOAD clicked");
		});
		add(panel);

		nav = new EditorNavigation(navigate);
		add(nav);

		panel.updateInfo(grid.getCurrentBar(), totalBars, beatsPerMeasure);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.LEFT)
			navigate(-1);
		else if (FlxG.keys.justPressed.RIGHT)
			navigate(1);
		else if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(MenuState.new);
	}

	function navigate(dir:Int):Void
	{
		grid.changeBar(dir);
		panel.updateInfo(grid.getCurrentBar(), totalBars, beatsPerMeasure);
	}
}