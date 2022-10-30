package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import sys.thread.Thread;
import sys.FileSystem;
import SUtil;

using StringTools;

class LoadingState extends MusicBeatState
{
	public static var target:FlxState;
	public static var stopMusic = false;
	public var luaToCashe:Array<FunkinLua> = [];
	static var imagesToCache:Array<String> = [];
	static var soundsToCache:Array<String> = [];
	static var library:String = "";
	

	var screen:LoadingScreen;

	public function new()
	{
		super();

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
	}

	override function create()
	{
		super.create();

		// Hardcoded, aaaaahhhh
		switch (Paths.formatToSongPath(PlayState.SONG.song))
		{
			case 'technicolor-tussle':

				imagesToCache = [
					'cup/intro/ready_wallop',
					'cup/Cupheadshoot',
					'cup/intro/the_thing2.0',
					'characters/Cuphead_Remastered',
					'characters/BoyFriend',
					'cup/BG-00',
					'cup/BG-01',
					'cup/Foreground'
				];
			case 'knockout':
				imagesToCache = [
					'cup/intro/ready_wallop',
					'cup/Cupheadshoot',
					'cup/intro/the_thing2.0',
					'cup/Cuphead Hadoken',
					'cup/GreenShit',
					'cup/Mugman Fucking dies',
					'cup/knock',
					'cup/Roundabout',
					'cup/gay',
					'CH-RN-00',
					'CH-RN-01',
					'cup/CH-RN-02',
					'characters/BoyFriend_Rain',
					'characters/Cuphead Pissed'
				];
			case 'sansational' | 'whoopee' | 'burning-in-hell' | 'bad-time':


				imagesToCache = ["chracters/DodgeMechs"];
					if (Paths.formatToSongPath(PlayState.SONG.song) =='bad-time') {
						imagesToCache = imagesToCache.concat(['DodgeMechsBS-Shader']);
					}
					if (Paths.formatToSongPath(PlayState.SONG.song) == 'burning-in-hell') {
						imagesToCache = imagesToCache.concat(['sans/Gaster_blasterss', 'characters/Cardodge', 'sans/heart']);
					}
					
			case 'terrible-sin' | 'last-reel' | 'nightmare-run' | 'ritual' | 'despair' | 'imminent-demise':
				imagesToCache = ['Damage01', 'Damage02', 'Damage03', 'Damage04'];
				if (Paths.formatToSongPath(PlayState.SONG.song) =='last-reel') {
					imagesToCache = imagesToCache.concat(['Damage01', 'Damage02', 'Damage03', 'Damage04', 'Striker', 'Piper', 'PiperJumpscare', 'DontmindmeImmajustwalkby', 'inkRain', 'bendy/inkShit' , 'JzBoy']);
				}
				if (Paths.formatToSongPath(PlayState.SONG.song) =='nightmare-run') {
					imagesToCache = imagesToCache.concat(['Damage01', 'Damage02', 'Damage03', 'Damage04', 'stairs', 'Trans', 'scrollingBG', 'Pillar', 'hallway', 'Dark', 'chainleft']);
				}
				if (Paths.formatToSongPath(PlayState.SONG.song) =='despair') {
					imagesToCache = imagesToCache.concat(['Damage01', 'Damage02', 'Damage03', 'Damage04', 'PiperDespair', 'StrikerDespair', 'inkShit', 'Fyre']);
				}
		}

		// Hardcoded for now
		if (PlayState.SONG.song.toLowerCase() == 'ritual')
		FlxTransitionableState.skipNextTransIn = true;

		screen = new LoadingScreen();
		add(screen);

		screen.max = imagesToCache.length;

		FlxG.camera.fade(FlxG.camera.bgColor, 0.5, true);

		FlxGraphic.defaultPersist = true;
		Thread.create(() ->
		{
			//#if !android
			screen.setLoadingText("Loading images...");
			for (image in imagesToCache)
			{
				trace("Caching image " + image);
				FlxG.bitmap.add(Paths.image(image));
				screen.progress += 1;
			}
			//#end

			FlxGraphic.defaultPersist = false;

			screen.setLoadingText("Done!");
			trace("Done caching");

			FlxG.camera.fade(FlxColor.BLACK, 1, false);
			new FlxTimer().start(1, function(_:FlxTimer)
			{
				screen.kill();
				screen.destroy();
				loadAndSwitchState(target, false);
			});
		});
	}

	public static function loadAndSwitchState(target:FlxState, stopMusic = false)
	{
		//Paths.setCurrentLevel("week" + PlayState.storyWeek);

		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		MusicBeatState.switchState(target);
	}
}