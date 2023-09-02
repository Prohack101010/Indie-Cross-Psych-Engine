package states.stages;

import states.stages.objects.*;
import states.PlayState;

class Hall extends BaseStage
{
	public var bg:FlxSprite;
	public var finalStretchWaterFallBG:FlxSprite;
	public var finalStretchwhiteBG:FlxSprite;
	public var finalStretchBarTop:FlxSprite;
	public var finalStretchBarBottom:FlxSprite;
	public var battleBG:FlxSprite;
	// If you're moving your stage from PlayState to a stage file,
	// you might have to rename some variables if they're missing, for example: camZooming -> game.camZooming

	override function create()
	{
		set_defaultCamZoom(0.9);
		bg = new FlxSprite();
					if (get_songName() == 'burning-in-hell')
					{
						bg.loadGraphic(Paths.image('halldark', 'sans'));
					}
					else
						bg.loadGraphic(Paths.image('hall', 'sans'));
					bg.setGraphicSize(Std.int(bg.width * 1.5));
					bg.updateHitbox();
					bg.screenCenter();
					bg.x -= 300;

					bg.antialiasing = ClientPrefs.data.antialiasing;
					bg.scrollFactor.set(1.0, 1.0);
					bg.active = false;
					add(bg);

					if (get_songName() == 'final-stretch')
						{
							finalStretchWaterFallBG = new FlxSprite(0, 0).loadGraphic(Paths.image('Waterfall', 'sans'));
							finalStretchWaterFallBG.setGraphicSize(Std.int(bg.width * 1.5));
							finalStretchWaterFallBG.updateHitbox();
							finalStretchWaterFallBG.screenCenter();
							finalStretchWaterFallBG.x -= 300;
							finalStretchWaterFallBG.alpha = 0.0001;
							finalStretchWaterFallBG.antialiasing = ClientPrefs.data.antialiasing;							add(finalStretchWaterFallBG);
			
							finalStretchwhiteBG = new FlxSprite(-640, -640).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.WHITE);
							finalStretchwhiteBG.scrollFactor.set(0, 0);
							finalStretchwhiteBG.visible = false;
							add(finalStretchwhiteBG);
			
							finalStretchBarTop = new FlxSprite(-640, -560).makeGraphic(FlxG.width * 2, 560, FlxColor.BLACK);
							finalStretchBarTop.scrollFactor.set(0, 0);
							finalStretchBarTop.cameras = [camOther];
							add(finalStretchBarTop);
			
							finalStretchBarBottom = new FlxSprite(-640, 720).makeGraphic(FlxG.width * 2, 560, FlxColor.BLACK);
							finalStretchBarBottom.scrollFactor.set(0, 0);
							finalStretchBarBottom.cameras = [camOther];
							add(finalStretchBarBottom);
						}

						if (get_songName() == 'sansational' || get_songName() == 'burning-in-hell')
							{
								battleBG = new FlxSprite(-600, 0).loadGraphic(Paths.image('battel', 'sans'));
								battleBG.antialiasing = false;
								battleBG.scrollFactor.set(1, 1);
								battleBG.alpha = 0.0001;
							//	battleBG.setGraphicSize(Std.int(battle.width));
								battleBG.antialiasing = ClientPrefs.data.antialiasing;
								battleBG.updateHitbox();
								add(battleBG);
							}
		

	}
	
	override function createPost()
	{
		// Use this function to layer things above characters!
	}

	override function update(elapsed:Float)
	{
		// Code here
	}

	
	override function countdownTick(count:Countdown, num:Int)
	{
		switch(count)
		{
			case THREE: //num 0
			case TWO: //num 1
			case ONE: //num 2
			case GO: //num 3
			case START: //num 4
		}
	}

	// Steps, Beats and Sections:
	//    curStep, curDecStep
	//    curBeat, curDecBeat
	//    curSection
	override function stepHit()
	{
		// Code here
	}
	override function beatHit()
	{
		// Code here
	}
	override function sectionHit()
	{
		// Code here
	}

	// Substates for pausing/resuming tweens and timers
	override function closeSubState()
	{
		if(paused)
		{
			//timer.active = true;
			//tween.active = true;
		}
	}

	override function openSubState(SubState:flixel.FlxSubState)
	{
		if(paused)
		{
			//timer.active = false;
			//tween.active = false;
		}
	}

	// For events
	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case "My Event":
		}
	}
	override function eventPushed(event:objects.Note.EventNote)
	{
		// used for preloading assets used on events that doesn't need different assets based on its values
		switch(event.event)
		{
			case "My Event":
				//precacheImage('myImage') //preloads images/myImage.png
				//precacheSound('mySound') //preloads sounds/mySound.ogg
				//precacheMusic('myMusic') //preloads music/myMusic.ogg
		}
	}
	override function eventPushedUnique(event:objects.Note.EventNote)
	{
		// used for preloading assets used on events where its values affect what assets should be preloaded
		switch(event.event)
		{
			case "My Event":
				switch(event.value1)
				{
					// If value 1 is "blah blah", it will preload these assets:
					case 'blah blah':
						//precacheImage('myImageOne') //preloads images/myImageOne.png
						//precacheSound('mySoundOne') //preloads sounds/mySoundOne.ogg
						//precacheMusic('myMusicOne') //preloads music/myMusicOne.ogg

					// If value 1 is "coolswag", it will preload these assets:
					case 'coolswag':
						//precacheImage('myImageTwo') //preloads images/myImageTwo.png
						//precacheSound('mySoundTwo') //preloads sounds/mySoundTwo.ogg
						//precacheMusic('myMusicTwo') //preloads music/myMusicTwo.ogg
					
					// If value 1 is not "blah blah" or "coolswag", it will preload these assets:
					default:
						//precacheImage('myImageThree') //preloads images/myImageThree.png
						//precacheSound('mySoundThree') //preloads sounds/mySoundThree.ogg
						//precacheMusic('myMusicThree') //preloads music/myMusicThree.ogg
				}
		}
	}
}