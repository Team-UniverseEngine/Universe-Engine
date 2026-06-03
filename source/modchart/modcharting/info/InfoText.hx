package modchart.modcharting.info;

import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import flash.filters.ColorMatrixFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;

class InfoText extends FlxSubState
{
	var bg:FlxSprite;

	var screen:FlxSprite;

	var exit:FlxButton;

	var infoBG:FlxSprite;
	var infoText:FlxText;

	var arrowRight:FlxSprite;
	var arrowLeft:FlxSprite;

	var targetXRight:Float = FlxG.width / 2 + 157 + 300;
	var targetXLeft:Float = FlxG.width / 2 - 157 - 450;

	override function create()
	{
		screen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		var waveEffect = new FlxWaveEffect(FlxWaveMode.ALL, 69, -1, 4, 4);
		var waveSprite = new FlxEffectSprite(screen, [waveEffect]);
		waveSprite.alpha = 0;
		add(waveSprite);

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scale.set(0, 0);
		add(bg);

		exit = new FlxButton(FlxG.width / 2 + 557, FlxG.height / 2 - 250, "X", function()
		{
			FlxTween.tween(bg, {"scale.x": 0.01}, 0.5, {ease: FlxEase.circOut});
			FlxTween.tween(bg, {"scale.y": 0}, 1, {
				ease: FlxEase.circOut,
				startDelay: 0.5,
				onComplete: function(tween:FlxTween)
				{
					close();
				}
			});
			FlxTween.tween(infoBG, {"scale.y": 0, "scale.x": 0}, 1, {ease: FlxEase.circOut});
			FlxTween.tween(infoText, {"scale.y": 0, "scale.x": 0}, 0.5, {ease: FlxEase.circOut});
			FlxTween.tween(arrowRight, {"scale.x": -0.75, x: targetXRight + 500}, 1, {ease: FlxEase.backInOut});
			FlxTween.tween(arrowLeft, {"scale.x": -0.75, x: targetXLeft - 500}, 1, {ease: FlxEase.backInOut});
			FlxTween.tween(waveSprite, {alpha: 0}, 1, {ease: FlxEase.linear});
		});
		exit.updateHitbox();
		exit.scale.x = 0.5;
		add(exit);

		infoBG = new FlxSprite().makeGraphic(500, 400, FlxColor.GRAY);
		infoBG.scale.set(0, 0);
		infoBG.angle = 360;
		infoBG.screenCenter();
		add(infoBG);

		infoText = new FlxText(0, 0, 0, "This is a tutorial about \n the modchart editor", 32);
		infoText.setFormat(Paths.font("funkin.ttf"), 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		infoText.screenCenter();
		infoText.alpha = 0;
		add(infoText);

		arrowRight = new FlxSprite(targetXRight + 500, 0).loadGraphic(Paths.image("noteupthingg"));
		arrowRight.scale.set(0.75, -0.75);
		arrowRight.angle = 90;
		arrowRight.screenCenter(Y);
		add(arrowRight);

		arrowLeft = new FlxSprite(targetXLeft - 500, 0).loadGraphic(Paths.image("noteupthingg"));
		arrowLeft.scale.set(0.75, -0.75);
		arrowLeft.angle = -90;
		arrowLeft.screenCenter(Y);
		add(arrowLeft);

		FlxTween.tween(bg, {"scale.x": 1, "scale.y": 1}, 1, {ease: FlxEase.backOut});
		FlxTween.tween(infoBG, {"scale.x": 1, "scale.y": 1, angle: 0}, 1, {ease: FlxEase.backOut});
		FlxTween.tween(infoText, {"alpha": 1}, 1, {ease: FlxEase.circOut, startDelay: 1});
		FlxTween.tween(arrowRight, {x: targetXRight}, 1, {
			ease: FlxEase.backOut,
			onComplete: function(tween:FlxTween)
			{
				FlxTween.tween(arrowRight, {"scale.y": 0.75}, 1, {ease: FlxEase.backInOut});
			}
		});
		FlxTween.tween(arrowLeft, {x: targetXLeft}, 1, {
			ease: FlxEase.backOut,
			onComplete: function(tween:FlxTween)
			{
				FlxTween.tween(arrowLeft, {"scale.y": 0.75}, 1, {ease: FlxEase.backInOut});
			}
		});
		FlxTween.tween(waveSprite, {alpha: 1}, 1, {ease: FlxEase.linear});

		screen.drawFrame();
		var screenPixels = screen.framePixels;

		if (FlxG.renderBlit)
			screenPixels.copyPixels(FlxG.camera.buffer, FlxG.camera.buffer.rect, new Point());
		else
			screenPixels.draw(FlxG.camera.canvas, new Matrix(1, 0, 0, 1, 0, 0));

		super.create();
	}
}
