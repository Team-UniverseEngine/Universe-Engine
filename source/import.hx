#if !macro
import Paths;
#if VIDEOS_ALLOWED 
	#if (hxCodec <= "2.5.1") // hxcodec fix *yay sound effect*
	import vlc.MP4Handler;
	#elseif (hxCodec <= "2.6.1")
	import hxcodec.VideoHandler as MP4Handler;
	#else
	import hxCodec.flixel.FlxVideo as MP4Handler;
	#end
#end
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxObject;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
#if (flixel >= "6.0.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import sys.TempStateData.instance as StateData;
#end