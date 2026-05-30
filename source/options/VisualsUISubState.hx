package options;

#if desktop
import Discord.DiscordClient;
#end
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

using StringTools;

class VisualsUISubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Visuals and UI';
		rpcTitle = 'Visuals & UI Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Note Splashes',
			"If unchecked, hitting \"Sick!\" notes won't show particles.",
			'noteSplashes',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Hide HUD',
			'If checked, hides most HUD elements.',
			'hideHud',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Solar Engine HUD', "If unchecked, it just goes back to scoreTxt, what more is there to explain? ", 'ueHud', 'bool',
			true);
		option.onChange = () -> {
			close();
			OptionsState.nextState = "Visuals and UI";
		}
		addOption(option);

		if (ClientPrefs.data.ueHud == true)
		{
			var option:Option = new Option('Hud Pos', "Don't even try to ask me to explain this", 'hudPosUE', 'string', 'LEFT', ['LEFT', 'CENTER', 'RIGHT']);
			addOption(option);

			var option:Option = new Option('Song name and time follow', "If unchecked, The Song name and time doesn't follow the score, rating and misses.",
				'sntf', 'bool', true);
			addOption(option);

			var option:Option = new Option("Hide UE's Timebar", ' If checked, the UE time bar is going to dissapear', 'huet', 'bool', false);
			addOption(option);
		}

		var option:Option = new Option('Keystrokes', "If checked, you can see the keystrokes", 'keystrokes', 'bool', true);
		addOption(option);

		if (ClientPrefs.data.keystrokes == true)
		{
			var option:Option = new Option('Keystrokes Alpha', 'Keystrokes Alpha, max 50%', 'keyA', 'percent', 0.3);
			addOption(option);
			option.maxValue = 0.5;

			var option:Option = new Option('Keystrokes Fade Time', 'Keystrokes Fade time, max 25%', 'keyFT', 'percent', 0.15);
			addOption(option);
			option.maxValue = 0.25;

			var option:Option = new Option('Keystrokes X Position', 'Keystrokes X Pos, max 615', 'keyXPos', 'int', 90);
			addOption(option);
			option.maxValue = 615;

			var option:Option = new Option('Keystrokes Y Position', 'Keystrokes Y Pos, max 580', 'keyYPos', 'int', 330);
			addOption(option);
			option.maxValue = 580;
		}

		#if SILLY_OPTIONS
		var option:Option = new Option('Detached Health Bar', 'When Unchecked, the health bar get sets to camHUD', 'dhb', 'bool', true);
		addOption(option);

		var option:Option = new Option('Combo Counter', "If unchecked, it'll go back to the normal combo coutner", 'cc', 'bool', true);
		addOption(option);

		var option:Option = new Option('Zoomed Out', "If unchecked, it no zoomed out :3", 'hudZoomOut', 'bool', true);
		addOption(option);

		var option:Option = new Option('Icon Bop', "If the mod has a custom icon bop, disable this!", 'ib', 'bool', true);
		addOption(option);
		
		var option:Option = new Option('Layer HPBG Behind', 'If unchecked, The Healthbar BG Layers behind the health bar colors.', 'lhpbgb', 'bool', false);
		addOption(option);
		#end

		var option:Option = new Option('Main Menu Music', 'Change the main menu song', 'mmm', 'string', 'Universe', [
			'Universe',
			#if SILLY_OPTIONS "AAC V4", #end
			/* 'FunkinParadise', // Creator is potentially not a cool guy
			// The following aren't ours in the slightest.
			'VS Impostor V4',
			'VS Shaggy',
			'VS Nonsense V2',
			'DNB Old',
			'Stay Funky',
			'Marked Engine',
			'IdiotXD', */
			'Normal Collections', // Can't find anything on this lmao
			'Daveberry'
		]);
		addOption(option);
		option.onChange = changeSong;

		#if SILLY_OPTIONS
		var option:Option = new Option('Fancy Title', 'Title bounce', 'ft', 'bool', false);
		addOption(option);

		var option:Option = new Option('Cute Mode', if (ClientPrefs.data.cm == true)
		{
			'i coded this UwU';
		} else
		{
			'What is this option i never coded this';
		}, 'cm', 'bool', false);
		addOption(option);
		option.onChange = restart;
		#end

		/*
		var option:Option = new Option('Check for Updates', 'On Release builds, turn this on to check for updates when you start the game.',
			'checkForUpdates', 'bool', true);
		addOption(option);
		*/

		var option:Option = new Option('Dark Mode', 'Basically dark mode on every website, but cooler', 'darkmode', 'bool', false);
		addOption(option);

		var option:Option = new Option('Loading Screen', 'Loading screen!\nalso, this just does nothing lol', 'loadscreen', 'bool', false);
		addOption(option);

		#if SILLY_OPTIONS
		var option:Option = new Option('Fancy Menus', "Makes the menus just more clean", 'fm', 'bool', true);
		addOption(option);

		var option:Option = new Option('Silly Bounce', "Makes the dots behind the main menu bounce", 'sillyBob', 'bool', true);
		addOption(option);
		#end

		var option:Option = new Option('Disable Second Page', "Disables the second page on the main menu.", 'disable2ndpage', 'bool', false);
		addOption(option);

		var option:Option = new Option('Hide Original Credits', "Hides the original credits built-in in source.", 'hideOriCredits', 'bool', false);
		addOption(option);
		
		var option:Option = new Option('Time Bar:',
			"What should the Time Bar display?",
			'timeBarType',
			'string',
			'Time Left',
			['Time Left', 'Time Elapsed', 'Song Name', 'Disabled']);
		addOption(option);

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Camera Zooms',
			"If unchecked, the camera won't zoom in on a beat hit.",
			'camZooms',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Score Text Zoom on Hit',
			"If unchecked, disables the Score text zooming\neverytime you hit a note.",
			'scoreZoom',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Health Bar Transparency',
			'How much transparent should the health bar and icons be.',
			'healthBarAlpha',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		#if !mobile
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides FPS Counter.',
			'showFPS',
			'bool',
			true);
		addOption(option);
		option.onChange = onChangeFPSCounter;
		#end
		
		var option:Option = new Option('Pause Screen Song:',
			"What song do you prefer for the Pause Screen?",
			'pauseMusic',
			'string',
			'Tea Time',
			['None', 'Breakfast', 'Tea Time']);
		addOption(option);
		option.onChange = onChangePauseMusic;

		var option:Option = new Option('Combo Stacking',
			"If unchecked, Ratings and Combo won't stack, saving on System Memory and making them easier to read",
			'comboStacking',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Hitsound Volume', 'Funny notes does \"Tick!\" when you hit them."', 'hitsoundVolume', 'percent', 0);
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;

		var option:Option = new Option('Hitsound Type:', 'Change the hitsound type', 'ht', 'string', 'Classic', [
			'Classic',
			'Water',
			'Waterboom',
			'Heartbeat',
			'Universe',
			#if SILLY_OPTIONS
			'Fire in the hole',
			'Baldi',
			'Spongefail',
			'Spongebob'
			#end
		]);
		addOption(option);
		option.onChange = onChangeHitSound;

		var option:Option = new Option('Smooth HP', 'If there was any bug moving the position X health icons, turn this off!', 'sh', 'bool', true);
		addOption(option);

		#if SILLY_OPTIONS
		var option:Option = new Option('Every 100 combo', 'If every 100 combo, it does a cool thing :D', 'ec', 'bool', true);
		addOption(option);

		if (ClientPrefs.data.ec)
		{
			var option:Option = new Option('100 Combo sound', 'Select a sound that plays everytime you have 100 combo count', 'css', 'string', 'GF Sounds',
				['GF Sounds', 'Click Text']);
			addOption(option);
		}

		var option:Option = new Option('Shake on miss', "If unchecked, screen doesn't shake on miss", 'snm', 'bool', false);
		addOption(option);

		var option:Option = new Option('Taunt on Go!', "If unchecked, doesn't taunt on go!", 'tng', 'bool', true);
		addOption(option);

		var option:Option = new Option('Darken CamGame', 'If checked, it darkens the camGame, so its easier to read modcharts.', 'dcm', 'bool', false);
		addOption(option);
		#end

		var option:Option = new Option('Long note Transparency', 'How much the transparency for the long notes be.', 'longnotet', 'percent', 0.6);
		addOption(option);
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.scrollSpeed = 1.6;

		var option:Option = new Option('Results Screen', 'If unchecked, the results screen wont appear on end song.', 'ueresultscreen', 'bool', true);
		addOption(option);

		var option:Option = new Option('Strum Splashes', 'If unchecked, Strum splashes wont be visible anymore.', 'uess', 'bool', true);
		addOption(option);

		var option:Option = new Option('Miss Sounds', "If unchecked, Miss sounds won't play anymore.", 'uems', 'bool', true);
		addOption(option);

		super();
	}

	var changedMusic:Bool = false;

	function onChangePauseMusic()
	{
		if (ClientPrefs.data.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)));

		changedMusic = true;
	}

	override function destroy()
	{
		if (changedMusic)
			FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm));
		super.destroy();
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		if (Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.data.showFPS;
	}
	#end

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
	}

	function onChangeHitSound()
	{
		FlxG.sound.play(Paths.sound("hitsound-" + ClientPrefs.data.ht), ClientPrefs.data.hitsoundVolume);
	}

	function onChangeHitsoundVolume()
	{
		FlxG.sound.play(Paths.sound("hitsound-" + ClientPrefs.data.ht), ClientPrefs.data.hitsoundVolume);
	}

	function changeSong()
	{
		FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm), 0.7);
	}

	function restart()
	{
		ClientPrefs.saveSettings();
		TitleState.initialized = false;
		TitleState.closedState = false;
		if (FreeplayState.vocals != null)
		{
			FreeplayState.vocals.fadeOut(0.3);
			FreeplayState.vocals = null;
		}
		FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
	}
}
