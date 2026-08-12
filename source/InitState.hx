package;

import flixel.util.FlxSave;
import lime.app.Application;

using StringTools;

// Runs some shit before launching the game.
class InitState extends FlxState
{
    public override function create() {
        super.create();

        var oldSave:FlxSave = new FlxSave();
        oldSave.bind("funkin", 'universe');

        var oldControls:FlxSave = new FlxSave();
        oldControls.bind("controls_v2", 'universe');

        var newSave:FlxSave = new FlxSave();
        newSave.bind("controls_v2", "solar");
        if (newSave.isEmpty())
        {
            newSave.mergeData(oldControls.data);
            newSave.flush();
        }
        newSave.close();
        oldControls.close();

		FlxG.save.bind('funkin', 'solar'); // get the save ready before starting the game.
        if (FlxG.save.isEmpty()) // Check if the save currently exists.
        {
            FlxG.save.mergeData(oldSave.data);
            FlxG.save.flush();
        }
        oldSave.close();

        FlxG.signals.postStateSwitch.add(validateTitle);

        PlayerSettings.init();
		ClientPrefs.loadPrefs(); // load the save for fixing potentially invalid options.
        new Conductor();

        validateSettings();

        FlxG.switchState(new TitleState());
    }

    public static function validateTitle()
    {
        if (Application.current.window.title.trim().contains("Universe Engine")) Application.current.window.title = "Friday Night Funkin: Solar Engine"; // fix for scripts that are before this update.
    }

    public static function validateSettings()
    {
        var validMenuThemes:Array<String> = [
			'Universe',
			#if SILLY_OPTIONS "AAC V4", #end
			'Normal Collections',
			'Daveberry'
		];

        if (!validMenuThemes.contains(ClientPrefs.data.mmm)) ClientPrefs.data.mmm = "Universe";
        if (ClientPrefs.data.moveCreditMods) ClientPrefs.data.moveCreditMods = false;

        #if !SILLY_OPTIONS
        if (ClientPrefs.data.cuteMode) ClientPrefs.data.cuteMode = false;
        if (ClientPrefs.data.ft) ClientPrefs.data.ft = false;
        if (ClientPrefs.data.fm) ClientPrefs.data.fm = false;
        if (ClientPrefs.data.sillyBob) ClientPrefs.data.sillyBob = false;
        if (ClientPrefs.data.ec) ClientPrefs.data.ec = false;
        if (ClientPrefs.data.snm) ClientPrefs.data.snm = false;
        if (ClientPrefs.data.tng) ClientPrefs.data.tng = false;
        if (ClientPrefs.data.darkenCamGame) ClientPrefs.data.darkenCamGame = false;
        if (ClientPrefs.data.dhb) ClientPrefs.data.dhb = false;
        if (ClientPrefs.data.cc) ClientPrefs.data.cc = false;
        if (ClientPrefs.data.hudZoomOut) ClientPrefs.data.hudZoomOut = false;
        if (ClientPrefs.data.ib) ClientPrefs.data.ib = false;
        if (ClientPrefs.data.lhpbgb) ClientPrefs.data.lhpbgb = false;
        
        var validHitsounds:Array<String> = [
			'Classic',
			'Water',
			'Waterboom',
			'Heartbeat',
			'Universe',
        ];
        if (!validHitsounds.contains(ClientPrefs.data.ht)) ClientPrefs.data.ht = "Classic";
        #end

        for (name => controls in ClientPrefs.keyBinds)
        {
            trace('$name = ${controlsToString(controls)}');
            if (controls == [NONE, NONE])
            {
                ClientPrefs.keyBinds[name] = ClientPrefs.defaultKeys[name];
                trace('$name was invalid!');
            }
        }
    }

    static function controlsToString(bind:Array<FlxKey>):String
    {
        var array:Array<String> = [];

        for (control in bind)
        {
            array.push(control.toString());
        }

        return '$array';
    }
}