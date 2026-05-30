package options;

import Discord.DiscordClient;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.sound.FlxSound;

using StringTools;

class SelectThing extends MusicBeatState
{
	var options:Array<String>;
	private var grpOptions:FlxTypedGroup<Alphabet>;

	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;

	function openSelectedSubstate(label:String)
	{
		switch (label)
		{
			case 'Solar Options':
				MusicBeatState.switchState(new options.UniverseOptionsMenu());
			case 'Psych Options':
				MusicBeatState.switchState(new options.OptionsState());
			case 'Mods':
				MusicBeatState.switchState(new ModsMenuState());
			case 'Credits':
				MusicBeatState.switchState(new CreditsState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create()
	{
		// FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic), "shared"), 0);
		// FlxG.sound.music.fadeIn(4, 0, 0.7);

		if (ClientPrefs.data.moveCreditMods)
			options = ['Universe Options', 'Psych Options', 'Mods', 'Credits'];
		else
			options = ['Universe Options', 'Psych Options'];

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		ShortcutMenuSubState.inShortcutMenu = false;

		DiscordClient.changePresence("Selecting options category", null);

		if (ClientPrefs.data.darkmode)
		{
			var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image("aboutMenu", "preload"));
			bg.color = 0xFFea71fd;
			bg.screenCenter();
			bg.antialiasing = ClientPrefs.data.antialiasing;
			bg.updateHitbox();
			add(bg);

			var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x337F7F7F, 0x0));
			grid.velocity.set(20, 20);
			grid.alpha = 0;
			FlxTween.tween(grid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
			add(grid);
		}
		else
		{
			var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
			bg.color = 0xFFea71fd;
			bg.screenCenter();
			bg.antialiasing = ClientPrefs.data.antialiasing;
			bg.updateHitbox();
			add(bg);

			var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
			grid.velocity.set(20, 20);
			grid.alpha = 0;
			FlxTween.tween(grid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
			add(grid);
		}

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState()
	{
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!ShortcutMenuSubState.inShortcutMenu)
		{
			if (controls.UI_UP_P)
			{
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P)
			{
				changeSelection(1);
			}

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				if (PauseSubState.inPause)
				{
					PauseSubState.inPause = false;
					StageData.loadDirectory(PlayState.SONG);
					LoadingState.loadAndSwitchState(new PlayState());
					FlxG.sound.music.volume = 0;
				}
				else if (ClientPrefs.fm)
				{
					MusicBeatState.switchState(new CoolMenuState());
				}
				else
				{
					MusicBeatState.switchState(new MainMenuState());
				}
			}
			if (controls.ACCEPT)
			{
				openSelectedSubstate(options[curSelected]);
			}
		}

		if (FlxG.keys.justPressed.TAB)
		{
			ShortcutMenuSubState.inShortcutMenu = true;
			openSubState(new ShortcutMenuSubState());
		}
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0)
			{
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}
