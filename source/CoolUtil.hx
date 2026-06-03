package;

import flixel.FlxG;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import flixel.sound.FlxSound;
#if sys
import sys.io.File;
import sys.FileSystem;
#else
import openfl.utils.Assets;
#end
import sys.io.Process;

import Song.SwagSong;

using StringTools;

class CoolUtil
{
	public static var defaultDifficulties:Array<String> = ['Easy', 'Normal', 'Hard'];
	public static var defaultDifficulty:String = 'Normal'; // The chart that has no suffix and starting difficulty on Freeplay/Story Mode

	public static var difficulties:Array<String> = [];

	public static function updateTheEngine():Void
	{
		// Get the directory of the executable
		var exePath = Sys.programPath();
		var exeDir = haxe.io.Path.directory(exePath);

		// Construct the source directory path based on the executable location
		var sourceDirectory = haxe.io.Path.join([exeDir, "update", "raw"]);
		var sourceDirectory2 = haxe.io.Path.join([exeDir, "update"]);

		// Escape backslashes for use in the batch script
		sourceDirectory = sourceDirectory.split('\\').join('\\\\');

		var excludeFolder = "mods";

		// Construct the batch script with echo statements
		var theBatch = "@echo off\r\n";
		theBatch += "setlocal enabledelayedexpansion\r\n";
		theBatch += "set \"sourceDirectory=" + sourceDirectory + "\"\r\n";
		theBatch += "set \"sourceDirectory2=" + sourceDirectory2 + "\"\r\n";
		theBatch += "set \"destinationDirectory=" + exeDir + "\"\r\n";
		theBatch += "set \"excludeFolder=mods\"\r\n";
		theBatch += "if not exist \"!sourceDirectory!\" (\r\n";
		theBatch += "  echo Source directory does not exist: !sourceDirectory!\r\n";
		theBatch += "  pause\r\n";
		theBatch += "  exit /b\r\n";
		theBatch += ")\r\n";
		theBatch += "taskkill /F /IM UniverseEngine.exe\r\n";
		theBatch += "cd /d \"%~dp0\"\r\n";
		theBatch += "xcopy /e /y \"!sourceDirectory!\" \"!destinationDirectory!\"\r\n";
		theBatch += "rd /s /q \"!sourceDirectory!\"\r\n";
		theBatch += "start /d \"!destinationDirectory!\" UniverseEngine.exe\r\n";
		theBatch += "rd /s /q \"%~dp0\\update\"\r\n";
		theBatch += "del \"%~f0\"\r\n";
		theBatch += "endlocal\r\n";

		// Save the batch file in the executable's directory
		File.saveContent(haxe.io.Path.join([exeDir, "update.bat"]), theBatch);

		// Execute the batch file
		new Process(exeDir + "/update.bat", []);
		Sys.exit(0);
	}

	inline public static function colorFromString(color:String):FlxColor
	{
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if(color.startsWith('0x')) color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if(colorNum == null) colorNum = FlxColor.fromString('#$color');
		return colorNum != null ? colorNum : FlxColor.WHITE;
	}

	inline public static function quantize(f:Float, snap:Float)
	{
		// changed so this actually works lol
		var m:Float = Math.fround(f * snap);
		trace(snap);
		return (m / snap);
	}

	public static function getDifficultyFilePath(num:Null<Int> = null)
	{
		if (num == null)
			num = PlayState.storyDifficulty;

		var fileSuffix:String = difficulties[num];
		if (fileSuffix != defaultDifficulty)
		{
			fileSuffix = '-' + fileSuffix;
		}
		else
		{
			fileSuffix = '';
		}
		return Paths.formatToSongPath(fileSuffix);
	}

	public static function difficultyString():String
	{
		return difficulties[PlayState.storyDifficulty].toUpperCase();
	}

	inline public static function boundTo(value:Float, min:Float, max:Float):Float
	{
		return Math.max(min, Math.min(max, value));
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];
		#if sys
		if (FileSystem.exists(path))
			daList = File.getContent(path).trim().split('\n');
		#else
		if (Assets.exists(path))
			daList = Assets.getText(path).trim().split('\n');
		#end

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function dominantColor(sprite:flixel.FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = [];
		for (col in 0...sprite.frameWidth)
		{
			for (row in 0...sprite.frameHeight)
			{
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if (colorOfThisPixel != 0)
				{
					if (countByColor.exists(colorOfThisPixel))
					{
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					}
					else if (countByColor[colorOfThisPixel] != 13520687 - (2 * 13520687))
					{
						countByColor[colorOfThisPixel] = 1;
					}
				}
			}
		}
		var maxCount = 0;
		var maxKey:Int = 0; // after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
		for (key in countByColor.keys())
		{
			if (countByColor[key] >= maxCount)
			{
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}

	public static function coolError(message:Null<String> = null, title:Null<String> = null):Void
	{
		#if !linux
		lime.app.Application.current.window.alert(message, title);
		#else
		trace(title + " - " + message);

		var text:FlxText = new FlxText(8, 0, 1280, title + " - " + message, 24);
		text.color = FlxColor.RED;
		text.borderSize = 1.5;
		text.borderColor = FlxColor.BLACK;
		text.scrollFactor.set();
		text.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		FlxG.state.add(text);

		FlxTween.tween(text, {alpha: 0, y: 8}, 5, {
			onComplete: function(_)
			{
				FlxG.state.remove(text);
				text.destroy();
			}
		});
		#end
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	// uhhhh does this even work at all? i'm starting to doubt
	public static function precacheSound(sound:String, ?library:String = null):Void
	{
		Paths.sound(sound, library);
	}

	public static function precacheMusic(sound:String, ?library:String = null):Void
	{
		Paths.music(sound, library);
	}

	public static function browserLoad(site:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	public static function getNoteAmount(song:SwagSong, ?bothSides:Bool = true, ?oppNotes:Bool = false):Int
	{
		var total:Int = 0;
		for (section in song.notes)
		{
			if (bothSides)
				total += section.sectionNotes.length;
			else
			{
				for (songNotes in section.sectionNotes)
				{
					if (!oppNotes && (songNotes[1] < 4 ? section.mustHitSection : !section.mustHitSection))
						total += 1;
					if (oppNotes && (songNotes[1] < 4 ? !section.mustHitSection : section.mustHitSection))
						total += 1;
				}
			}
		}
		return total;
	}
}
