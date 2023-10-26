package states.stages;

import flixel.system.FlxSound;
import objects.CupBullet;
import states.stages.objects.*;

class Field extends BaseStage
{
	// If you're moving your stage from PlayState to a stage file,
	// you might have to rename some variables if they're missing, for example: camZooming -> game.camZooming
	public static var countdownNarrator:FlxSound;
	public static var wallop:FlxSprite;
	public static var cupTea:FlxSprite;

	public var mugdead:FlxSprite;

	public static var fgStatic:FlxSprite;
	public static var fgRain:FlxSprite;
	public static var fgRain2:FlxSprite;
	public static var fgGrain:FlxSprite;

	var oldDefaultCamZoom:Float;
	var mugcanhit:Bool = false;
	var knockoutSpr:FlxSprite;

	public static var transFinishCallBack = function(name) {};

	override function create()
	{
		oldDefaultCamZoom = defaultCamZoom;

		PlayState.instance.cupheadGameOver = true;
		// Spawn your stage sprites here.
		// Characters are not ready yet on this function, so you can't add things above them yet.
		// Use createPost() if that's what you want to do.

		PlayState.instance.defaultCamZoom = 0.63;
		PlayState.instance.camZooming = true;
		// this was loading 2 bg's lol
		var bg:FlxSprite = new FlxSprite();

		if (get_songName() == 'knockout')
		{
			// preloading ;D
			Paths.sound('hurt', 'cup');
			for (b in 0...5)
				Paths.sound('attacks/pea' + b, 'cup');
			for (shit in 0...4)
				Paths.sound('attacks/chaser' + shit, 'cup');
			for (crap in 0...4)
			{
				if (PlayState.SONG.song.toLowerCase() != 'knockout')
					Paths.sound('intros/normal/' + crap, 'cup');
				else if (crap == 1 || crap == 0)
					Paths.sound('intros/angry/' + crap, 'cup');
			}
			Paths.sound('knockout', 'cup');
			Paths.sound('pre_shoot', 'cup');
			Paths.image('ready_wallop', 'cup');
			Paths.image('bull/Cupheadshoot', 'cup');
			Paths.image('bull/GreenShit', 'cup');
			Paths.image('bull/Roundabout', 'cup');
			Paths.image('bull/Cuphead Hadoken', 'cup');
			bg.loadGraphic(Paths.image('angry/CH-RN-00', 'cup'));
		}
		else
		{
			bg.loadGraphic(Paths.image('BG-00', 'cup'));
		}

		bg.setGraphicSize(Std.int(bg.width * 0.7 * 4));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0.2, 0.2);
		bg.active = false;
		add(bg);

		var trees:FlxSprite = new FlxSprite();

		if (get_songName() == 'knockout')
			trees.loadGraphic(Paths.image('angry/CH-RN-01', 'cup', false));
		else
			trees.loadGraphic(Paths.image('BG-01', 'cup', false));

		trees.setGraphicSize(Std.int(trees.width * 0.7 * 4));
		trees.updateHitbox();
		trees.screenCenter();
		trees.x -= 75;
		trees.antialiasing = ClientPrefs.data.antialiasing;
		trees.scrollFactor.set(0.45, 0.45);
		trees.active = false;
		add(trees);

		var fg:FlxSprite = new FlxSprite();

		if (get_songName() == 'knockout')
			fg.loadGraphic(Paths.image('angry/CH-RN-02', 'cup'));
		else
			fg.loadGraphic(Paths.image('Foreground', 'cup'));

		fg.setGraphicSize(Std.int(fg.width * 0.9 * 4));
		fg.updateHitbox();
		fg.screenCenter();
		fg.x -= 100;
		fg.y -= 200;
		fg.antialiasing = ClientPrefs.data.antialiasing;
		fg.active = false;
		add(fg);

		cupTea = new FlxSprite();
		cupTea.frames = Paths.getSparrowAtlas('the_thing2.0', 'cup');
		cupTea.animation.addByPrefix('start', "BOO instance 1", 24, false);
		cupTea.setGraphicSize(Std.int((FlxG.width / camHUD.zoom) * 1.1), Std.int((FlxG.height / camHUD.zoom) * 1.1));
		cupTea.updateHitbox();
		cupTea.screenCenter();
		cupTea.antialiasing = ClientPrefs.data.antialiasing;
		cupTea.scrollFactor.set();
		cupTea.cameras = [camOther];
		cupTea.alpha = 0.00001;
		add(cupTea);
		cupTea.animation.finishCallback = transFinishCallBack;

		knockoutSpr = new FlxSprite();
		knockoutSpr.frames = Paths.getSparrowAtlas('knock', 'cup');
		knockoutSpr.animation.addByPrefix('start', "A KNOCKOUT!", 24, false);
		knockoutSpr.updateHitbox();
		knockoutSpr.screenCenter();
		knockoutSpr.antialiasing = ClientPrefs.data.antialiasing;
		knockoutSpr.scrollFactor.set();
		knockoutSpr.alpha = 0.0001;
		knockoutSpr.cameras = [camHUD];
		add(knockoutSpr);
	}

	override function createPost()
	{
		// Use this function to layer things above characters!
		if (get_songName() == 'knockout')
		{
			mugdead = new FlxSprite(1500, 1500);
			mugdead.frames = Paths.getSparrowAtlas('characters/Mugman Fucking dies');
			mugdead.animation.addByPrefix('Dead', 'MUGMANDEAD', 24, false);
			mugdead.animation.addByPrefix('Stroll', 'Mugman instance', 24, true);
			mugdead.animation.play('Stroll', true);
			mugdead.animation.pause();
			mugdead.updateHitbox();
			mugdead.antialiasing = true;
			PlayState.instance.boyfriendGroup.add(mugdead);
			mugdead.x = boyfriend.x + 500;
			mugdead.y = boyfriend.y;
			// bullets
			PlayState.instance.cupBullets[0] = new CupBullet('hadoken', 0, 0);
			boyfriendGroup.add(PlayState.instance.cupBullets[0]);
			PlayState.instance.cupBullets[1] = new CupBullet('roundabout', 0, 0);
			boyfriendGroup.add(PlayState.instance.cupBullets[1]);

			fgRain = new FlxSprite();
			fgRain.frames = Paths.getSparrowAtlas('angry/NewRAINLayer01', 'cup');
			fgRain.animation.addByPrefix('play', 'RainFirstlayer instance 1', 24, true);
			fgRain.animation.play('play', true);
			fgRain.setGraphicSize(FlxG.width);
			fgRain.updateHitbox();
			fgRain.screenCenter();
			fgRain.antialiasing = ClientPrefs.data.antialiasing;
			fgRain.scrollFactor.set();
			fgRain.cameras = [camOther];
			add(fgRain);

			fgRain2 = new FlxSprite();
			fgRain2.frames = Paths.getSparrowAtlas('angry/NewRainLayer02', 'cup');
			fgRain2.animation.addByPrefix('play', 'RainFirstlayer instance 1', 24, true);
			fgRain2.animation.play('play', true);
			fgRain2.setGraphicSize(FlxG.width);
			fgRain2.updateHitbox();
			fgRain2.screenCenter();
			fgRain2.antialiasing = ClientPrefs.data.antialiasing;
			fgRain2.scrollFactor.set();
			fgRain2.cameras = [camOther];
			add(fgRain2);
		}

		fgStatic = new FlxSprite();
		fgStatic.frames = Paths.getSparrowAtlas('CUpheqdshid', 'cup');
		fgStatic.animation.addByPrefix('play', 'Cupheadshit_gif instance 1', 24, true);
		fgStatic.animation.play('play', true);
		fgStatic.setGraphicSize(FlxG.width);
		fgStatic.updateHitbox();
		fgStatic.screenCenter();
		fgStatic.antialiasing = ClientPrefs.data.antialiasing;
		fgStatic.scrollFactor.set();
		fgStatic.cameras = [camOther];
		if (get_songName() == 'knockout')
			fgStatic.alpha = 0.6;
		add(fgStatic);

		fgGrain = new FlxSprite();
		fgGrain.frames = Paths.getSparrowAtlas('Grainshit', 'cup');
		fgGrain.animation.addByPrefix('play', 'Geain instance 1', 24, true);
		fgGrain.animation.play('play', true);
		fgGrain.setGraphicSize(FlxG.width);
		fgGrain.updateHitbox();
		fgGrain.screenCenter();
		fgGrain.antialiasing = ClientPrefs.data.antialiasing;
		fgGrain.scrollFactor.set();
		fgGrain.cameras = [camOther];
		add(fgGrain);
	}

	override function update(elapsed:Float)
	{
		if (PlayState.SONG.song.toLowerCase() == 'knockout' && mugdead != null)
		{
			if (mugdead.overlaps(PlayState.instance.cupBullets[0]) && (mugcanhit))
			{
				if (((PlayState.instance.cupBullets[0].x < mugdead.x + mugdead.width / 4)
					&& (PlayState.instance.cupBullets[0].x > mugdead.x - mugdead.width / 2)))
				{
					if ((mugdead.animation.curAnim.name == 'Stroll'))
					{
						var cupheadPewThing = new CupBullet('hadokenFX', PlayState.instance.cupBullets[0].x + PlayState.instance.cupBullets[0].width / 4,
							PlayState.instance.cupBullets[0].y);
						cupheadPewThing.state = 'oneshoot';
						dadGroup.add(cupheadPewThing);
						PlayState.instance.cupBullets[0].state = 'unactive';
						cupheadPewThing.animation.finishCallback = function(name:String)
						{
							cupheadPewThing.kill();
							cupheadPewThing.destroy();
							remove(cupheadPewThing);
						};
						knockout();
						mugdead.animation.play('Dead', true);
						FlxG.sound.play(Paths.sound('hurt', 'cup'));
						mugcanhit = false;
					}
				}
			}
		}
		// Code here
	}

	override function countdownTick(count:Countdown, num:Int)
	{
		switch (count)
		{
			case THREE: // num 0
			case TWO: // num 1
			case ONE: // num 2
			case GO: // num 3
			case START: // num 4
		}
	}

	// Steps, Beats and Sections:
	//    curStep, curDecStep
	//    curBeat, curDecBeat
	//    curSection
	override function stepHit()
	{
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'technicolor-tussle':
				if (curStep == 452 || curStep == 833 || curStep == 1215)
					game.startCupheadShoot();
			case 'knockout':
				if (curStep == 1)
				{
					trace('knockout');
					mugdead.x = boyfriend.x + 500;
					mugdead.y = boyfriend.y;
				}
				if (curStep == 308 || curStep == 722 || curStep == 820)
				{
					game.cupheadChaserMode = false;
					game.startCupheadShoot();
				}
				if (curStep == 465 || curStep == 1283)
					game.startCupheadShoot();
				if (curStep == 272 || curStep == 656 || curStep == 784 || curStep == 848 || curStep == 1044)
					game.cupheadChaserMode = true;
				if (curStep == 977 || curStep == 1412)
				{
					game.cupheadChaserMode = false;
					game.startCupheadShoot();
				}

				if (curStep == 1102)
					game.cupheadChaserMode = false;

				// mugman enter stage
				if (curStep == 1151)
				{
					mugdead.animation.play('Stroll', true);
					mugcanhit = true;
					FlxTween.tween(mugdead, {x: boyfriend.x + 200}, 1, {ease: FlxEase.quadInOut});
				}
				if (curStep == 144 || curStep == 400 || curStep == 911 || curStep == 1216)
					game.bumpRate = 1;

				if (curStep == 251 || curStep == 507 || curStep == 1040 || curStep == 1472)
					game.bumpRate = 4;
				if (curStep == 528 || curStep == 880 || curStep == 888 || curStep == 896 || curStep == 904 || curStep == 1184 || curStep == 1208)
					FlxG.camera.zoom += 0.15;

				if (curStep == 1072)
					FlxTween.tween(this, {defaultCamZoom: oldDefaultCamZoom + 0.3}, 6);

				if (curStep == 1536)
					FlxTween.tween(this, {defaultCamZoom: oldDefaultCamZoom + 0.15}, 3.5);

				if (curStep == 1212 || curStep == 1600)
				{
					if (curStep == 1212)
						dad.skipDance = false;
					defaultCamZoom = oldDefaultCamZoom;
				}
				if (curStep == 1167)
				{
					PlayState.instance.cupheadDodge(HADOKEN);
					defaultCamZoom = oldDefaultCamZoom * 4 / 3;
				}
				if (curStep == 1167 + 10)
				{
					dad.playAnim('mafaka', true);
					dad.specialAnim = true;
					dad.skipDance = true;
				}
				if (curStep == 142 || curStep == 398 || curStep == 501 || curStep == 647 || curStep == 772 || curStep == 1598)
					PlayState.instance.cupheadDodge(HADOKEN);
				if (curStep == 603 || curStep == 912)
					PlayState.instance.cupheadDodge(ROUNDABOUT);
		}
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
		if (paused)
		{
			// timer.active = true;
			// tween.active = true;
		}
	}

	override function openSubState(SubState:flixel.FlxSubState)
	{
		if (paused)
		{
			// timer.active = false;
			// tween.active = false;
		}
	}

	// For events
	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch (eventName)
		{
			case "My Event":
		}
	}

	override function eventPushed(event:objects.Note.EventNote)
	{
		// used for preloading assets used on events that doesn't need different assets based on its values
		switch (event.event)
		{
			case "My Event":
				// precacheImage('myImage') //preloads images/myImage.png
				// precacheSound('mySound') //preloads sounds/mySound.ogg
				// precacheMusic('myMusic') //preloads music/myMusic.ogg
		}
	}

	override function eventPushedUnique(event:objects.Note.EventNote)
	{
		// used for preloading assets used on events where its values affect what assets should be preloaded
		switch (event.event)
		{
			case "My Event":
				switch (event.value1)
				{
					// If value 1 is "blah blah", it will preload these assets:
					case 'blah blah':
					// precacheImage('myImageOne') //preloads images/myImageOne.png
					// precacheSound('mySoundOne') //preloads sounds/mySoundOne.ogg
					// precacheMusic('myMusicOne') //preloads music/myMusicOne.ogg

					// If value 1 is "coolswag", it will preload these assets:
					case 'coolswag':
					// precacheImage('myImageTwo') //preloads images/myImageTwo.png
					// precacheSound('mySoundTwo') //preloads sounds/mySoundTwo.ogg
					// precacheMusic('myMusicTwo') //preloads music/myMusicTwo.ogg

					// If value 1 is not "blah blah" or "coolswag", it will preload these assets:
					default:
						// precacheImage('myImageThree') //preloads images/myImageThree.png
						// precacheSound('mySoundThree') //preloads sounds/mySoundThree.ogg
						// precacheMusic('myMusicThree') //preloads music/myMusicThree.ogg
				}
		}
	}

	public static function cupIntro()
	{
		cupteaPlay();

		if (PlayState.SONG.song.toLowerCase() != "devils-gambit")
		{
			wallop = new FlxSprite();
			wallop.frames = Paths.getSparrowAtlas('ready_wallop', 'cup');
			wallop.animation.addByPrefix('start', "Ready? WALLOP!", 24, false);
			wallop.setGraphicSize(Std.int(wallop.width * 0.8));
			wallop.updateHitbox();
			wallop.screenCenter();
			wallop.antialiasing = ClientPrefs.data.antialiasing;
			wallop.scrollFactor.set();
			wallop.cameras = [PlayState.instance.camHUD];
			wallop.alpha = 0.00001;
			PlayState.instance.add(wallop);

			new FlxTimer().start(1.1, function(tmr:FlxTimer)
			{
				wallop.alpha = 1;
				wallop.animation.play('start', true);
				wallop.animation.finishCallback = function(name)
				{
					wallop.destroy();
					PlayState.instance.remove(wallop);
				}
			});

			if (PlayState.SONG.song.toLowerCase() != 'knockout')
			{
				var rando:Int = FlxG.random.int(0, 4);
				countdownNarrator = new FlxSound().loadEmbedded(Paths.sound('intros/normal/' + rando, 'cup'));
				countdownNarrator.play();
			}
			else
			{
				var rando:Int = FlxG.random.int(0, 1);
				countdownNarrator = new FlxSound().loadEmbedded(Paths.sound('intros/angry/' + rando, 'cup'));
				countdownNarrator.play();
			}
			// PlayState.instance.inst.fadeIn(3, 0.5, 1);
		}
	}

	public static function cupteaPlay()
	{
		cupTea.alpha = 1;
		cupTea.animation.play('start', true);
		cupTea.animation.finishCallback = function(name)
		{
			cupTea.alpha = 0.00001;
		}
	}

	public static function cupteaBackout()
	{
		cupTea.alpha = 1;
		cupTea.animation.play('start', true, true);
		cupTea.animation.finishCallback = transFinishCallBack;
	}

	function knockout()
	{
		FlxG.sound.play(Paths.sound('knockout', 'cup'));

		knockoutSpr.alpha = 1;
		knockoutSpr.animation.play('start');

		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			FlxTween.tween(knockoutSpr, {alpha: 0}, 2.5);
			new FlxTimer().start(4, function(tmr:FlxTimer)
			{
				knockoutSpr.alpha = 0.0001;
			});
		});
	}
}
