package fps;

import openfl.display.Sprite;
import openfl.display.BitmapData;
import flixel.math.FlxMath;
import fps.FPSExtended.ValueDef;

private class FPS_Render extends FlxText
{
    public var value:ValueDef;

    public function new(x:Float, y:Float, name:String, defaultValue:Dynamic, ?getter:Void->Dynamic = null, ?formatter:(String, Dynamic)->String = null, ?font:String = "assets/fonts/funkin.ttf", fontSize:Int = 14)
    {
        value = new ValueDef(name, defaultValue, getter, formatter);
        super(x,y,0, value.formatter(value.text, value.getValue));

        setFormat(font, fontSize, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
    }
}

/**
 * Actual logic and backend.
 */
class FancyFPS extends FlxTypedSpriteGroup<FPS_Render>
{
    var maxMemMegas:Float = 0;

    public function new()
    {
        super();

        var FPS:FPS_Render = new FPS_Render(0, 10, "", 0, ()->return Main.fpsVar.currentFPS, null, Paths.font("vcr.ttf"), 30);
        add(FPS);

        var FPSText:FPS_Render = new FPS_Render(40, 24, "FPS", "", null, null, Paths.font("vcr.ttf"));
        add(FPSText);

        var memUsed:FPS_Render = new FPS_Render(90, 24, "", () -> {
            if (Main.fpsVar.memoryMegas > maxMemMegas) maxMemMegas = Main.fpsVar.memoryMegas;
            return Main.fpsVar.memoryMegas;
        }, (S,D)->{
            var memText:String = '$D MB';
            var memoryMegas:Float = Main.fpsVar.memoryMegas;

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

            return memText;
        }, Paths.font("vcr.ttf"));
        add(memUsed);


        var memMax:FPS_Render = new FPS_Render(175, 24, "", 0, (S,D)->{
            var memText:String = '$D MB';
            var memoryMegas:Float = maxMemMegas;

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

            return memText;
        }, Paths.font("vcr.ttf"));
        memMax.alpha = 0.6;
        add(memMax);

        var engineUsed:FPS_Render = new FPS_Render(0, 40, "Solar Engine " + MainMenuState.ueVersion + " | PSych 0.6.3", "", null, null, Paths.font("vcr.ttf"));
        add(engineUsed);
    }
}

/**
 * Actual display
 */
class FancyFPSDisplay extends Sprite
{
	var fancyFPS:FancyFPS = null;

	public function new(X:Float = 0, Y:Float = 0)
	{
		super();

		this.x;
		this.y;

		fancyFPS = new FancyFPS();

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		fancyFPS.update(deltaTime);
		var i_width:Float = fancyFPS.width;
		var i_height:Float = fancyFPS.height; // need this to draw that shi-

		graphics.clear();
		graphics.beginBitmapFill(fancyFPS.pixels);
		graphics.moveTo(0, 0);
		graphics.lineTo(0, i_height);
		graphics.lineTo(i_width, i_height);
		graphics.lineTo(i_width, 0); // if I did this right, should render a rect.
	}
}