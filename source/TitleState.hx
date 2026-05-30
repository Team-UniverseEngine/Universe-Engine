package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import options.GraphicsSettingsSubState;
// import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.sound.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import flixel.util.FlxAxes;
import flixel.addons.display.FlxBackdrop;

using StringTools;

typedef TitleData =
{
	titlex:Float,
	titley:Float,
	startx:Float,
	starty:Float,
	gfx:Float,
	gfy:Float,
	backgroundSprite:String,
	bpm:Int
}

class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var titleTextColors:Array<FlxColor> = [0xFF33FFFF, 0xFF3333CC];
	var titleTextAlphas:Array<Float> = [1, .64];

	var curWacky:Array<String> = [];
	var wackyImage:FlxSprite;

	var unWackyourwacky:Array<String> = [];

	#if TITLE_SCREEN_EASTER_EGG
	var easterEggKeys:Array<String> = ['SHADOW', 'RIVER', 'SHUBS', 'BBPANZU'];
	var allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	var easterEggKeysBuffer:String = '';
	#end

	var titleJSON:TitleData;

	public static var updateVersion:String = '';

	var blackDots:FlxBackdrop;
	var logoCanBeat:Bool = false;
	var fnf:FlxSprite;
	var anammar:FlxSprite;
	var creativity:FlxSprite;
	var bg:FlxSprite;

	override public function create():Void
	{
		DiscordClient.changePresence("In the Intro", null);
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end
		// Just to load a mod on start up if ya got one. For mods that change the menu music and bg
		WeekData.loadTheFirstEnabledMod();

		// trace(path, FileSystem.exists(path));

		/*#if (polymod && !html5)
			if (sys.FileSystem.exists('mods/')) {
				var folders:Array<String> = [];
				for (file in sys.FileSystem.readDirectory('mods/')) {
					var path = haxe.io.Path.join(['mods/', file]);
					if (sys.FileSystem.isDirectory(path)) {
						folders.push(file);
					}
				}
				if(folders.length > 0) {
					polymod.Polymod.init({modRoot: "mods", dirs: folders});
				}
			}
			#end */

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		curWacky = FlxG.random.getObject(getIntroTextShit());
		unWackyourwacky = FlxG.random.getObject(getUETextShit());

		// DEBUG BULLSHIT

		swagShader = new ColorSwap();
		super.create();

		Highscore.load();

		// IGNORE THIS!!!
		titleJSON = Json.parse(Paths.getTextFromFile('images/gfDanceTitle.json'));
		if (ClientPrefs.data.mmm == "DNB Old")
			titleJSON = Json.parse(Paths.getTextFromFile('images/bpmchange/DNB.json'));
		else if (ClientPrefs.data.mmm == "Stay Funky")
			titleJSON = Json.parse(Paths.getTextFromFile('images/bpmchange/Stay-Funky.json'));
		else if (ClientPrefs.data.mmm == "Marked Engine")
			titleJSON = Json.parse(Paths.getTextFromFile('images/bpmchange/Marked.json'));
		else if (ClientPrefs.data.mmm == "Daveberry")
			titleJSON = Json.parse(Paths.getTextFromFile('images/bpmchange/Daveberry.json'));
		#if TITLE_SCREEN_EASTER_EGG
		if (FlxG.save.data.psychDevsEasterEgg == null)
			FlxG.save.data.psychDevsEasterEgg = ''; // Crash prevention
		switch (FlxG.save.data.psychDevsEasterEgg.toUpperCase())
		{
			case 'SHADOW':
				titleJSON.gfx += 210;
				titleJSON.gfy += 40;
			case 'RIVER':
				titleJSON.gfx += 100;
				titleJSON.gfy += 20;
			case 'SHUBS':
				titleJSON.gfx += 160;
				titleJSON.gfy -= 10;
			case 'BBPANZU':
				titleJSON.gfx += 45;
				titleJSON.gfy += 100;
		}
		#end

		if (!initialized)
		{
			if (FlxG.save.data != null && FlxG.save.data.fullscreen)
			{
				FlxG.fullscreen = FlxG.save.data.fullscreen;
				// trace('LOADED FULLSCREEN SETTING!!');
			}
			persistentUpdate = true;
			persistentDraw = true;
		}

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
		if (FlxG.save.data.flashing == null && !FlashingState.leftState)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		}
		#if PROMPT_LAUNCHER // currently archived.
		else if (FlxG.save.data.officialLauncher == null && !OfficialLauncherState.leftState) //Thing Remove popup officlal launcher
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new OfficialLauncherState()); // comment this line if you wanna remove the officiallauncherstate!
		}
		#end

		#if desktop
		if (!DiscordClient.isInitialized)
		{
			DiscordClient.initialize();
			Application.current.onExit.add(function(exitCode)
			{
				DiscordClient.shutdown();
			});
		}
		#end

		if (initialized)
			startIntro();
		else
		{
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				startIntro();
			});
		}
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var swagShader:ColorSwap = null;

	function startIntro()
	{
		if (!initialized)
		{
			/*var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
				diamond.persist = true;
				diamond.destroyOnNoUse = false;

				FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
					new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));
				FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
					{asset: diamond, width: 32, height: 32}, new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut; */

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();

			if (FlxG.sound.music == null)
			{
				FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm), 0);
			}
		}

		Conductor.changeBPM(titleJSON.bpm);
		persistentUpdate = true;

		if (ClientPrefs.data.mmm != "AAC V4")
		{
			if (ClientPrefs.data.darkmode)
			{
				bg = new FlxSprite(0, 0).loadGraphic(Paths.image("aboutMenu", "preload"));
				bg.color = 0xFFFDE871;
				bg.antialiasing = ClientPrefs.data.antialiasing;
				bg.setGraphicSize(Std.int(bg.width * 2));
				bg.updateHitbox();
				bg.screenCenter();
				add(bg);
				bg.shader = swagShader.shader;
			}
			else
			{
				bg = new FlxSprite(0, 0).loadGraphic(Paths.image('menuBG'));
				bg.antialiasing = ClientPrefs.data.antialiasing;
				bg.setGraphicSize(Std.int(bg.width * 2));
				bg.updateHitbox();
				bg.screenCenter();
				add(bg);
				bg.shader = swagShader.shader;
			}

			logoBl = new FlxSprite(titleJSON.titlex, titleJSON.titley);
			logoBl.frames = Paths.getSparrowAtlas('logoBumpin');

			logoBl.antialiasing = ClientPrefs.data.antialiasing;
			logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
			logoBl.animation.play('bump');
			logoBl.updateHitbox();
			if (ClientPrefs.data.ft)
			{
				logoBl.y = FlxG.height / 2 - 450;
				logoBl.screenCenter(X);
				logoBl.scale.set(1.1, 1.1);
			}
		}
		// logoBl.color = FlxColor.BLACK;

		swagShader = new ColorSwap();
		gfDance = new FlxSprite(titleJSON.gfx, titleJSON.gfy);

		var easterEgg:String = FlxG.save.data.psychDevsEasterEgg;
		if (easterEgg == null)
			easterEgg = ''; // html5 fix

		switch (easterEgg.toUpperCase())
		{
			#if TITLE_SCREEN_EASTER_EGG
			case 'SHADOW':
				gfDance.frames = Paths.getSparrowAtlas('ShadowBump');
				gfDance.animation.addByPrefix('danceLeft', 'Shadow Title Bump', 24);
				gfDance.animation.addByPrefix('danceRight', 'Shadow Title Bump', 24);
			case 'RIVER':
				gfDance.frames = Paths.getSparrowAtlas('RiverBump');
				gfDance.animation.addByIndices('danceLeft', 'River Title Bump', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				gfDance.animation.addByIndices('danceRight', 'River Title Bump', [29, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			case 'SHUBS':
				gfDance.frames = Paths.getSparrowAtlas('ShubBump');
				gfDance.animation.addByPrefix('danceLeft', 'Shub Title Bump', 24, false);
				gfDance.animation.addByPrefix('danceRight', 'Shub Title Bump', 24, false);
			case 'BBPANZU':
				gfDance.frames = Paths.getSparrowAtlas('BBBump');
				gfDance.animation.addByIndices('danceLeft', 'BB Title Bump', [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], "", 24, false);
				gfDance.animation.addByIndices('danceRight', 'BB Title Bump', [27, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], "", 24, false);
			#end

			default:
				// EDIT THIS ONE IF YOU'RE MAKING A SOURCE CODE MOD!!!!
				// EDIT THIS ONE IF YOU'RE MAKING A SOURCE CODE MOD!!!!
				// EDIT THIS ONE IF YOU'RE MAKING A SOURCE CODE MOD!!!!
				gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
				gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		}
		if (ClientPrefs.data.mmm != "AAC V4")
		{
			gfDance.antialiasing = ClientPrefs.data.antialiasing;
			if (ClientPrefs.data.ft == true)
			{
				gfDance.screenCenter(X);
				gfDance.y = FlxG.height / 2 - 200;
				gfDance.scale.set(0.75, 0.75);
			}
			if (ClientPrefs.data.ft == true)
			{
				var fancyBG:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('universeBanner'));
				fancyBG.updateHitbox();
				fancyBG.screenCenter();
				fancyBG.antialiasing = ClientPrefs.data.antialiasing;
				fancyBG.setGraphicSize(Std.int(fancyBG.width * 1.175));
				add(fancyBG);
			}

			logoBl.shader = swagShader.shader;
			if (ClientPrefs.data.ft == true)
			{
				var darkBG:FlxSprite = new FlxSprite(0, 0);
				darkBG.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
				darkBG.alpha = 0.5;
				darkBG.screenCenter();
				add(darkBG);

				var fancyLogoBl = new FlxSprite(titleJSON.titlex, titleJSON.titley);
				fancyLogoBl.frames = Paths.getSparrowAtlas('logoBumpin');
				fancyLogoBl.antialiasing = ClientPrefs.data.antialiasing;
				fancyLogoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
				fancyLogoBl.animation.play('bump');
				fancyLogoBl.updateHitbox();
				fancyLogoBl.screenCenter(X);
				logoBl.y = FlxG.height / 2 - 450;
				add(fancyLogoBl);
				fancyLogoBl.alpha = 0;
				fancyLogoBl.shader = swagShader.shader;
			}
			add(logoBl);
			add(gfDance);
			gfDance.shader = swagShader.shader;
		}

		if (ClientPrefs.data.mmm == "AAC V4")
		{
			bg = new FlxSprite(0, 0).loadGraphic(Paths.image('AmmarTitle/introBG'));
			bg.updateHitbox();
			bg.screenCenter();
			bg.antialiasing = ClientPrefs.data.antialiasing;
			bg.setGraphicSize(Std.int(bg.width * 1.175));
			add(bg);

			blackDots = new FlxBackdrop(Paths.image("blackDots"), X);
			blackDots.antialiasing = ClientPrefs.data.antialiasing;
			blackDots.setGraphicSize(Std.int(1280 * 1.04));
			blackDots.updateHitbox();
			blackDots.screenCenter();
			blackDots.velocity.set(30, 0);
			blackDots.alpha = 0; // 0.3
			blackDots.y += 125;
			add(blackDots);

			fnf = new FlxSprite(0, 0).loadGraphic(Paths.image('AmmarTitle/FNF'));
			fnf.updateHitbox();
			fnf.screenCenter(X);
			fnf.y = FlxG.height / 2 - 370;
			fnf.antialiasing = ClientPrefs.data.antialiasing;

			anammar = new FlxSprite(0, 0).loadGraphic(Paths.image('AmmarTitle/An Ammar'));
			anammar.updateHitbox();
			anammar.screenCenter(X);
			anammar.y = FlxG.height / 2 - 360;
			anammar.antialiasing = ClientPrefs.data.antialiasing;

			creativity = new FlxSprite(0, 0).loadGraphic(Paths.image('AmmarTitle/Creativity'));
			creativity.updateHitbox();
			creativity.screenCenter(X);
			creativity.y = FlxG.height / 2 - 350;
			creativity.antialiasing = ClientPrefs.data.antialiasing;

			add(fnf);
			add(anammar);
			add(creativity);
			fnf.scale.set(3, 3);
			anammar.scale.set(3, 3);
			creativity.scale.set(3, 3);
		}

		titleText = new FlxSprite(titleJSON.startx, titleJSON.starty);
		#if (desktop && MODS_ALLOWED)
		var path = "mods/" + Paths.currentModDirectory + "/images/titleEnter.png";
		// trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path))
		{
			path = "mods/images/titleEnter.png";
		}
		// trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path))
		{
			path = "assets/images/titleEnter.png";
		}
		// trace(path, FileSystem.exists(path));
		titleText.frames = FlxAtlasFrames.fromSparrow(BitmapData.fromFile(path), File.getContent(StringTools.replace(path, ".png", ".xml")));
		#else
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		#end
		var animFrames:Array<FlxFrame> = [];
		@:privateAccess {
			titleText.animation.findByPrefix(animFrames, "ENTER IDLE");
			titleText.animation.findByPrefix(animFrames, "ENTER FREEZE");
		}

		if (animFrames.length > 0)
		{
			newTitle = true;

			titleText.animation.addByPrefix('idle', "ENTER IDLE", 24);
			titleText.animation.addByPrefix('press', ClientPrefs.data.flashing ? "ENTER PRESSED" : "ENTER FREEZE", 24);
		}
		else
		{
			newTitle = false;

			titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
			titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		}

		titleText.antialiasing = ClientPrefs.data.antialiasing;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		titleText.x = titleText.x + 25;
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = ClientPrefs.data.antialiasing;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = ClientPrefs.data.antialiasing;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	function getUETextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('UEText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('//'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	private static var playJingle:Bool = false;

	var newTitle:Bool = false;
	var titleTimer:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		if (ClientPrefs.data.mmm == "AAC V4")
		{
			if (logoCanBeat)
			{
				var fnfsizeLerp:Float = FlxMath.lerp(fnf.scale.x, 1, FlxMath.bound((elapsed * 7.5), 0, 1));
				var ansizeLerp:Float = FlxMath.lerp(anammar.scale.x, 1, FlxMath.bound((elapsed * 7.5), 0, 1));
				var crsizeLerp:Float = FlxMath.lerp(creativity.scale.x, 1, FlxMath.bound((elapsed * 7.5), 0, 1));
				fnf.scale.set(fnfsizeLerp, fnfsizeLerp);
				anammar.scale.set(ansizeLerp, ansizeLerp);
				creativity.scale.set(crsizeLerp, crsizeLerp);
			}
		}
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (newTitle)
		{
			titleTimer += CoolUtil.boundTo(elapsed, 0, 1);
			if (titleTimer > 2)
				titleTimer -= 2;
		}

		if (skippedIntro && FlxG.keys.justPressed.ESCAPE && !ExitState.inExit)
		{
			ExitState.inExit = true;
			openSubState(new ExitState());
		}

		// EASTER EGG

		if (initialized && !transitioning && skippedIntro)
		{
			if (newTitle && !pressedEnter && !ExitState.inExit)
			{
				var timer:Float = titleTimer;
				if (timer >= 1)
					timer = (-timer) + 2;

				timer = FlxEase.quadInOut(timer);

				titleText.color = FlxColor.interpolate(titleTextColors[0], titleTextColors[1], timer);
				titleText.alpha = FlxMath.lerp(titleTextAlphas[0], titleTextAlphas[1], timer);
			}

			if (pressedEnter && !ExitState.inExit)
			{
				titleText.color = FlxColor.WHITE;
				titleText.alpha = 1;

				if (titleText != null)
					titleText.animation.play('press');

				FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;
				// FlxG.sound.music.stop();

				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					if (ClientPrefs.data.fm)
					{
						MusicBeatState.switchState(new CoolMenuState());
					}
					else
					{
						MusicBeatState.switchState(new MainMenuState());
					}
					closedState = true;
				});
				// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
			}
			#if TITLE_SCREEN_EASTER_EGG
			else if (FlxG.keys.firstJustPressed() != FlxKey.NONE)
			{
				var keyPressed:FlxKey = FlxG.keys.firstJustPressed();
				var keyName:String = Std.string(keyPressed);
				if (allowedKeys.contains(keyName))
				{
					easterEggKeysBuffer += keyName;
					if (easterEggKeysBuffer.length >= 32)
						easterEggKeysBuffer = easterEggKeysBuffer.substring(1);
					// trace('Test! Allowed Key pressed!!! Buffer: ' + easterEggKeysBuffer);

					for (wordRaw in easterEggKeys)
					{
						var word:String = wordRaw.toUpperCase(); // just for being sure you're doing it right
						if (easterEggKeysBuffer.contains(word))
						{
							// trace('YOOO! ' + word);
							if (FlxG.save.data.psychDevsEasterEgg == word)
								FlxG.save.data.psychDevsEasterEgg = '';
							else
								FlxG.save.data.psychDevsEasterEgg = word;
							FlxG.save.flush();

							FlxG.sound.play(Paths.sound('ToggleJingle'));

							var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
							black.alpha = 0;
							add(black);

							FlxTween.tween(black, {alpha: 1}, 1, {
								onComplete: function(twn:FlxTween)
								{
									FlxTransitionableState.skipNextTransIn = true;
									FlxTransitionableState.skipNextTransOut = true;
									MusicBeatState.switchState(new TitleState());
								}
							});
							FlxG.sound.music.fadeOut();
							if (FreeplayState.vocals != null)
							{
								FreeplayState.vocals.fadeOut();
							}
							closedState = true;
							transitioning = true;
							playJingle = true;
							easterEggKeysBuffer = '';
							break;
						}
					}
				}
			}
			#end
		}

		if (initialized && pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		if (swagShader != null && ClientPrefs.data.ft == false)
		{
			if (controls.UI_LEFT)
				swagShader.hue -= elapsed * 0.1;
			if (controls.UI_RIGHT)
				swagShader.hue += elapsed * 0.1;
		}

		if (ClientPrefs.data.ft && ClientPrefs.data.mmm != "AAC V4")
		{
			swagShader.hue += elapsed * 0.1;
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			if (credGroup != null && textGroup != null)
			{
				credGroup.add(money);
				textGroup.add(money);
			}
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if (textGroup != null && credGroup != null)
		{
			var coolText:Alphabet = new Alphabet(0, 0, text, true);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0; // Basically curBeat but won't be skipped if you hold the tab or resize the screen

	public static var closedState:Bool = false;

	override function beatHit()
	{
		super.beatHit();

		if (logoBl != null)
			logoBl.animation.play('bump', true);

		if (gfDance != null)
		{
			danceLeft = !danceLeft;
			if (danceLeft)
				gfDance.animation.play('danceRight');
			else
				gfDance.animation.play('danceLeft');
		}

		if (ClientPrefs.data.mmm == "AAC V4")
		{
			if (logoCanBeat)
			{
				fnf.scale.set(1.06, 1.06);
				anammar.scale.set(1.1, 1.1);
				creativity.scale.set(1.13, 1.13);
			}
		}

		if (!ExitState.inExit || ClientPrefs.data.mmm == "AAC V4")
		{
			FlxTween.tween(FlxG.camera, {zoom: 1.025}, 0.25, {ease: FlxEase.linear, type: BACKWARD});
			// FlxTween.tween(FlxG.camera, {angle: (curBeat % 2 == 0 ? 1.025 : -1.025)}, 0.25, {ease: FlxEase.expoOut, type: BACKWARD});
		}
		else
		{
			FlxTween.tween(FlxG.camera, {zoom: 1});
			// FlxTween.tween(FlxG.camera, {angle: 0});
		}

		if (!closedState)
		{
			sickBeats++;
			if (ClientPrefs.data.mmm != "AAC V4" && ClientPrefs.data.mmm != 'Stay Funky')
			{
				switch (sickBeats)
				{
					case 1:
						// FlxG.sound.music.stop();
						FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm), 0);
						FlxG.sound.music.fadeIn(4, 0, 0.7);
					case 2:
						createCoolText(['Solar Engine'], 15);
					// credTextShit.visible = true;
					case 3:
						addMoreText('By', 15);
					case 4:
						addMoreText('uwenalil', 15);
						addMoreText('VideoBot', 15);
						addMoreText('BaranMuzu', 15);
					case 5:
						deleteCoolText();
					case 6:
						createCoolText(['Psych Engine'], 15);
					case 7:
						addMoreText('By', 15);
					case 8:
						addMoreText('Shadow Mario', 15);
						addMoreText('RiverOaken', 15);
						addMoreText('shubs', 15);
					case 9:
						deleteCoolText();
						ngSpr.visible = false;
					case 10:
						addMoreText(curWacky[0]);
					case 11:
						addMoreText(curWacky[1]);
					case 12:
						addMoreText(curWacky[2]);
					case 13:
						deleteCoolText();
						addMoreText('Friday', -40);
					case 14:
						addMoreText('Night', -40);
					case 15:
						addMoreText("Funkin'", -40);
					case 16:
						addMoreText(unWackyourwacky[0], -20); // credTextShit.text += '\nFunkin';
						addMoreText(unWackyourwacky[1], -20);
						addMoreText(unWackyourwacky[2], -20);
						addMoreText(unWackyourwacky[3], -20);
						addMoreText(unWackyourwacky[4], -20);
					case 17:
						skipIntro();
				}
			}
			else if (ClientPrefs.data.mmm != "Stay Funky")
			{
				switch (sickBeats)
				{
					case 1:
						#if VIDEOS_ALLOWED
						var video:MP4Handler = new MP4Handler();
						video.playVideo("assets/videos/AACIntroUE.mp4");
						#end

						FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm), 0);
						FlxG.sound.music.fadeIn(4, 0, 0.7);
					case 33:
						skipIntro();
				}
			}
			else if (ClientPrefs.data.mmm != "AAC V4" && ClientPrefs.data.mmm == 'Stay Funky')
			{
				switch (sickBeats)
				{
					case 1:
						// FlxG.sound.music.stop();
						FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm), 0);
						FlxG.sound.music.fadeIn(4, 0, 0.7);
						createCoolText(['Solar Engine'], 15);
						addMoreText('By', 15);
						addMoreText('uwenalil', 15);
						addMoreText('VideoBot', 15);
						addMoreText('BaranMuzu', 15);
					case 3:
						deleteCoolText();
						createCoolText(['Psych Engine'], -40);
						addMoreText('By', -40);
						addMoreText('ShadowMario', -40);
						ngSpr.visible = true;
					case 6:
						deleteCoolText();
						ngSpr.visible = false;
						addMoreText(curWacky[0], -20);
					case 7:
						addMoreText(curWacky[1], -20);
					case 8:
						addMoreText(curWacky[2], -20);
					case 9:
						addMoreText('Friday Night');
						addMoreText("Funkin'");
					case 10:
						skipIntro();
				}
			}
		}
	}

	var skippedIntro:Bool = false;
	var increaseVolume:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			if (ClientPrefs.data.mmm == "AAC V4")
			{
				FlxTween.tween(bg, {y: ((720 / 2) - (bg.height / 2))}, 1, {ease: FlxEase.expoOut, startDelay: 0.4});
				FlxTween.tween(fnf, {"scale.x": 1, "scale.y": 1, alpha: 1}, 1, {ease: FlxEase.expoOut, startDelay: 0.3});
				FlxTween.tween(anammar, {"scale.x": 1, "scale.y": 1, alpha: 1}, 1, {ease: FlxEase.expoOut, startDelay: 0.4});
				FlxTween.tween(creativity, {"scale.x": 1, "scale.y": 1, alpha: 1}, 1, {ease: FlxEase.expoOut, startDelay: 0.5});
				FlxTween.tween(blackDots, {alpha: 0.3}, 1, {ease: FlxEase.quadOut, startDelay: 0.6});
			}
			if (playJingle) // Ignore deez
			{
				var easteregg:String = FlxG.save.data.psychDevsEasterEgg;
				if (easteregg == null)
					easteregg = '';
				easteregg = easteregg.toUpperCase();

				var sound:FlxSound = null;
				switch (easteregg)
				{
					case 'RIVER':
						sound = FlxG.sound.play(Paths.sound('JingleRiver'));
					case 'SHUBS':
						sound = FlxG.sound.play(Paths.sound('JingleShubs'));
					case 'SHADOW':
						FlxG.sound.play(Paths.sound('JingleShadow'));
					case 'BBPANZU':
						sound = FlxG.sound.play(Paths.sound('JingleBB'));

					default: // Go back to normal ugly ass boring GF
						remove(ngSpr);
						remove(credGroup);
						FlxG.camera.flash(FlxColor.WHITE, 2);
						skippedIntro = true;
						playJingle = false;

						FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm), 0);
						FlxG.sound.music.fadeIn(4, 0, 0.7);
						return;
				}

				transitioning = true;
				if (easteregg == 'SHADOW')
				{
					new FlxTimer().start(3.2, function(tmr:FlxTimer)
					{
						remove(ngSpr);
						remove(credGroup);
						FlxG.camera.flash(FlxColor.WHITE, 0.6);
						transitioning = false;
					});
				}
				else
				{
					remove(ngSpr);
					remove(credGroup);
					FlxG.camera.flash(FlxColor.WHITE, 3);
					sound.onComplete = function()
					{
						FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm), 0);
						FlxG.sound.music.fadeIn(4, 0, 0.7);
						transitioning = false;
					};
				}
				playJingle = false;
			}
			else // Default! Edit this one!!
			{
				remove(ngSpr);
				remove(credGroup);
				FlxG.camera.flash(FlxColor.WHITE, 4);

				var easteregg:String = FlxG.save.data.psychDevsEasterEgg;
				if (easteregg == null)
					easteregg = '';
				easteregg = easteregg.toUpperCase();
				#if TITLE_SCREEN_EASTER_EGG
				if (easteregg == 'SHADOW')
				{
					FlxG.sound.music.fadeOut();
					if (FreeplayState.vocals != null)
					{
						FreeplayState.vocals.fadeOut();
					}
				}
				#end
			}
			if (ClientPrefs.data.mmm == "AAC V4")
			{
				var timer:FlxTimer = new FlxTimer().start(1.5, function(tmr:FlxTimer)
				{
					logoCanBeat = true;
					fnf.origin.y = 283;
					anammar.origin.y = 283;
					creativity.origin.y = 283;
				});
			}
			skippedIntro = true;
		}
	}
}
