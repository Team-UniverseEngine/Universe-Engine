package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.util.FlxGradient;

class ShortcutMenuSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	public static var inShortcutMenu = false;

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['Title Screen', 'Menus', 'Modes', 'Options'];
	var menuItemsSongs:Array<String> = ['Story Mode', 'Freeplay', 'Back'];
	var menuItemsMenu:Array<String> = ['Main Menu', 'Mods Menu', 'Back'];
	//var menuItemsOptions:Array<String> = ['Solar', 'Psych', 'Back'];

	var curSelected:Int = 0;

	public var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);

	var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));

	public function new()
	{
		super();

		menuItems = menuItemsOG;

		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		grid.velocity.set(20, 20);
		grid.alpha = 0;
		FlxTween.tween(grid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		add(grid);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		regenMenu();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath('shortcut'), "shared"), 0);
		FlxG.sound.music.fadeIn(4, 0, 0.7);
	}

	override function update(elapsed)
	{
		super.update(elapsed);

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var canceled = controls.BACK;

		if (canceled)
		{
			inShortcutMenu = false;
			for (i in 0...grpMenuShit.members.length)
			{
				var obj = grpMenuShit.members[0];
				obj.kill();
				grpMenuShit.remove(obj, true);
				obj.destroy();
			}
			FlxTween.tween(bg, {alpha: 0}, 1.5, {ease: FlxEase.quartInOut});
			FlxTween.tween(grid, {alpha: 0}, 1, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween)
				{
					FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm));
					close();
				}
			});
		}
		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		if (accepted && !ClientPrefs.data.controllerMode)
		{
			var daSelected:String = menuItems[curSelected];
			switch (daSelected)
			{
				case 'Title Screen':
					FlxG.switchState(new TitleState());
					FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm));
					inShortcutMenu = false;
				case 'Menus':
					menuItems = menuItemsMenu;
					regenMenu();
				case 'Modes':
					menuItems = menuItemsSongs;
					regenMenu();
				case 'Options':
					FlxG.switchState(new options.OptionsState());
					FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm));
					inShortcutMenu = false;
			}
			
			if (menuItems == menuItemsSongs)
			{
				switch (daSelected)
				{
					case 'Story Mode':
						if (ClientPrefs.data.fm)
						{
							FlxG.switchState(new CoolStoryState());
						}
						else
						{
							FlxG.switchState(new StoryMenuState());
						}
						inShortcutMenu = false;
					case 'Freeplay':
						FlxG.switchState(new FreeplayState());
						FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm));
						inShortcutMenu = false;
					case 'Back':
						menuItems = menuItemsOG;
						regenMenu();
				}
			}
			if (menuItems == menuItemsMenu)
			{
				switch (daSelected)
				{
					case 'Main Menu':
						if (ClientPrefs.data.fm)
						{
							MusicBeatState.switchState(new CoolMenuState());
						}
						else
						{
							MusicBeatState.switchState(new MainMenuState());
						}
						FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm));
						inShortcutMenu = false;
					case 'Mods Menu':
						FlxG.switchState(new ModsMenuState());
						FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm));
						inShortcutMenu = false;
					case 'Back':
						menuItems = menuItemsOG;
						regenMenu();
				}
			}
			/* if (menuItems == menuItemsOptions)
			{
				switch (daSelected)
				{
					case 'Solar':
						FlxG.switchState(new options.UniverseOptionsMenu());
						inShortcutMenu = false;
					case 'Psych':
						FlxG.switchState(new options.OptionsState());
						inShortcutMenu = false;
					case 'Back':
						menuItems = menuItemsOG;
						regenMenu();
				}
			} */
		}
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	function regenMenu():Void
	{
		for (i in 0...grpMenuShit.members.length)
		{
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}

		for (i in 0...menuItems.length)
		{
			var item = new Alphabet(90, 320, menuItems[i], true);
			item.isMenuItem = true;
			item.targetY = i;
			item.changeX = false;
			item.screenCenter(X);
			grpMenuShit.add(item);
		}
		curSelected = 0;
		changeSelection();
	}
}
