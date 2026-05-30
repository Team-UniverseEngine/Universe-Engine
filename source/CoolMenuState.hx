package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.sound.FlxSound;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.FlxSubState;
import flixel.FlxCamera;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;
import lime.app.Application;
#if desktop
import Discord.DiscordClient;
#end
import editors.MasterEditorMenu;

using StringTools;

class CoolMenuState extends MusicBeatState
{
	var bg:FlxSprite;
	var dots:FlxBackdrop;

	var curSelected:Int = 0;
	var menuItems:FlxTypedGroup<MenuText>;
	var selectedSomething:Bool = true;

	var curPage:String = "main";

	var menuPos:Float;

	private var camBG:FlxCamera;
	private var camHUD:FlxCamera;

	public var camOther:FlxCamera;

	private var bgFollow:FlxObject;
	private var hudFollow:FlxObject;

	var menuList:Array<Array<String>>;
	var uselessList:Array<Array<String>> = [['Awards'], ['Donate']];

	var debugKeys:Array<FlxKey>;

	var arrow:FlxSprite;
	var targetArrowX:Float = FlxG.width / 2 + 157 + 300;

	var textBG:FlxSprite;
	var text:FlxText;

	var versionShitUE:FlxText;
	var versionShitPE:FlxText;
	var versionShitFNF:FlxText;

	var menuTween:Bool = false;
	var arrowTween:Bool = false;
	var textTween:Bool = false;
	var versionTween:Bool = false;
	var switching:Bool = false;

	override function create()
	{
		if (ClientPrefs.data.moveCreditMods)
			menuList = [['Story Mode'], ['freeplay'], ['options']];
		else
			menuList = [['Story Mode'], ['freeplay'], ['mods'], ['credits'], ['options']];

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm), 0.7);
		}

		camBG = new FlxCamera();
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;

		ShortcutMenuSubState.inShortcutMenu = false;

		FlxG.cameras.reset(camBG);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camOther, false);
		FlxG.cameras.setDefaultDrawTarget(camBG, true);

		bgFollow = new FlxObject(0, 0, 1, 1);
		bgFollow.setPosition(1280 / 2, 720 / 2);
		hudFollow = new FlxObject(0, 0, 1, 1);
		hudFollow.setPosition(1280 / 2, 720 / 2);
		camBG.follow(bgFollow, LOCKON, 1);
		camHUD.follow(hudFollow, LOCKON, 1);
		CustomFadeTransition.nextCamera = camHUD;

		if (!ClientPrefs.data.darkmode)
		{
			var yScroll:Float = Math.max(0.25 - (0.05 * (menuList.length - 4)), 0.1);
			var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
			bg.scrollFactor.set(0, yScroll);
			bg.setGraphicSize(Std.int(bg.width * 1.175));
			bg.updateHitbox();
			bg.screenCenter();
			bg.antialiasing = ClientPrefs.data.antialiasing;
			bg.cameras = [camBG];
			add(bg);
			if (ClientPrefs.data.cm)
			{
				bg.color = 0xFFfd719b;
			}
			else
			{
				bg.color = 0xFFFDE871;
			}
		}
		else
		{
			var yScroll:Float = Math.max(0.25 - (0.05 * (menuList.length - 4)), 0.1);
			var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('aboutMenu', "preload"));
			bg.scrollFactor.set(0, yScroll);
			bg.setGraphicSize(Std.int(bg.width * 1.175));
			bg.updateHitbox();
			bg.screenCenter();
			bg.antialiasing = ClientPrefs.data.antialiasing;
			bg.cameras = [camBG];
			add(bg);
			if (ClientPrefs.data.cm)
			{
				bg.color = 0xFFfd719b;
			}
			else
			{
				bg.color = 0xFFFDE871;
			}
		}

		dots = new FlxBackdrop(Paths.image("blackDots"), X);
		dots.velocity.x = 24;
		dots.screenCenter();
		dots.alpha = 0.25;
		dots.y = 200;
		dots.cameras = [camBG];
		dots.scrollFactor.set(1, 3.5);
		add(dots);

		menuItems = new FlxTypedGroup<MenuText>();
		add(menuItems);

		var targetX:Float = FlxG.width / 2 + 300;

		versionShitUE = new FlxText(FlxG.width + 2000, FlxG.height - 92, 0, "Solar Engine v: " + MainMenuState.ueVersion, 12);
		versionShitUE.scrollFactor.set();
		versionShitUE.setFormat(Paths.font('funkin.ttf'), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShitUE);
		FlxTween.tween(versionShitUE, {x: targetX}, 2, {
			ease: FlxEase.backOut
		});
		versionShitPE = new FlxText(FlxG.width + 2000, FlxG.height - 72, 0, "Psych Engine v: " + MainMenuState.psychEngineVersion, 12);
		versionShitPE.scrollFactor.set();
		versionShitPE.setFormat(Paths.font('funkin.ttf'), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShitPE);
		FlxTween.tween(versionShitPE, {x: targetX}, 2, {
			ease: FlxEase.backOut,
			startDelay: 0.5
		});
		versionShitFNF = new FlxText(FlxG.width + 2000, FlxG.height - 52, 0, "Friday Night Funkin' v: " + Application.current.meta.get('version'), 12);
		versionShitFNF.scrollFactor.set();
		versionShitFNF.setFormat(Paths.font('funkin.ttf'), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShitFNF);
		FlxTween.tween(versionShitFNF, {x: targetX}, 2, {
			ease: FlxEase.backOut,
			startDelay: 1
		});

		textBG = new FlxSprite(0, FlxG.height + 100).makeGraphic(FlxG.width, 30, 0xFF000000);
		textBG.scrollFactor.set();
		textBG.alpha = 0;
		add(textBG);
		var leText:String = "Press TAB to open the shortcut menu / Press RESET to restart the game";
		var size:Int = 18;
		text = new FlxText(textBG.x + 800, FlxG.height - 30, FlxG.width, leText, size);
		text.setFormat(Paths.font("funkin.ttf"), size, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);

		FlxTween.tween(textBG, {alpha: 0.6, y: FlxG.height - 30}, 1, {
			ease: FlxEase.circOut,
			onComplete: function(tween:FlxTween)
			{
				FlxTween.tween(text, {x: textBG.x - 4, y: textBG.y + 4}, 1, {ease: FlxEase.circOut});
			}
		});

		super.create();

		createMenu();
		changeItem(0);

		CustomFadeTransition.nextCamera = camHUD;

		arrow = new FlxSprite(targetArrowX + 500, 0).loadGraphic(Paths.image('noteupthingg'));
		arrow.screenCenter(Y);
		arrow.angle = 90;
		arrow.scale.set(0.75, -0.75);
		arrow.antialiasing = ClientPrefs.data.antialiasing;
		arrow.scrollFactor.set();
		add(arrow);
		if (ClientPrefs.data.disable2ndpage)
			arrow.alpha = 0;

		FlxTween.tween(arrow, {x: targetArrowX}, 1, {
			ease: FlxEase.backOut,
			startDelay: 1,
			onComplete: function(tween:FlxTween)
			{
				FlxTween.tween(arrow, {"scale.y": 0.75}, 1, {ease: FlxEase.backInOut});
			}
		});
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		var intensity:Float = (curSelected - (menuItems.length / 2)) * ((1 / menuItems.length) * 4);

		hudFollow.y = FlxMath.lerp(hudFollow.y, (720 / 2) + intensity, elapsed * 8);

		if (ClientPrefs.data.sillyBob)
		{
			bgFollow.y = (720 / 2) + Math.abs(Math.sin(((curDecBeat / 2) % 1) * 2 * Math.PI)) * 6;
		}
		else
		{
			bgFollow.y = FlxMath.lerp(bgFollow.y, (720 / 2) + (intensity / 2), elapsed * 8);
		}

		if (!ShortcutMenuSubState.inShortcutMenu && !selectedSomething)
		{
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
			if (controls.ACCEPT)
			{
				doShish();
			}
			if (!ClientPrefs.data.disable2ndpage)
			{
				if (controls.UI_RIGHT_P && curPage != "useless" && !switching)
				{
					switchPage("main"); // switches to useless page
				}
				if (controls.UI_LEFT_P && curPage != "main" && !switching)
				{
					switchPage("useless"); // switches to main page
				}
			}
			if (controls.RESET)
			{
				TitleState.initialized = false;
				TitleState.closedState = false;
				if (FreeplayState.vocals != null)
				{
					FreeplayState.vocals.fadeOut(0.3);
					FreeplayState.vocals = null;
				}
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
			}

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (FlxG.keys.justPressed.TAB)
			{
				openSubState(new ShortcutMenuSubState());
				ShortcutMenuSubState.inShortcutMenu = true;
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				debugTween();
			}
			#end
		}

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (menuTween && textTween && arrowTween && versionTween)
		{
			MusicBeatState.switchState(new MasterEditorMenu());
		}

		super.update(elapsed);
	}

	override function beatHit()
	{
		super.beatHit();
		dots.velocity.x = 24 + 20;
		FlxTween.tween(dots.velocity, {x: 24}, Conductor.crochet / 1000, {ease: FlxEase.quadOut});
	}

	function createMenu()
	{
		curPage = 'main';

		var idd:Int = 0;
		for (menu in menuList)
		{
			var menuName:String = menu[0];
			var menuDesc:String = menu[1];

			var redexcute = ~/r/g;
			var menuItem:MenuText = new MenuText(-800, 60 + (idd * 130), 0, ClientPrefs.data.cm ? redexcute.replace(menuName, 'w') : menuName, 100);
			menuItem.font = Paths.font("Phantomuff/PhantomMuff Difficult Font.ttf");
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.color = (idd == curSelected ? 0xFFFFFFFF : 0xFFA0A0A0);
			menuItem.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xA0000000, 5, 1);
			menuItem.alignment = LEFT;
			menuItem.origin.x = 5;
			menuItem.objectID = idd;
			menuItem.partOf = "main";
			menuItems.add(menuItem);
			menuItems.cameras = [camHUD];

			menuItem.noMove = true;
			FlxTween.tween(menuItem, {x: 50 + (idd == curSelected ? 40 : 0)}, 0.5, {
				ease: FlxEase.backOut,
				startDelay: 0.5 + idd * 0.1,
				onComplete: function(tween:FlxTween)
				{
					menuItem.noMove = false;
				}
			});

			idd++;
		}

		selectedSomething = true;
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			curSelected = 0;
			changeItem(0);
			selectedSomething = false;
		});
	}

	function createUseless()
	{
		curPage = "useless";

		var idd:Int = 0;
		for (menu in uselessList)
		{
			var menuName:String = menu[0];
			var menuDesc:String = menu[1];

			var redexcute = ~/r/g;
			var menuItem:MenuText = new MenuText(-800, 110 + (idd * 130), 0, ClientPrefs.data.cm ? redexcute.replace(menuName, 'w') : menuName, 100);
			menuItem.font = Paths.font("Phantomuff/PhantomMuff Difficult Font.ttf");
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.color = (idd == curSelected ? 0xFFFFFFFF : 0xFFA0A0A0);
			menuItem.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xA0000000, 5, 1);
			menuItem.alignment = LEFT;
			menuItem.origin.x = 5;
			menuItem.objectID = idd;
			menuItem.partOf = "useless";
			menuItems.add(menuItem);
			menuItems.cameras = [camHUD];

			menuItem.noMove = true;
			FlxTween.tween(menuItem, {x: 50 + (idd == curSelected ? 40 : 0)}, 0.5, {
				ease: FlxEase.backOut,
				startDelay: 0.5 + idd * 0.1,
				onComplete: function(tween:FlxTween)
				{
					menuItem.noMove = false;
				}
			});

			idd++;
		}

		selectedSomething = true;
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			curSelected = 0;
			changeItem(0);
			selectedSomething = false;
		});
	}

	function changeItem(amount:Int = 0, noChangeColor:Bool = false):Void
	{
		var prevSelect:Int = curSelected;
		curSelected += amount;

		curSelected = FlxMath.wrap(curSelected, 0, menuItems.length - 1);

		for (member in menuItems)
		{
			member.color = 0xFFA0A0A0;
		} // above var curMember:MenuText

		var curMember:MenuText = menuItems.members[curSelected];

		curMember.color = 0xFFFFFFFF; // below var curMember

		menuItems.forEachAlive(function(member:MenuText)
		{
			if (member.objectID == curSelected)
			{
				FlxTween.cancelTweensOf(member);
				FlxTween.tween(member, {x: menuPos + 20}, 0.5, {ease: FlxEase.expoOut});
			}
			else
			{
				FlxTween.cancelTweensOf(member);
				FlxTween.tween(member, {x: menuPos}, 0.25, {ease: FlxEase.quadIn});
			}
		});
	}

	function doShish()
	{
		FlxG.sound.play(Paths.sound('confirmMenu'));
		selectedSomething = true;

		menuItems.forEachAlive(function(member:MenuText)
		{
			var targetX:Float = member.x - 400 - member.width;
			if (member.objectID == curSelected)
			{
				FlxTween.tween(member, {"scale.x": 1.3, "scale.y": 1.3, x: member.x + 50}, 0.5, {ease: FlxEase.elasticOut});
				FlxTween.tween(member, {x: targetX}, 0.75, {
					ease: FlxEase.backIn,
					startDelay: 0.4,
					onComplete: function(tween:FlxTween)
					{
						selectItem();
						menuItems.remove(member, true);
						member.destroy();
					}
				});
			}
		});
		FlxTween.tween(textBG, {y: FlxG.height + 100}, 1, {ease: FlxEase.backInOut});
		FlxTween.tween(arrow, {x: targetArrowX + 500, "scale.x": -0.75}, 1, {ease: FlxEase.backInOut});
		FlxTween.tween(text, {x: textBG.x + 800}, 1, {ease: FlxEase.backInOut, startDelay: 0.25});
		FlxTween.tween(versionShitUE, {x: FlxG.width + 200}, 1, {ease: FlxEase.backInOut, startDelay: 0.5});
		FlxTween.tween(versionShitPE, {x: FlxG.width + 200}, 1, {ease: FlxEase.backInOut, startDelay: 0.75});
		FlxTween.tween(versionShitFNF, {x: FlxG.width + 200}, 1, {ease: FlxEase.backInOut, startDelay: 1});
	}

	function selectItem():Void
	{
		var selectedButton:String = "";

		if (curPage == "main")
		{
			selectedButton = menuList[curSelected][0].toLowerCase().trim();

			switch (selectedButton)
			{
				case 'story mode':
					LoadingState.loadAndSwitchState(new CoolStoryState());
				case 'freeplay':
					LoadingState.loadAndSwitchState(new FreeplayState());
				case 'mods':
					LoadingState.loadAndSwitchState(new ModsMenuState());
				case 'credits':
					LoadingState.loadAndSwitchState(new CreditsState());
				case 'options':
					LoadingState.loadAndSwitchState(new options.OptionsState());
			}
		}
		if (curPage == "useless")
		{
			selectedButton = uselessList[curSelected][0].toLowerCase().trim();

			switch (selectedButton)
			{
				case 'awards':
					LoadingState.loadAndSwitchState(new AchievementsMenuState());
				case 'donate':
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
					selectedSomething = false;
			}
		}
	}

	function switchPage(page:String)
	{
		curSelected = 0;

		switching = true;

		if (page == "main")
		{
			menuItems.forEachAlive(function(member:MenuText)
			{
				FlxTween.cancelTweensOf(member);
				FlxTween.tween(member, {x: menuPos - 2000}, 0.5, {
					ease: FlxEase.backInOut,
					onComplete: function(tween:FlxTween)
					{
						menuItems.remove(member, true);
						member.destroy();
					}
				});
			});
			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				createUseless();
			});
			FlxTween.tween(arrow, {"scale.y": -0.75, x: FlxG.width / 2 - 157 - 300}, 1, {ease: FlxEase.backInOut});
		}
		if (page == "useless")
		{
			menuItems.forEachAlive(function(member:MenuText)
			{
				FlxTween.cancelTweensOf(member);
				FlxTween.tween(member, {x: menuPos - 2000}, 0.5, {
					ease: FlxEase.backInOut,
					onComplete: function(tween:FlxTween)
					{
						menuItems.remove(member, true);
						member.destroy();
					}
				});
			});
			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				createMenu();
			});
			FlxTween.tween(arrow, {"scale.y": 0.75, x: FlxG.width / 2 + 157 + 300}, 1, {ease: FlxEase.backInOut});
		}
		new FlxTimer().start(2.5, function(tmr:FlxTimer)
		{
			switching = false;
		});
	}

	function debugTween()
	{
		menuItems.forEachAlive(function(member:MenuText)
		{
			FlxTween.cancelTweensOf(member);
			FlxTween.tween(member, {x: menuPos - 2000}, 0.5, {
				ease: FlxEase.backInOut,
				onComplete: function(tween:FlxTween)
				{
					menuItems.remove(member, true);
					member.destroy();
					menuTween = true;
				}
			});
		});
		FlxTween.tween(textBG, {y: FlxG.height + 100}, 1, {ease: FlxEase.backInOut});
		FlxTween.tween(arrow, {x: targetArrowX + 500, "scale.x": -0.75}, 1, {
			ease: FlxEase.backInOut,
			onComplete: function(tween:FlxTween)
			{
				arrowTween = true;
			}
		});
		FlxTween.tween(text, {x: textBG.x + 800}, 1, {
			ease: FlxEase.backInOut,
			startDelay: 0.25,
			onComplete: function(tween:FlxTween)
			{
				textTween = true;
			}
		});
		FlxTween.tween(versionShitUE, {x: FlxG.width + 200}, 1, {ease: FlxEase.backInOut, startDelay: 0.5});
		FlxTween.tween(versionShitPE, {x: FlxG.width + 200}, 1, {ease: FlxEase.backInOut, startDelay: 0.75});
		FlxTween.tween(versionShitFNF, {x: FlxG.width + 200}, 1, {
			ease: FlxEase.backInOut,
			startDelay: 1,
			onComplete: function(tween:FlxTween)
			{
				versionTween = true;
			}
		});
	}
}

class MenuSprite extends FlxSprite
{
	public var objectID:Int = 0;
	public var partner:MenuText;

	public var followPartner:Bool = false;
	public var addX:Float = 0;
	public var addY:Float = 0;

	public var partOf:String = '';
	public var noMove:Bool = false;

	public var lastPos:FlxPoint;

	public function new(X:Float = 0, Y:Float = 0, ?SimpleGraphic:Null<flixel.system.FlxAssets.FlxGraphicAsset>)
	{
		super(X, Y, SimpleGraphic);
		antialiasing = ClientPrefs.data.antialiasing;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (partner != null && followPartner)
		{
			x = partner.x + addX;
			y = partner.y + addY;
		}
	}
}

class MenuText extends FlxText
{
	public var objectID:Int = 0;
	public var partner:MenuText;

	public var partOf:String = '';
	public var noMove:Bool = false;
	public var extraData:Map<String, Dynamic> = new Map<String, Dynamic>();

	public var lastPos:FlxPoint;

	public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, ?Text:String, Size:Int = 8, EmbeddedFont:Bool = true)
	{
		super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
		borderSize = 0.5;
		lastPos = FlxPoint.get(0, 0);
	}

	public function setLastPos():Void
	{
		lastPos.set(x, y);
	}
}
