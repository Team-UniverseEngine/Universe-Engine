package;

import openfl.display.BitmapData;
import animateatlas.AtlasFrameMaker;
import flixel.FlxG;
import flixel.addons.effects.FlxTrail;
import flixel.input.keyboard.FlxKey;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets;
import flixel.math.FlxMath;
import flixel.util.FlxSave;
import flixel.addons.transition.FlxTransitionableState;
import flixel.system.FlxAssets.FlxShader;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
#if (!flash && sys)
import flixel.addons.display.FlxRuntimeShader;
#end
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import Type.ValueType;
import Controls;
import DialogueBoxPsych;
#if hscript
import hscript.Parser;
import hscript.Interp;
import hscript.Expr;
#end
#if desktop
import Discord;
import Discord.DiscordClient;
#end

class FunkinHScript
{
	public static var Function_Stop:Dynamic = 1;
	public static var Function_Continue:Dynamic = 0;
	public static var Function_StopLua:Dynamic = 2;

    #if hscript
    public var interp:Interp;
    public var parser:Parser;
    public var program:Dynamic;
    #end

	public var camTarget:FlxCamera;
	public var scriptName:String = '';
	public var closed:Bool = false;
    public var result:Dynamic;
    public var resultStr:String = "";

	public static var ir = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('is'));

    public function new(script:String)
    {
        #if hscript
        interp = new Interp();
        parser = new Parser();
        parser.allowTypes = true;
        parser.allowJSON = true;
        parser.allowMetadata = true;
        var script:String = File.getContent(script);
        program = parser.parseString(script, script);
        scriptName = script;
        try {
            result = interp.execute(program);
            resultStr = Std.string(result);
        }
        catch(e:Dynamic)
        {
            trace("Error parsing script");
        }

		set('inChartEditor', false);

		// Song/Week shit
		set('curBpm', Conductor.bpm);
		set('bpm', PlayState.SONG.bpm);
		set('scrollSpeed', PlayState.SONG.speed);
		set('crochet', Conductor.crochet);
		set('stepCrochet', Conductor.stepCrochet);
		set('songLength', FlxG.sound.music.length);
		set('songName', PlayState.SONG.song);
		set('songPath', Paths.formatToSongPath(PlayState.SONG.song));
		set('startedCountdown', false);
		set('curStage', PlayState.SONG.stage);

		set('isStoryMode', PlayState.isStoryMode);
		set('difficulty', PlayState.storyDifficulty);

		var difficultyName:String = CoolUtil.difficulties[PlayState.storyDifficulty];
		set('difficultyName', difficultyName);
		set('difficultyPath', Paths.formatToSongPath(difficultyName));
		set('weekRaw', PlayState.storyWeek);
		set('week', WeekData.weeksList[PlayState.storyWeek]);
		set('seenCutscene', PlayState.seenCutscene);

		// Camera poo
		set('cameraX', 0);
		set('cameraY', 0);

		// Screen stuff
		set('screenWidth', FlxG.width);
		set('screenHeight', FlxG.height);

		// PlayState cringe ass nae nae bullcrap
		set('curBeat', 0);
		set('curStep', 0);
		set('curDecBeat', 0);
		set('curDecStep', 0);

		set('score', 0);
		set('misses', 0);
		set('hits', 0);
		
		set('lerpScore', 0);

		set('rating', 0);
		set('ratingName', '');
		set('ratingFC', '');
		set('version', MainMenuState.psychEngineVersion.trim());

		set('inGameOver', false);
		set('mustHitSection', false);
		set('altAnim', false);
		set('gfSection', false);

		// Gameplay settings
		set('healthGainMult', PlayState.instance.healthGain);
		set('healthLossMult', PlayState.instance.healthLoss);
		set('playbackRate', PlayState.instance.playbackRate);
		set('instakillOnMiss', PlayState.instance.instakillOnMiss);
		set('botPlay', PlayState.instance.cpuControlled);
		set('practice', PlayState.instance.practiceMode);

		for (i in 0...4)
		{
			set('defaultPlayerStrumX' + i, 0);
			set('defaultPlayerStrumY' + i, 0);
			set('defaultOpponentStrumX' + i, 0);
			set('defaultOpponentStrumY' + i, 0);
		}

		// Default character positions woooo
		set('defaultBoyfriendX', PlayState.instance.BF_X);
		set('defaultBoyfriendY', PlayState.instance.BF_Y);
		set('defaultOpponentX', PlayState.instance.DAD_X);
		set('defaultOpponentY', PlayState.instance.DAD_Y);
		set('defaultGirlfriendX', PlayState.instance.GF_X);
		set('defaultGirlfriendY', PlayState.instance.GF_Y);

		// Character shit
		set('boyfriendName', PlayState.SONG.player1);
		set('dadName', PlayState.SONG.player2);
		set('gfName', PlayState.SONG.gfVersion);

		// Some settings, no jokes
		set('downscroll', ClientPrefs.data.downScroll);
		set('middlescroll', ClientPrefs.data.middleScroll);
		set('framerate', ClientPrefs.data.framerate);
		set('ghostTapping', ClientPrefs.data.ghostTapping);
		set('hideHud', ClientPrefs.data.hideHud);
		set('timeBarType', ClientPrefs.data.timeBarType);
		set('scoreZoom', ClientPrefs.data.scoreZoom);
		set('cameraZoomOnBeat', ClientPrefs.data.camZooms);
		set('flashingLights', ClientPrefs.data.flashing);
		set('noteOffset', ClientPrefs.data.noteOffset);
		set('healthBarAlpha', ClientPrefs.data.healthBarAlpha);
		set('noResetButton', ClientPrefs.data.noReset);
		set('lowQuality', ClientPrefs.data.lowQuality);
		set('shadersEnabled', ClientPrefs.data.shaders);
		set('scriptName', scriptName);
		set('currentModDirectory', Paths.currentModDirectory);

		// UE optiosn
		set('solarEngine', MainMenuState.ueVersion.trim()); // Version comparison.
		set('UEkeystrokes', ClientPrefs.data.keystrokes);
		set('UEkeyA', ClientPrefs.data.keyA);
		set('UEkeyFT', ClientPrefs.data.keyFT);
		set('UEkeyXPos', ClientPrefs.data.keyXPos);
		set('UEkeyYPos', ClientPrefs.data.keyYPos);
		set('UEHud', ClientPrefs.data.ueHud);
		set('UEhudZoomOut', ClientPrefs.data.hudZoomOut);
		set('UEhudPos', ClientPrefs.data.hudPosUE);
		set('UEsnTimeFollow', ClientPrefs.data.sntf);
		set('UEhitsound', ClientPrefs.data.ht);
		set('UEDetachedHB', ClientPrefs.data.dhb);
		set('UEcCounter', ClientPrefs.data.cc);
		set('UESmoothHP', ClientPrefs.data.sh);
		set('UEe100C', ClientPrefs.data.ec);
		set('UEshakeMiss', ClientPrefs.data.snm);
		set('UEtauntGo', ClientPrefs.data.tng);
		set('UEiconBop', ClientPrefs.data.ib);
		set('UEhidetimeBar', ClientPrefs.data.huet);
		set('UE100comboSounds', ClientPrefs.data.css);
		set('UEdarkenCamGame', ClientPrefs.data.darkenCamGame);
		set('UEcute', ClientPrefs.data.cuteMode);
		set('UEmmm', ClientPrefs.data.mmm);
		set('UEir', ir);
		set('UEstrumsplash', ClientPrefs.data.uess);
		set('UEresultscreen', ClientPrefs.data.ueresultscreen);
		set('UEmisssounds', ClientPrefs.data.uems);
		
		set('noteLeftRGB', ClientPrefs.data.arrowRGB[0][0].toHexString(false, false));
		set('noteDownRGB', ClientPrefs.data.arrowRGB[1][0].toHexString(false, false));
		set('noteUpRGB', ClientPrefs.data.arrowRGB[2][0].toHexString(false, false));
		set('noteRightRGB', ClientPrefs.data.arrowRGB[3][0].toHexString(false, false));

		// UE gamepler
		set('UEhealthDrain', ClientPrefs.data.gameplaySettings.get('hd'));
		set('UEsd', ClientPrefs.data.gameplaySettings.get('sd'));
		set('UEsustainOneNote', ClientPrefs.data.gameplaySettings.get('sn'));
		set('modchart', ClientPrefs.data.gameplaySettings.get('modchart'));
		set('UEplayBothSides', ClientPrefs.data.gameplaySettings.get('pbs'));
		set('UEhealthdrainp2', ClientPrefs.data.gameplaySettings.get('hdp2'));
		set('UEIncreasePBR', ClientPrefs.data.gameplaySettings.get('ipbr'));
		set('UEipbrv', ClientPrefs.data.gameplaySettings.get('ipbrv'));
		set("setVar", set);
		set("getVar", get);

		call("onCreate", []);
        #end
    }

	var lastFuncCall:String = "";
	public function call(func:String, args:Array<Dynamic>):Dynamic
	{
		if (closed)
			return Function_Continue;

		lastFuncCall = func;

		var funcVar = get(func);
		var result:Dynamic = Function_Continue;

		try
		{
			result = Reflect.callMethod(this, funcVar, args);
		}
		catch (e:Dynamic)
		{
			trace("Could not call func: `" + func + "`: " + Std.string(e));
		}

		return result;
	}

    public function get(k:String):Dynamic
    {
        var result:Dynamic = null;

        #if hscript
        result = interp.variables.get(k);
        #end

        return result;
    }
    
    public function set(k:String, v:Dynamic):Dynamic
    {
        #if hscript
        interp.variables.set(k, v);
        #end

        return v;
    }
}