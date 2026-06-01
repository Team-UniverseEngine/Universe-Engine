# Universe Engine Changelog.

# [Solar Engine 0.6.1](https://github.com/Team-SolarEngine/Universe-Engine-Archive/releases/tag/0.6.1)

## Changes

- Fixed the result screen accidentally making a camera that becomes the default draw target.
- Fixed the result screen occasionally failing to end the song.
- Fixed the HXCPP version used when compiling the windows build.
- Fixed note RGB not being disabled on RGB Shader being disabled in the song
- Added 2 checkboxes to the chart editor to disable note RGB or note splashes.

# [Solar Engine 0.6.0](https://github.com/Team-SolarEngine/Universe-Engine-Archive/releases/tag/0.6.0)

> A Universe Engine update?! in 2026???!?!? No I am not going back and fixing the changelog to reflect this one frick you - Char

## Changes

- Note Splashes now actually exist (Psych 0.7.3 code backport lmao)
- Fancy Menu no longer fails to load in some cases.
- Disabling Modcharts no longer invalidates your score.
- Removed Dinus Game from credits.
- Removed Menu Music we likely don't have permission to use
- Added a build flag that let's you remove certain options at compile time that may be considerd "unneccassary"
- Made the Result Screen a seperate substate and fixed the quality of the exported animations.

## Library Changes

- Modern HxCodec Support.
- Compatible with modern flixel versions

# [Universe Engine 0.5.5](https://github.com/Team-SolarEngine/Universe-Engine-Archive/releases/tag/0.5.5)

Universe engine offical launcher?!!?!?!?!??!!?!?!??!?!?! [(click here)](https://github.com/VideoBotYT/Universe-Engine-Launhcer/releases)

Removed the ingame updater (we have a damn launcher now)

Added 2 new options

Credited 2 people for the PR's

Hitsounds options now moved to gameplay

Better Discord RPC

Removed the delay resume on pause menu

Options menu finally has music

Changing Menu Music updates on options

2 New Menu Music

Added an option to move "mods" and "credits" to options

Removed Exit on Shortcut menu

Made the checker a little darker when on dark mode

Added an option to remove second page in main menu

Fixed Pause Menu music crash on psych options

## NOTE FROM THE (FORMER)FIRST DEVELOPER

Hey uh, Yeah hi, I'm uwenalil, I'm the one who made this update and so now, I don't work for universe engine anymore.

It's not due to school or depression, I'va just completlely lost interest in FNF.

So, Im putting my hat down and passing it to VideoBot and BaranMuzu to work on the engine.

Thank you for your support.

See you.

# [Universe Engone 0.4.5](https://github.com/Team-SolarEngine/Universe-Engine-Archive/releases/tag/0.4.5)

Bugfixes

windowSize now doesn't have 2 arguments that did the same _previously the sizeX and sizeY did the same_

windowSize now also has 2 extra functions _for the X and the Y sepreratly_ read [wiki](https://github.com/Team-SolarEngine/Universe-Engine-Archive/wiki) for more information

windowPos now also has 2 extra function _like windowSize_  read [wiki](https://github.com/Team-SolarEngine/Universe-Engine-Archive/wiki) for more information

# [Universe Engine 0.4.4](https://github.com/Team-SolarEngine/Universe-Engine-Archive/releases/tag/0.4.4)

New features

Fancy Menus (game option)

Silly Bounce (game option *only effects when you have Fancy Menus on)

New modifiers

New lua functions (check [wiki](https://github.com/Team-SolarEngine/Universe-Engine-Archive/wiki) for it)

# [Universe Engine 0.3.4](https://github.com/Team-SolarEngine/Universe-Engine-Archive/releases/tag/0.3.4)

Minor bugfix stuff

Some text are centered

Fixed erect difficulty changing on pause menu so it doesnt crash anymore (creds to CharGoldenYT for the PR)

Fixed WeekEditorState menu crash (creds to CharGoldenYT for the pr, I don't use the built in editor lol)

2 New Hitsounds

Changed some ClientPrefs stuff

Removed window icon for fire in the hole hitsound. (I didn't have enough time to fix it.)

2 New gameplay modifier! (it includes playback rate)

Loading screen! (can disable)


# [Universe Engine 0.3.3](https://github.com/Team-SolarEngine/Universe-Engine-Archive/releases/tag/0.3.3)

<-- UWENALIL -->


Intro of AAC was changed

Note color crash is now fixed!

Note color now saves your color

Pressing ESC in shortcut menu now exits

Added an option Strum Splashes

Moved the "UE Engine" Folder to assets and renamed

Pressing RESET key on main menu state restarts the game

Intro text is now 3 texts instead of 2.

Randomized Text on the end of the introState.

Long note transparency option

Layer HPBG Behind Health Bar Colors

Added a Dark mode Option

Camera Zooming in Fancy Title is now changed and added in Intro (added angle changing too :o)

Fixed the customizable menu music not chaning on other state when leaving

Fixed Songs without voices crash (LIBRARY ISSUE)

When pressed right arrow on main menu, it shows Unnecessary stuff.

Scroll wheel works on the main menu state

Moved some settings to the one they should be at

Fixed Pause Menu Crash

Added a new menu music = STAY FUNKY

Changed it when if "STAY FUNKY", "MARKED ENGINE" or "DNB OLD" is selected, the bpm changes

Added an option to turn off miss sounds

There is no limitation to playback rate.


<-- VIDEOBOT -->


Lua backDrop

Added a new menu music = Marked Engine

Added a new menu music = DNB OLD


<-- BARANMUZU -->


Added Results Screen

Fixed the double trail

Added Health Drain Part 2

baldi

All Erect Songs

Jumpscare event

Erect menu



<-- PULL REQUESTS -->

https://github.com/Team-SolarEngine/Universe-Engine-Archive/pull/8 -- CharGoldenYT

# [Universe Engine 0.2.2](https://github.com/Team-SolarEngine/Universe-Engine-Archive/releases/tag/0.2.2)


New events

Cute mode more modified

Shut down on miss now replaced with crash on miss

Fire in the hole

Chart editor

    Section notes
    
    Rendered notes
    
    Fixed chart hitsound crash
    
    Reset button for playback rate


# [Universe Engine 0.2.1](https://github.com/Team-SolarEngine/Universe-Engine-Archive/releases/tag/0.2.1)


Fixed the HUD tag so it doesn't conflict with any other script that uses the tag.

Actually made Center Hud Pos and Combo counter Centered.

Fixed combo counter on the misses and the popup.

Botplay doesn’t follow the up arrow and instead, never flashes and every time a beat hits, its scaled up then back to its original size

Time Text has it's own Tag instead of using the normal psych engine.

Added Trail Double Note

Added Miss Sounds

Modified Icon Bop

Fixed Shut down on miss and Sustain as one note

Song Name has a new member! BPM.


Added Modchart LUA Var

Removed Middle scroll due to Modchart bugs

When pressed esc on the title screen, the game gives a confirmation if you wanna close the game.

Made the title menu more fancy

cute mode :3

Black dots are removed and now replaced with Grids

Added Gameplay Modifiers in pause state

Added Shortcut menu

Changed to make its own save file

ez note spamming feature

New more modifiers

FPS limit minimum: 15, maximum: 360


Added an option to hide time bar

Added an option to darken camGame

Added an option to change the sounds of every 100 combo


New freakyMenu Music.

Bonus Songs are now in a different download.


# [Universe Engine 0.1.0](https://github.com/Team-SolarEngine/Universe-Engine-Archive/releases/tag/0.1.0)

First release with terrible features.

#

videobot mispelled engine :3

and im keeping it!!!! >:3
