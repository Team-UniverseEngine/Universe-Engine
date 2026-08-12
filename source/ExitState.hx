package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.sound.FlxSound;
import flixel.FlxSubState;

class ExitState extends MusicBeatSubstate
{
	var curSelected:Int = 0;

	public var exitNo:FlxSprite;
	public var exitYes:FlxSprite;

	public static var inExit:Bool = false;

	public var lockInput:Float = 1;

	public function new(?pause:MusicBeatSubstate = null)
	{
		super();

		var bgBlack:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bgBlack.alpha = 0.6;
		bgBlack.scrollFactor.set();
		add(bgBlack);

		var bg:FlxSprite = new FlxSprite(FlxG.width / 2 - 250, FlxG.height / 2 - 250).loadGraphic(Paths.image('exit/bg'));
		bg.setGraphicSize(Std.int(bg.width * 2));
		bg.alpha = 0.2;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		exitNo = new FlxSprite(FlxG.width / 2 - 400, FlxG.height / 2 - 100).loadGraphic(Paths.image('exit/No'));
		exitNo.updateHitbox();
		exitNo.antialiasing = ClientPrefs.data.antialiasing;
		add(exitNo);
		exitYes = new FlxSprite(FlxG.width / 2 + 200, FlxG.height / 2 - 100).loadGraphic(Paths.image('exit/Yes'));
		exitYes.updateHitbox();
		exitYes.antialiasing = ClientPrefs.data.antialiasing;
		add(exitYes);

		var exitText:FlxText = new FlxText(FlxG.width / 2 - 350, FlxG.height / 2 - 200, "Are you sure you want to exit the game?", 16);
		exitText.setFormat(Paths.font("funkin.ttf"), 32, FlxColor.WHITE);
		add(exitText);

		FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic), "shared"), 0);
		FlxG.sound.music.fadeIn(4, 0, 0.7);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed)
	{
		if (lockInput <= 0)
		{
			if (controls.UI_LEFT_P)
			{
				changeItem(-1);
			}
			if (controls.UI_RIGHT_P)
			{
				changeItem(1);
			}
			if (controls.ACCEPT)
			{
				smth();
			}
		}

		if (lockInput >= 0)
		{
			lockInput -= 0.1;
			trace(lockInput);
		}

		if (curSelected == 1)
		{
			exitYes.alpha = 1;
			exitNo.alpha = 0.5;
		}
		if (curSelected == 0)
		{
			exitYes.alpha = 0.5;
			exitNo.alpha = 1;
		}
		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected > 1)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = 1;

		trace(curSelected);
	}

	function smth()
	{
		if (curSelected == 1)
		{
			openfl.system.System.exit(0);
		}
		if (curSelected == 0)
		{
			FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm));
			inExit = false;
			close();
		}
	}
}
