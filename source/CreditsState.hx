package;

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
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	var pisspoop:Array<Array<String>>;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Credits Menu", null);
		#end

		persistentUpdate = true;
		if (ClientPrefs.data.darkmode)
		{
			bg = new FlxSprite(0, 0).loadGraphic(Paths.image("aboutMenu", "preload"));
			add(bg);
			bg.screenCenter();
		}
		else
		{
			bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
			add(bg);
			bg.screenCenter();
		}

		var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
		grid.velocity.set(20, 20);
		grid.alpha = 0;
		FlxTween.tween(grid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		add(grid);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		var path:String = 'modsList.txt';
		if (FileSystem.exists(path))
		{
			var leMods:Array<String> = CoolUtil.coolTextFile(path);
			for (i in 0...leMods.length)
			{
				if (leMods.length > 1 && leMods[0].length > 0)
				{
					var modSplit:Array<String> = leMods[i].split('|');
					if (!Paths.ignoreModFolders.contains(modSplit[0].toLowerCase()) && !modsAdded.contains(modSplit[0]))
					{
						if (modSplit[1] == '1')
							pushModCreditsToList(modSplit[0]);
						else
							modsAdded.push(modSplit[0]);
					}
				}
			}
		}

		var arrayOfFolders:Array<String> = Paths.getModDirectories();
		arrayOfFolders.push('');
		for (folder in arrayOfFolders)
		{
			pushModCreditsToList(folder);
		}
		#end

		if (!ClientPrefs.data.hideOriCredits)
		{
			pisspoop = [
				// Name - Icon name - Description - Link - BG Color
				['Solar Engine DEVs'],
				['Video Bot',					'videobot',			'First DEV, In charge of the HX files',											'https://linktr.ee/videobot',									'14FFFF'],
				['BaranMuzu',					'baranmuzu',		'Second DEV, In charge of the LUA files and other',								'https://linktr.ee/baranmuzu',									'BE9877'],
				[''],
				['Former UE DEV'],
				['uwenalil',					'uwenalil',			'Former DEV, (No Longer) In charge of the LUA, HX files and other',				'https://uwenalil.netlify.app/uwenalil/links',					'008BFF'],
				[''],
				['UE Borrowed Code'],
				['Edwhak', 						'Edwhak', 			'Modchart Tool', 																'https://www.youtube.com/@EDWHAK', 								'00FF00'],
				['Rozebud',						'rozebud',			"Chart Editor's Lil' Buddies",													'https://x.com/helpme_thebigt',									'6D2F83'],
				['  SilverSpringing',			'invis',			'Combo Counter',																'https://gamebanana.com/members/1823951',						'00FFFF'],
				['  Unholywanderer',			'invis',			'Smooth HP',																	'https://gamebanana.com/members/1908754',						'00FFFF'],
				['  Kiruwu',					'invis',			'Weekend 1 Port',																'https://gamebanana.com/mods/512609',							'B3715F'],
				['  Spelo',						'invis',			'Play Both Sides',																'https://www.youtube.com/watch?v=xmUQUi8rd9M',					'FFFFFF'],
				[''],
				['UE Special Thanks'],
				['Blitz',						'Blitz',			'Universe Logo And Playtester',													'https://www.youtube.com/@fireballfurby',						'00FFFF'],
				['An Ammar',					'Ammar',			'Hype Mode, Detached Health Bar, Playtester, Creator of the fancy main menu',	'https://gamebanana.com/mods/381804',							'00FF00'],
				['idiotxd',						'idiotxd',			'His own freakyMenu music and Universe Banner',									'https://x.com/IdiottLool',										'5656FF'],
				['JordanSantiago',				'jor',				'Most of the code of UE comes from JS',											'https://gamebanana.com/tools/13575',							'32CD32'],
				[''],
				["UE PR's"],
				['CharGoldenYT',				'char',				"Fixing Erect chaning difficulty and QOL",										'https://bsky.app/profile/chargoldenyt.bsky.social',			'FFA600'],
				['MoxieCoder',					'moxie',			"Lua Jit Fork superpowers04 PR",												'https://x.com/moxie_specalist',								'00FFFF'],
				['  soushimiya',				'invis',			"Crediting Rozebud",															'https://github.com/soushimiya',								'FFFFFF'],
				[''],
				['Psych Engine Team'],
				['Shadow Mario',				'shadowmario',		'Main Programmer of Psych Engine',												'https://twitter.com/Shadow_Mario_',							'444444'],
				['RiverOaken',					'river',			'Main Artist/Animator of Psych Engine',											'https://twitter.com/RiverOaken',								'B42F71'],
				['shubs',						'shubs',			'Additional Programmer of Psych Engine',										'https://twitter.com/yoshubs',									'5E99DF'],
				[''],
				['Former Engine Members'],
				['bb-panzu',					'bb',				'Ex-Programmer of Psych Engine',												'https://twitter.com/bbsub3',									'3E813A'],
				[""],
				['Engine Contributors'],
				['iFlicky',						'flicky',			'Composer of Psync and Tea Time\nMade the Dialogue Sounds',						'https://twitter.com/flicky_i',									'9E29CF'],
				['SqirraRNG',					'sqirra',			'Crash Handler and Base code for\nChart Editor\'s Waveform',					'https://twitter.com/gedehari',									'E1843A'],
				['EliteMasterEric',				'mastereric',		'Runtime Shaders support',														'https://twitter.com/EliteMasterEric',							'FFBD40'],
				['PolybiusProxy',				'proxy',			'.MP4 Video Loader Library (hxCodec)',											'https://twitter.com/polybiusproxy',							'DCD294'],
				['KadeDev',						'kade',				'Fixed some cool stuff on Chart Editor\nand other PRs',							'https://twitter.com/kade0912',									'64A250'],
				['Keoiki',						'keoiki',			'Note Splash Animations',														'https://twitter.com/Keoiki_',									'D2D2D2'],
				["superpowers04",				"superpowers04",	"LUA JIT Fork",																	"https://x.com/superpowers04",									"B957ED"],
				['Smokey',						'smokey',			'Sprite Atlas Support',															'https://twitter.com/Smokey_5_',								'483D92'],
				[""],
				["Funkin' Crew"],
				["ninjamuffin99",				"ninjamuffin99",	"Programmer of Friday Night Funkin'",											"https://x.com/ninja_muffin99",									"CF2D2D"],
				["PhantomArcade",				"phantomarcade",	"Animator of Friday Night Funkin'",												"https://x.com/PhantomArcade3K",								"FADC45"],
				["evilsk8r",					"evilsk8r",			"Artist of Friday Night Funkin'",												"https://x.com/evilsk8r",										"5ABD4B"],
				["kawaisprite",					"kawaisprite",		"Composer of Friday Night Funkin'",												"https://x.com/kawaisprite",									"378FC7"],
			];
		}
		else
		{ //prevents crash lol
			pisspoop = [
				['', 'invis', 'this is just here to prevent crash when theres no credits lol', '', '000000']
			];
		}

		for (i in pisspoop)
		{
			creditsStuff.push(i);
		}

		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(FlxG.width / 2, 300, creditsStuff[i][0], !isSelectable);
			optionText.isMenuItem = true;
			optionText.targetY = i;
			optionText.changeX = false;
			optionText.snapToPosition();
			grpOptions.add(optionText);

			if (isSelectable)
			{
				if (creditsStuff[i][5] != null)
				{
					Paths.currentModDirectory = creditsStuff[i][5];
				}

				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;

				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Paths.currentModDirectory = '';

				if (curSelected == -1)
					curSelected = i;
			}
			else
				optionText.alignment = CENTERED;
		}

		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("funkin.ttf"), 32, FlxColor.WHITE, CENTER /*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		// descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		add(descText);

		bg.color = getCurrentBGColor();
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!quitting)
		{
			if (creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if (FlxG.keys.pressed.SHIFT)
					shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if (controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if (holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if (controls.ACCEPT && (creditsStuff[curSelected][3] == null || creditsStuff[curSelected][3].length > 4))
			{
				CoolUtil.browserLoad(creditsStuff[curSelected][3]);
			}
			if (controls.BACK)
			{
				if (colorTween != null)
				{
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				if (ClientPrefs.data.moveCreditMods)
					MusicBeatState.switchState(new options.OptionsState());
				else if (ClientPrefs.data.fm)
					MusicBeatState.switchState(new CoolMenuState());
				else
					MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}

		for (item in grpOptions.members)
		{
			if (!item.bold)
			{
				var lerpVal:Float = CoolUtil.boundTo(elapsed * 12, 0, 1);
				if (item.targetY == 0)
				{
					var lastX:Float = item.x;
					item.screenCenter(X);
					item.x = FlxMath.lerp(lastX, item.x - 70, lerpVal);
				}
				else
				{
					item.x = FlxMath.lerp(item.x, 200 + -40 * Math.abs(item.targetY), lerpVal);
				}
			}
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do
		{
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		}
		while (unselectableCheck(curSelected));

		var newColor:Int = getCurrentBGColor();
		if (newColor != intendedColor)
		{
			if (colorTween != null)
			{
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween)
				{
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if (!unselectableCheck(bullShit - 1))
			{
				item.alpha = 0.6;
				if (item.targetY == 0)
				{
					item.alpha = 1;
				}
			}
		}

		descText.text = creditsStuff[curSelected][2];
		descText.y = FlxG.height - descText.height + offsetThing - 60;

		if (moveTween != null)
			moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y: descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}

	#if MODS_ALLOWED
	private var modsAdded:Array<String> = [];

	function pushModCreditsToList(folder:String)
	{
		if (modsAdded.contains(folder))
			return;

		var creditsFile:String = null;
		if (folder != null && folder.trim().length > 0)
			creditsFile = Paths.mods(folder + '/data/credits.txt');
		else
			creditsFile = Paths.mods('data/credits.txt');

		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for (i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if (arr.length >= 5)
					arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
		modsAdded.push(folder);
	}
	#end

	function getCurrentBGColor()
	{
		var bgColor:String = creditsStuff[curSelected][4];
		if (!bgColor.startsWith('0x'))
		{
			bgColor = '0xFF' + bgColor;
		}
		return Std.parseInt(bgColor);
	}

	private function unselectableCheck(num:Int):Bool
	{
		return creditsStuff[num].length <= 1;
	}
}
