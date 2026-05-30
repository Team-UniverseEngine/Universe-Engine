package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.math.FlxPoint;

using StringTools;

class MainMenuUselessState extends MusicBeatState
{
	public static var curSelected:Int = 0;

	var reset = controls.RESET;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	public var arrow:FlxSprite;

	var optionShit:Array<String> = [#if ACHIEVEMENTS_ALLOWED 'awards', #end#if !switch 'donate', #end];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;

	// var debugKeys:Array<FlxKey>;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		ShortcutMenuSubState.inShortcutMenu = false;

		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		// debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm), 0.7);
		}

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);

		if (ClientPrefs.data.darkmode)
		{
			var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("aboutMenu", "preload"));
			bg.color = 0xFFFDE871;
			bg.scrollFactor.set(0, yScroll);
			bg.setGraphicSize(Std.int(bg.width * 1.175));
			bg.updateHitbox();
			bg.screenCenter();
			bg.antialiasing = ClientPrefs.data.antialiasing;
			add(bg);
		}
		else if (ClientPrefs.data.cm)
		{
			var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
			bg.scrollFactor.set(0, yScroll);
			bg.setGraphicSize(Std.int(bg.width * 1.175));
			bg.updateHitbox();
			bg.screenCenter();
			bg.antialiasing = ClientPrefs.data.antialiasing;
			bg.color = 0xFFfd719b;
			add(bg);
		}
		else
		{
			var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
			bg.scrollFactor.set(0, yScroll);
			bg.setGraphicSize(Std.int(bg.width * 1.175));
			bg.updateHitbox();
			bg.screenCenter();
			bg.antialiasing = ClientPrefs.data.antialiasing;
			add(bg);
		}

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		if (ClientPrefs.data.darkmode)
		{
			magenta = new FlxSprite(0, 0).loadGraphic(Paths.image("aboutMenu", "preload"));
			magenta.scrollFactor.set(0, yScroll);
			magenta.setGraphicSize(Std.int(magenta.width * 1.175));
			magenta.updateHitbox();
			magenta.screenCenter();
			magenta.visible = false;
			magenta.antialiasing = ClientPrefs.data.antialiasing;
			magenta.color = 0xFFfd719b;
			add(magenta);
		}
		else
		{
			magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
			magenta.scrollFactor.set(0, yScroll);
			magenta.setGraphicSize(Std.int(magenta.width * 1.175));
			magenta.updateHitbox();
			magenta.screenCenter();
			magenta.visible = false;
			magenta.antialiasing = ClientPrefs.data.antialiasing;
			magenta.color = 0xFFfd719b;
			add(magenta);
		}

		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140) + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if (optionShit.length < 6)
				scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			// menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 64, 0, "Solar Engine v: " + MainMenuState.ueVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font('funkin.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v: " + MainMenuState.psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font('funkin.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v: " + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font('funkin.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		/*
			var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 30).makeGraphic(FlxG.width, 30, 0xFF000000);
			textBG.scrollFactor.set();
			textBG.alpha = 0.6;
			add(textBG);
			var leText:String = "Prees Left Arrow To switch to MainMenuState";
			var size:Int = 18;
			var text:FlxText = new FlxText(textBG.x - 4, textBG.y + 4, FlxG.width, leText, size);
			text.setFormat(Paths.font("funkin.ttf"), size, FlxColor.WHITE, RIGHT);
			text.scrollFactor.set();
			add(text);
		 */

		arrow = new FlxSprite(FlxG.width / 2 + 157 - 760, 0).loadGraphic(Paths.image('noteupthingg'));
		arrow.screenCenter(Y);
		arrow.angle = -90;
		arrow.scale.set(0.75,0.75);
		arrow.antialiasing = ClientPrefs.data.antialiasing;
		arrow.scrollFactor.set();
		add(arrow);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
		{
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if (!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2]))
			{ // It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement()
	{
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin && !ShortcutMenuSubState.inShortcutMenu)
		{
			if (controls.RESET)
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

			var shiftMult:Int = 1;
			if (FlxG.keys.pressed.SHIFT)
				shiftMult = 3;
			if (FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				changeItem(-shiftMult * FlxG.mouse.wheel);
			}

			if (controls.UI_LEFT_P)
			{
				MusicBeatState.switchState(new MainMenuState());
				//MusicBeatState.switchState(new CustomFadeTransition(), true);
			}

			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if (ClientPrefs.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if (menuItems.length > 4)
				{
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}

	override function openSubState(SubState:FlxSubState)
	{
		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		super.closeSubState();
	}

	override public function onFocus():Void
	{
		super.onFocus();
	}
}
