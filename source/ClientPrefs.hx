package;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;
import flixel.util.FlxColor;

class SaveVariables
{
	public var downScroll:Bool = false;
	public var middleScroll:Bool = false;
	public var opponentStrums:Bool = true;
	public var showFPS:Bool = true;
	public var flashing:Bool = true;
	public var globalAntialiasing:Bool = true;
	public var noteSplashes:Bool = false;
	public var lowQuality:Bool = false;
	public var shaders:Bool = true;
	public var framerate:Int = 60;
	public var cursing:Bool = true;
	public var violence:Bool = true;
	public var camZooms:Bool = true;
	public var hideHud:Bool = false;
	public var noteOffset:Int = 0;
	public var arrowHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
	public var ghostTapping:Bool = true;
	public var timeBarType:String = 'Time Left';
	public var scoreZoom:Bool = true;
	public var noReset:Bool = false;
	public var healthBarAlpha:Float = 1;
	public var controllerMode:Bool = false;
	public var hitsoundVolume:Float = 0;
	public var pauseMusic:String = 'Tea Time';
	// public var checkForUpdates:Bool = true;
	public var comboStacking = true;

	public var splashAlpha:Float = 0.6;

	// UE
	public var universeEngineCPREF:Bool = true; // this is to check if you running universe engine!
	public var keystrokes:Bool = true;
	public var keyA:Float = 0.3;
	public var keyFT:Float = 0.15;
	public var keyXPos:Int = 90;
	public var keyYPos:Int = 330;
	public var ueHud:Bool = true;
	public var hudZoomOut:Bool = true;
	public var hudPosUE:String = 'LEFT';
	public var sntf:Bool = true;
	public var mmm:String = 'Universe';
	public var ft:Bool = false;
	public var ht:String = 'Classic';
	public var dhb:Bool = true;
	public var cc:Bool = true;
	public var sh:Bool = true;
	public var ec:Bool = true;
	public var snm:Bool = false;
	public var tng:Bool = true;
	public var ib:Bool = true;
	public var cm:Bool = false;
	public var huet:Bool = false;
	public var css:String = 'GF Sounds';
	public var dcm:Bool = false;
	public var uess:Bool = true;
	public var lhpbgb:Bool = false;
	public var longnotet:Float = 0.6;
	public var darkmode:Bool = false;
	public var ueresultscreen:Bool = true;
	public var uems:Bool = true;
	public var loadscreen:Bool = false;
	public var fm:Bool = true;
	public var disable2ndpage:Bool = false;
	public var hideOriCredits:Bool = false;
	public var moveCreditMods:Bool = false;
	public var windows:Bool = false;

	// offical launcherl mao
	public var officialLauncher:Bool = true;

	public var sillyBob:Bool = true;

	public var noteSkin:String = 'Default';
	public var noteColorStyle:String = 'Normal';

	public var enableColorShader:Bool = true;
	public var showNotes:Bool = true;

	public var comboOffset:Array<Int> = [0, 0, 0, 0];
	public var ratingOffset:Int = 0;
	public var sickWindow:Int = 45;
	public var goodWindow:Int = 90;
	public var badWindow:Int = 135;
	public var safeFrames:Float = 10;
	
	public var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative',
		// anyone reading this, amod is multiplicative speed mod, cmod is constant speed mod, and xmod is bpm based speed mod.
		// an amod example would be chartSpeed * multiplier
		// cmod would just be constantSpeed = chartSpeed
		// and xmod basically works by basing the speed on the bpm.
		// iirc (beatsPerSecond * (conductorToNoteDifference / 1000)) * noteSize (110 or something like that depending on it, prolly just use note.height)
		// bps is calculated by bpm / 60
		// oh yeah and you'd have to actually convert the difference to seconds which I already do, because this is based on beats and stuff. but it should work
		// just fine. but I wont implement it because I don't know how you handle sustains and other stuff like that.
		// oh yeah when you calculate the bps divide it by the songSpeed or rate because it wont scroll correctly when speeds exist.
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'opponentplay' => false,
		'modchart' => true,
		'pbs' => false,
		'sd' => false,
		'hd' => false, // ermm,,,
		'sn' => false, // this is shitty
		'hdp2' => false,
		'ipbr' => false, //
		'ipbrv' => "Normal"
	];
	public var arrowRGB:Array<Array<FlxColor>> = [
		[0xFFC24B99, 0xFFFFFFFF, 0xFF3C1F56],
		[0xFF00FFFF, 0xFFFFFFFF, 0xFF1542B7],
		[0xFF12FA05, 0xFFFFFFFF, 0xFF0A4447],
		[0xFFF9393F, 0xFFFFFFFF, 0xFF651038]
	];
	public var arrowRGBPixel:Array<Array<FlxColor>> = [
		[0xFFE276FF, 0xFFFFF9FF, 0xFF60008D],
		[0xFF3DCAFF, 0xFFF4FFFF, 0xFF003060],
		[0xFF71E300, 0xFFF6FFE6, 0xFF003100],
		[0xFFFF884E, 0xFFFFFAF5, 0xFF6C0000]
	];
	public var windowColor:Array<Int> = [112, 0, 218];

	public function new() var yuh:String = 'yo mum HAHA GOTTEM'; // Haxe Requires this here due to the class not extending anything
}

class ClientPrefs
{
	public static var data:SaveVariables = null;
	public static var defaultData:SaveVariables = null;

	// Every key has two binds, add your key bind down here and then add your control on options/ControlsSubState.hx and Controls.hx
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		// Key Bind, Name for ControlsSubState
		'note_left' => [A, LEFT],
		'note_down' => [S, DOWN],
		'note_up' => [W, UP],
		'note_right' => [D, RIGHT],
		'ui_left' => [A, LEFT],
		'ui_down' => [S, DOWN],
		'ui_up' => [W, UP],
		'ui_right' => [D, RIGHT],
		'accept' => [SPACE, ENTER],
		'back' => [BACKSPACE, ESCAPE],
		'pause' => [ENTER, ESCAPE],
		'reset' => [R, NONE],
		'volume_mute' => [ZERO, NONE],
		'volume_up' => [NUMPADPLUS, PLUS],
		'volume_down' => [NUMPADMINUS, MINUS],
		'debug_1' => [SEVEN, NONE],
		'debug_2' => [EIGHT, NONE],
		'debug_3' => [NINE, NONE],
		'is' => [K, NONE]
	];
	public static var defaultKeys:Map<String, Array<FlxKey>> = null;

	public static var defaultArrowRGB:Array<Array<FlxColor>> = [
		[0xFFC24B99, 0xFFFFFFFF, 0xFF3C1F56],
		[0xFF00FFFF, 0xFFFFFFFF, 0xFF1542B7],
		[0xFF12FA05, 0xFFFFFFFF, 0xFF0A4447],
		[0xFFF9393F, 0xFFFFFFFF, 0xFF651038]
	];
	public static var defaultPixelRGB:Array<Array<FlxColor>> = [
		[0xFFE276FF, 0xFFFFF9FF, 0xFF60008D],
		[0xFF3DCAFF, 0xFFF4FFFF, 0xFF003060],
		[0xFF71E300, 0xFFF6FFE6, 0xFF003100],
		[0xFFFF884E, 0xFFFFFAF5, 0xFF6C0000]
	];
	public static var defaultWindowColor:Array<Int> = [112, 0, 218];

	public static function loadDefaultStuff()
	{
		defaultKeys = keyBinds.copy();
	}

	public static function saveSettings()
	{
		for (key in Reflect.fields(data))
		{
			Reflect.setField(FlxG.save.data, key, Reflect.field(data, key));
		}
		FlxG.save.data.achievementsMap = Achievements.achievementsMap;
		FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;
		FlxG.save.flush();

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'universe'); // Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.data.customControls = keyBinds;
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadPrefs()
	{
		if (data == null) data = new SaveVariables();
		if (defaultData == null) defaultData = new SaveVariables();

		for (key in (Reflect.fields(data)))
		{
			if (key != 'gameplaySettings' && Reflect.hasField(FlxG.save.data, key))
			{
				Reflect.setField(data, key, Reflect.field(FlxG.save.data, key));
			}
		}

		if (data.framerate > FlxG.drawFramerate) {
			FlxG.drawFramerate = data.framerate;
			FlxG.updateFramerate = data.framerate;
		} else {
			FlxG.drawFramerate = data.framerate;
			FlxG.updateFramerate = data.framerate;
		}

		if (FlxG.save.data.gameplaySettings != null)
		{
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
			{
				data.gameplaySettings.set(name, value);
			}
		}

		// flixel automatically saves your volume!
		if (FlxG.save.data.volume != null)
		{
			FlxG.sound.volume = FlxG.save.data.volume;
		}
		if (FlxG.save.data.mute != null)
		{
			FlxG.sound.muted = FlxG.save.data.mute;
		}

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'universe');
		if (save != null && save.data.customControls != null)
		{
			var loadedControls:Map<String, Array<FlxKey>> = save.data.customControls;
			for (control => keys in loadedControls)
			{
				keyBinds.set(control, keys);
			}
			reloadControls();
		}
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic):Dynamic
	{
		return /*PlayState.isStoryMode ? defaultValue : */ (data.gameplaySettings.exists(name) ? data.gameplaySettings.get(name) : defaultValue);
	}

	public static function reloadControls()
	{
		PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo);

		TitleState.muteKeys = copyKey(keyBinds.get('volume_mute'));
		TitleState.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		TitleState.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
	}

	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey>
	{
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len)
		{
			if (copiedArray[i] == NONE)
			{
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}
}