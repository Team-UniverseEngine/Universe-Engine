package fps;

import openfl.display.Sprite;

/**
 * This class keeps the fpsVar variables updated.
 */
class FPSTicker extends Sprite
{
    public function new()
    {
        super();

        this.x = -100000000; // offscreen.
    }

    @:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
    {
        if (!Main.fpsVar.visible) Main.fpsVar.__enterFrame(Std.int(deltaTime)); // keep up variables.
    }
}