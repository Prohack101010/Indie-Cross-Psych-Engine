package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import sys.thread.Thread;
import backend.VideoManager;

using StringTools;

/**
 * @author BrightFyre
 */
class Caching extends MusicBeatState
{
	var calledDone = false;
	var screen:LoadingScreen;
	var debug:Bool = false;
    public static var video:VideoManager;

	public function new()
	{
		super();
	}

	override function create()
	{
		super.create();

		screen = new LoadingScreen();
		add(screen);

		trace("Starting caching...");

		Thread.create(() ->
			{
				cache();
			});
	}

	function cache()
	{
		screen.max = 9;
		
		trace("Caching images...");

		screen.setLoadingText("Loading images...");

		// store this or else nothing will be saved
		// Thanks Shubs -sqirra
		FlxGraphic.defaultPersist = true;

		screen.progress = 3;
		screen.setLoadingText("Loading sounds...");
		screen.progress = 8;

		screen.setLoadingText("Loading cutscenes...");
		trace('starting vid cache');
		video = new VideoManager();	
		video.startVideo(Paths.video('intro'));
        video.onTextureSetup.add(function(){
            video.pause();
            video.alpha = 0;
        }, true);
		trace('finished vid cache');

		screen.progress = 9;

		FlxGraphic.defaultPersist = false;

		screen.setLoadingText("Done!");
		trace("Caching done!");

		end();
	}

	function end()
	{
		FlxG.camera.fade(FlxColor.BLACK, 1, false);
		
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			FlxG.switchState(new TitleState());
		});
	}
}
