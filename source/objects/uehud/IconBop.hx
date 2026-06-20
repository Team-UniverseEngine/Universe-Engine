package objects.uehud;

import flixel.math.FlxMath;

/**
 *  This can literally just be put in PlayState, but to keep with the spirit of the other script recreations, I'll put it here.
 */
class IconBop extends BaseScript
{
    // Generic Values
    var funnies:Int = 1;
    var funnies64:Float = 0.5;
    var funnies2:Int = 25; // angle at which the the icons get set to.
    var nuhuhy:Float = 0.7;
    var nuhuhx:Float = 1.2;

    // Tweens
        // iconP1
    var iconP1ANG:FlxTween;
    var iconP1_1x:FlxTween;
    var iconP1_1y:FlxTween;
    var iconP1_2x:FlxTween;
    var iconP1_2y:FlxTween;

        // iconP2
    var iconP2ANG:FlxTween;
    var iconP2_1x:FlxTween;
    var iconP2_1y:FlxTween;
    var iconP2_2x:FlxTween;
    var iconP2_2y:FlxTween;

    function cancelTweens()
    {
        if (iconP1ANG != null)
            iconP1ANG.cancel();
        if (iconP2ANG != null)
            iconP2ANG.cancel();

        if (iconP1_1x != null)
            iconP1_1x.cancel();
        if (iconP1_1y != null)
            iconP1_1y.cancel();
        if (iconP2_1x != null)
            iconP2_1x.cancel();
        if (iconP2_1y != null)
            iconP2_1y.cancel();

        if (iconP1_2x != null)
            iconP1_2x.cancel();
        if (iconP1_2y != null)
            iconP1_2y.cancel();
        if (iconP2_2x != null)
            iconP2_2x.cancel();
        if (iconP2_2y != null)
            iconP2_2y.cancel();
    }

    function pauseTweens()
    {
        if (iconP1ANG != null)
            iconP1ANG.active = false;
        if (iconP2ANG != null)
            iconP2ANG.active = false;

        if (iconP1_1x != null)
            iconP1_1x.active = false;
        if (iconP1_1y != null)
            iconP1_1y.active = false;
        if (iconP2_1x != null)
            iconP2_1x.active = false;
        if (iconP2_1y != null)
            iconP2_1y.active = false;

        if (iconP1_2x != null)
            iconP1_2x.active = false;
        if (iconP1_2y != null)
            iconP1_2y.active = false;
        if (iconP2_2x != null)
            iconP2_2x.active = false;
        if (iconP2_2y != null)
            iconP2_2y.active = false;
    }

    function resumeTweens()
    {
        if (iconP1ANG != null)
            iconP1ANG.active = true;
        if (iconP2ANG != null)
            iconP2ANG.active = true;

        if (iconP1_1x != null)
            iconP1_1x.active = true;
        if (iconP1_1y != null)
            iconP1_1y.active = true;
        if (iconP2_1x != null)
            iconP2_1x.active = true;
        if (iconP2_1y != null)
            iconP2_1y.active = true;

        if (iconP1_2x != null)
            iconP1_2x.active = true;
        if (iconP1_2y != null)
            iconP1_2y.active = true;
        if (iconP2_2x != null)
            iconP2_2x.active = true;
        if (iconP2_2y != null)
            iconP2_2y.active = true;
    }

    function beat1()
    {
        game.iconP2.angle = funnies2;
        iconP2ANG = FlxTween.tween(game.iconP2, {angle: 0}, funnies, {ease: FlxEase.expoOut});

        game.iconP1.angle = funnies2;
        iconP1ANG = FlxTween.tween(game.iconP1, {angle: 0}, funnies, {ease: FlxEase.expoOut});

        setScale(1);

        iconP1_1x = FlxTween.tween(game.iconP1.scale, {x: 1}, funnies64, {ease: FlxEase.expoOut});
        iconP1_1y = FlxTween.tween(game.iconP1.scale, {y: 1}, funnies64, {ease: FlxEase.expoOut});
        iconP2_1x = FlxTween.tween(game.iconP2.scale, {x: 1}, funnies64, {ease: FlxEase.expoOut});
        iconP2_1y = FlxTween.tween(game.iconP2.scale, {y: 1}, funnies64, {ease: FlxEase.expoOut});
    }

    function setScale(beat:Int)
    {
        var p1Scale:FlxPoint = new FlxPoint(nuhuhx, nuhuhy);
        var p2Scale:FlxPoint = new FlxPoint(nuhuhx, nuhuhy);
        #if SILLY_OPTIONS
        if (PlayState.instance.healthBar.percent < 20)
        {
            p1Scale.set(1, 0.5);
            p2Scale.set(1.4, 0.9);
            game.iconP2.angle = beat == 1 ? 50 : -50;
            game.iconP1.angle = beat == 1 ? 15 : -15;
        }

        if (PlayState.instance.healthBar.percent > 80)
        {
            p2Scale.set(1, 0.5);
            p1Scale.set(1.4, 0.9);
            game.iconP1.angle = beat == 1 ? 50 : -50;
            game.iconP2.angle = beat == 1 ? 15 : -15;
        }
        #end
            
        PlayState.instance.iconP1.scale.set(p1Scale.x, p1Scale.y);
        PlayState.instance.iconP2.scale.set(p2Scale.x, p2Scale.y);

        PlayState.instance.iconP1.updateHitbox();
        PlayState.instance.iconP2.updateHitbox();
    }

    function beat2()
    {
        game.iconP2.angle = -funnies2;
        iconP2ANG = FlxTween.tween(game.iconP2, {angle: 0}, funnies, {ease: FlxEase.expoOut});

        game.iconP1.angle = -funnies2;
        iconP1ANG = FlxTween.tween(game.iconP1, {angle: 0}, funnies, {ease: FlxEase.expoOut});

        setScale(2);

        iconP1_1x = FlxTween.tween(game.iconP1.scale, {x: 1}, funnies64, {ease: FlxEase.expoOut});
        iconP1_1y = FlxTween.tween(game.iconP1.scale, {y: 1}, funnies64, {ease: FlxEase.expoOut});
        iconP2_1x = FlxTween.tween(game.iconP2.scale, {x: 1}, funnies64, {ease: FlxEase.expoOut});
        iconP2_1y = FlxTween.tween(game.iconP2.scale, {y: 1}, funnies64, {ease: FlxEase.expoOut});
    }

    public override function onBeatHit() {
        super.onBeatHit();
        
        if (ClientPrefs.data.ib)
        {
            if (curBeat % 1 == 0)
            {
                cancelTweens();
                beat1();
            }
            if (curBeat % 2 == 0)
            {
                cancelTweens();
                beat2();
            }
        }
        else
        {
            game.iconP1.scale.set(1.2, 1.2);
            game.iconP2.scale.set(1.2, 1.2);

            game.iconP1.updateHitbox();
            game.iconP2.updateHitbox();
        }
    }

    public override function updatePost(elapsed:Float) {
        super.updatePost(elapsed);

        if (!ClientPrefs.data.ib)
        {
            var mult:Float = FlxMath.lerp(1, game.iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9 * game.playbackRate), 0, 1));
            game.iconP1.scale.set(mult, mult);
            game.iconP1.updateHitbox();

            var mult:Float = FlxMath.lerp(1, game.iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9 * game.playbackRate), 0, 1));
            game.iconP2.scale.set(mult, mult);
            game.iconP2.updateHitbox();

            var iconOffset:Int = 26;

            game.iconP1.x = game.healthBar.x
                + (game.healthBar.width * (FlxMath.remapToRange(game.healthBar.percent, 0, 100, 100, 0) * 0.01))
                + (150 * game.iconP1.scale.x - 150) / 2
                - iconOffset;
            game.iconP2.x = game.healthBar.x
                + (game.healthBar.width * (FlxMath.remapToRange(game.healthBar.percent, 0, 100, 100, 0) * 0.01))
                - (150 * game.iconP2.scale.x) / 2
                - iconOffset * 2;
        }
    }

    public override function onSongStart() {
        super.onSongStart();

        beat2();
    }

    public override function onPause() {
        super.onPause();

        pauseTweens();
    }

    public override function onResume() {
        super.onResume();

        resumeTweens();
    }
}