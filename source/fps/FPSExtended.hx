package fps;

import flixel.FlxSubState;
import openfl.display.Shape;
import openfl.display.Sprite;
import lime.app.Application;
import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.math.FlxMath;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#if flash
import openfl.Lib;
#end

#if openfl
import openfl.system.System;
#end

class ValueDef
{
	public var text:String = "";
	public var value:Dynamic = null;
	public var formatter:Null<(String, Dynamic)->String> = null;
	public var valueGetter:Null<Void->Dynamic> = null;

	public function new(text:String, defaultValue:Dynamic, ?getter:Null<Void->Dynamic> = null, ?formatter:Null<(String, Dynamic)->String> = null)
	{
		this.text = text;
		this.value = defaultValue;
		this.formatter = formatter ?? defaultFormatter;
		this.valueGetter = getter;
	}

	public function getValue():Dynamic
	{
		if (valueGetter != null)
			value = valueGetter();

		return value;
	}

	function defaultFormatter(name:String, value:Dynamic):String
	{
		return text + Std.string(getValue()); // skip args because its in the class
	}
}

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:allow(FPSTicker)
class FPSDisplay extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;
	public var memoryMegas(default, null):Float = 0;
	public static var currentState:String = "";
	public static var addtlVars:Array<ValueDef> = [];

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(Paths.font('funkin.ttf'), 14, color);
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);
		if (currentFPS > ClientPrefs.data.framerate) currentFPS = ClientPrefs.data.framerate;

		if (currentCount != cacheCount /*&& visible*/)
		{
			text = "FPS: " + currentFPS;
			
			memoryMegas = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 1));
			var memText:String = memoryMegas + " MB";
			if (ClientPrefs.data != null && ClientPrefs.data.extendedFPS)
			{
				if (memoryMegas < 1)
				{
					if (memoryMegas * 1000 < 1)
					{
						var memVal = FlxMath.roundDecimal((memoryMegas * 1000) * 1000, 1);
						memText = '${memVal} B'; // rarely actually this low.
					}
					else
					{
						var memVal = FlxMath.roundDecimal(memoryMegas * 1000, 1);
						memText = '${memVal} KB'; // rarely actually this low.
					}
				}
				else
				{
					if (memoryMegas / 1000 >= 1)
					{
						memText = '${FlxMath.roundDecimal(memoryMegas / 1000, 1)} GB'; 
					}
				}
			}
			text += "\nMemory: " + memText;
			if (ClientPrefs.data != null && ClientPrefs.data.extendedFPS)
			{
				text += "\nSPF: " + Math.floor((1/currentFPS)*100)/100 + " MS";
				text += "\nCurrent State: " + currentState;

				for (def in addtlVars)
				{
					text += '\n${def.formatter(def.text, def.getValue())}';
				}
			}

			textColor = 0xFFFFFFFF;
			if (memoryMegas > 3000 || currentFPS <= ClientPrefs.data.framerate / 2)
			{
				textColor = 0xFFFF0000;
			}

			#if (gl_stats && !disable_cffi && (!html5 || !canvas))
			text += "\ntotalDC: " + Context3DStats.totalDrawCalls();
			text += "\nstageDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE);
			text += "\nstage3DDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D);
			#end
			text += "\n";
		}

		cacheCount = currentCount;
	}
}

// Some code from: https://github.com/FunkinCrew/Funkin/blob/main/source/funkin/ui/debug/stats/FunkinStatsGraph.hx
class FPSExtended extends Sprite
{
	public var bgAlpha(default, set):Float = 0.5;
	public var bg:Sprite;
	public var FPS:FPSDisplay;
	public var bgColor:FlxColor = 0x464646;
	public var currentFPS(get, null):Int;
	public var memoryMegas(get, null):Float;
	public static var currentState(default, set):String;
	var axisWidth(get, never):Float;
	var axisHeight(get, never):Float;
	@:isVar public var addtlVars(get, set):Array<ValueDef>;
	function get_currentFPS():Int return FPS.currentFPS;
	function get_memoryMegas():Float return FPS.memoryMegas;
	function get_addtlVars():Array<ValueDef> return FPSDisplay.addtlVars;
	function set_addtlVars(a:Array<ValueDef>):Array<ValueDef> return FPSDisplay.addtlVars = a;
	public static final defVars:Array<ValueDef> = [
		new ValueDef("Current Substate: ", null, function ():String{
			var value:String = null;
			var subState:Null<FlxSubState> = FlxG.state.subState;

			if (subState != null)
			{
				value = Type.getClassName(Type.getClass(subState));
			}

			return value;
		}),
		new ValueDef("Solar Version: ", MainMenuState.ueVersion),
	];

	static function set_currentState(v:String):String return FPSDisplay.currentState = v;
	function set_bgAlpha(v:Float):Float return bg.alpha = v;
	function get_axisWidth():Float return FPS.width;
	function get_axisHeight():Float return FPS.height;

	public function new(x:Float = 10, y:Float = 10, BGColor:FlxColor = 0x464646)
	{
		super();

		this.x = x;
		this.y = y;
		this.bgColor = BGColor;

		FPS = new FPSDisplay(0, 0);
		bg = new Sprite();
		bg.alpha = bgAlpha;
		drawBG();
		addChild(bg);
		addChild(FPS);
		addtlVars = defVars;
	}

	/**
	 * Resets the watch variables.
	 */
	public function defaultAddtlVars()
	{
		FPSDisplay.addtlVars = [];
		
		for (def in defVars)
		{
			FPSDisplay.addtlVars.push(def);
		}
	}

	public function addWatchVariable(text:String, defaultValue:Dynamic, ?getter:Null<Void->Dynamic> = null, ?formatter:Null<(String, Dynamic)->String> = null)
	{
		addtlVars.push(new ValueDef(text, defaultValue, getter, formatter));
	}

	public function updateBox()
	{
		drawBG();
	}

	function drawBG()
	{
		bg.graphics.clear();
		bg.graphics.lineStyle(1, bgColor, 1, false, null, null, MITER, 255);
		bg.graphics.beginFill(bgColor);
		bg.graphics.drawRect(0,0,axisWidth,axisHeight);
	}
}