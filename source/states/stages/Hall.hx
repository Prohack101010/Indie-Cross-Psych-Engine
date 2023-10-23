package states.stages;

import psychlua.FunkinLua;
import states.PlayState;

class Hall extends BaseStage
{
	var blue = true;
	public static var bg:FlxSprite;
	public static var finalStretchWaterFallBG:FlxSprite;
	public static var finalStretchwhiteBG:FlxSprite;
	public static var finalStretchBarTop:FlxSprite;
	public static var finalStretchBarBottom:FlxSprite;
	public static var battleBoundaries:flixel.math.FlxRect;
	public static var battleBG:FlxSprite;
	public static var nightmareSansBgs:Array<FlxSprite>;

	var videoName:String;
	var oldDefaultCamZoom:Float;
	var hasBlackBars:Bool = false;

	override function create()
	{
		if(PlayState.curStage == 'hall'){
		PlayState.instance.filters.push(MusicBeatState.instance.brightShader);
		oldDefaultCamZoom = defaultCamZoom = 0.9;
		PlayState.instance.camZooming = true;
		bg = new FlxSprite();
		if (songName == 'burning-in-hell')
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

		if (songName == 'final-stretch')
		{
			finalStretchWaterFallBG = new FlxSprite(0, 0).loadGraphic(Paths.image('Waterfall', 'sans'));
			finalStretchWaterFallBG.setGraphicSize(Std.int(bg.width * 1.5));
			finalStretchWaterFallBG.updateHitbox();
			finalStretchWaterFallBG.screenCenter();
			finalStretchWaterFallBG.x -= 300;
			finalStretchWaterFallBG.alpha = 0.0001;
			finalStretchWaterFallBG.antialiasing = ClientPrefs.data.antialiasing;
			add(finalStretchWaterFallBG);

			finalStretchwhiteBG = new FlxSprite(-640, -640).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.WHITE);
			finalStretchwhiteBG.scrollFactor.set(0, 0);
			finalStretchwhiteBG.alpha = 0.0001;
			add(finalStretchwhiteBG);

			finalStretchBarTop = new FlxSprite(-640, -560).makeGraphic(FlxG.width * 2, 560, FlxColor.BLACK);
			finalStretchBarTop.cameras = [camOther];
			add(finalStretchBarTop);

			finalStretchBarBottom = new FlxSprite(-640, 720).makeGraphic(FlxG.width * 2, 560, FlxColor.BLACK);
			finalStretchBarBottom.cameras = [camOther];
			add(finalStretchBarBottom);
		}

		if (songName == 'sansational' || songName == 'burning-in-hell')
		{
			battleBG = new FlxSprite(-600, 0).loadGraphic(Paths.image('battel', 'sans'));
			battleBG.antialiasing = false;
			battleBG.scrollFactor.set(1, 1);
			battleBG.alpha = 0.0001;
			//	battleBG.setGraphicSize(Std.int(battle.width));
			battleBG.antialiasing = ClientPrefs.data.antialiasing;
			battleBG.updateHitbox();
			add(battleBG);
			battleBoundaries = new flixel.math.FlxRect(battleBG.x + 220, battleBG.y + 1239, 1516, 750);
		}
		switch (songName)
		{
			case 'whoopee':
				// game.startVideo('sans/1', false);
				videoName = 'sans/1';
			case 'sansational':
				videoName = 'sans/2';
				PlayState.instance.addCharacterToList('UT_BF', 0);
				PlayState.instance.addCharacterToList('sans-mad', 1);
			// game.startVideo('sans/2', false);
			case 'burning-in-hell':
				// game.startVideo('sans/3b', false);
				PlayState.instance.addCharacterToList('bf-utchara', 0);
				PlayState.instance.addCharacterToList('sans-mad', 1);
				PlayState.instance.endCallback = function()
				{
					PlayState.instance.startVideo('sans/4b');
					PlayState.instance.videoEndCallback = function()
					{
						PlayState.instance.finishSong(true);
					}
				}
				PlayState.instance.brightSetup();
				videoName = 'sans/3b';
			case 'final-stretch':
				// game.startVideo('sans/3', false);
				videoName = 'sans/3';
				PlayState.instance.addCharacterToList('bfSansWT', 0);
				PlayState.instance.addCharacterToList('sans-tired', 1);
				PlayState.instance.endCallback = function()
				{
					PlayState.instance.startVideo('sans/4');
					PlayState.instance.videoEndCallback = function()
					{
						PlayState.instance.finishSong(true);
					}
				}
			default:
				videoName = 'intro';
		}
		game.startCallback = playVideoAndDialogue;
		} else if(PlayState.curStage == 'nightmare-hall'){
					nightmareSansBgs = [];

					var beatDropbg:FlxSprite = new FlxSprite(-100, 300);
					var bg:FlxSprite = new FlxSprite(-600, -160);

					bg.frames = Paths.getSparrowAtlas('Nightmare Sans Stage', 'sans');
					bg.animation.addByIndices('normal', 'Normal instance 1', [0], '', 24, false);
					bg.animation.addByPrefix('beatdrop', 'Normal instance 1', 24, true);
					bg.animation.addByPrefix('beatDropFinish', 'sdfs instance 1', 24, false);
					bg.animation.play('normal');
					bg.scrollFactor.set(1, 1);
					bg.antialiasing = ClientPrefs.data.antialiasing;

					add(bg);

					beatDropbg.frames = Paths.getSparrowAtlas('Nightmare Sans Stage', 'sans');
					beatDropbg.animation.addByPrefix('beatHit', 'dd instance 1', 32, false);
					beatDropbg.scrollFactor.set(0, 0);
					beatDropbg.blend = ADD;
					beatDropbg.antialiasing = ClientPrefs.data.antialiasing;
					beatDropbg.alpha = 0;
					add(beatDropbg);
					beatDropbg.cameras = [camOther];
					nightmareSansBgs.push(bg);
					nightmareSansBgs.push(beatDropbg);

					nightmareSansBGManager('normal');
		}
	}

	function playVideoAndDialogue()
	{
		if (PlayState.isStoryMode && !PlayState.seenCutscene)
		{
			game.noCountdownVideo(videoName);
			PlayState.instance.video.onEndReached.add(game.sanesIntroShit, true); // IDFK WHY PLAYSTATE.INSTANCE HAXE JUST DON'T WANT ME TO USE GAME. OR GONNA SHUT ME UP WITH NULL OBJECT REFRENCE
		}
		else
			PlayState.instance.startCountdown();
	}

	override function createPost()
	{
	}
	override function update(elapsed:Float)
	{
	}
	override function stepHit()
	{
		switch (songName)
		{
			case 'whoopee':
				if (curStep == 16)
				{
					PlayState.instance.brightSpeed = 0.0000001;
					FlxTween.tween(PlayState.instance, {defaultBrightVal: -0.25}, 5);
					FlxTween.tween(PlayState.instance, {defaultCamZoom: PlayState.instance.defaultCamZoom + 0.4}, 5);
				}
				if (curStep == 32)
					PlayState.instance.sansAttack(BONES);
				if (curStep == 155)
				{
					dad.playAnim('snap', true);
					dad.specialAnim = true;
				}
				if (curStep == 160)
				{
					PlayState.instance.dodgeHud.alpha = 0.00001;
					FlxTween.tween(PlayState.instance, {defaultBrightVal: 0}, 0.6);
					PlayState.instance.defaultCamZoom = 0.9;
				}
			case 'sansational':
				if (curStep == 780 && game.attacked)
					toggelUTMode();

			case 'final-stretch':
				if (curStep == 1)
					FlxTween.tween(this, {defaultCamZoom: oldDefaultCamZoom + 0.15}, 9, {ease: FlxEase.quadInOut});
				if (curStep == 128)
				{
					FlxG.camera.zoom += 0.2;
					defaultCamZoom = oldDefaultCamZoom;
				}
				if (curStep == 384)
					defaultCamZoom += 0.10;
				if (curStep == 434 || curStep == 440 || curStep == 562 || curStep == 568)
					FlxG.camera.zoom += 0.05;
				if (curStep == 766)
				{
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						camGame.visible = true; // the game might freeze which canstop the cam from apearing again, this hopefully fixes it
					});
					camGame.visible = false;
					FlxG.sound.play(Paths.sound('countdown', 'sans'));
					defaultCamZoom = oldDefaultCamZoom;
					FlxG.camera.zoom += 0.10;
					waterFallEvent();
				}
				if (curStep == 768)
				{
					camGame.visible = true;
					FlxG.sound.play(Paths.sound('countdown', 'sans'));
				}
				if (curStep == 896)
				{
					FlxG.camera.zoom += 0.10;
					PlayState.instance.bumpRate = 1;
					FlxTween.tween(this, {defaultCamZoom: oldDefaultCamZoom + 0.15}, 1.35, {ease: FlxEase.quadInOut});
					blackBars();
				}
				if (curStep == 1150)
				{
					PlayState.instance.bumpRate = 4;
					FlxTween.tween(this, {defaultCamZoom: oldDefaultCamZoom}, 1.35, {ease: FlxEase.quadInOut});
					blackBars();
				}
				if (curStep == 1276)
				{
					new FlxTimer().start(1.5, function(tmr:FlxTimer)
					{
						camGame.visible = true;
					});
					camGame.visible = false;
					FlxG.sound.play(Paths.sound('countdown', 'sans'));
					defaultCamZoom += 0.10;
					FlxG.camera.zoom += 0.10;
					waterFallEvent();
				}
				if (curStep == 1278)
				{
					camGame.visible = true;
					FlxG.sound.play(Paths.sound('countdown', 'sans'));
				}
				if (curStep == 1792)
				{
					finalStretchwhiteBG.visible = true;
					finalStretchwhiteBG.alpha = 0.0001;
					FlxTween.tween(finalStretchwhiteBG, {alpha: 1.0}, 1.5, {ease: FlxEase.quadInOut});
					FlxTween.color(boyfriend, 1.5, FlxColor.WHITE, FlxColor.BLACK, {ease: FlxEase.quadInOut});
					FlxTween.color(dad, 1.5, FlxColor.WHITE, FlxColor.BLACK, {ease: FlxEase.quadInOut});
					FlxTween.tween(this, {defaultCamZoom: oldDefaultCamZoom + 0.10}, 10, {ease: FlxEase.quadInOut});
					blackBars();
				}
				if (curStep == 2048)
				{
					FlxG.camera.zoom += 0.10;
					defaultCamZoom = oldDefaultCamZoom;
					finalStretchwhiteBG.visible = false;
					boyfriend.color = FlxColor.WHITE;
					dad.color = FlxColor.WHITE;
					camHUD.visible = false;
					if (finalStretchBarTop != null)
					{
						finalStretchBarTop.visible = false;
					}
					if (finalStretchBarBottom != null)
					{
						finalStretchBarBottom.visible = false;
					}
					for (i in 0...8)
					{
						PlayState.instance.strumLineNotes.members[i].y = PlayState.instance.opponentStrums.members[0].y;
					}
				}
			case 'burning-in-hell':
				if (curStep == 368)
				{
					dad.playAnim('snap', true);
					dad.specialAnim = true;
				}

				if (curStep == 377 || curStep == 379 || curStep == 1148 || curStep == 1150)
				{
					camGame.visible = false;
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						camGame.visible = true;
					});
				}
				if (curStep == 380 || curStep == 1151)
				{
					camGame.visible = true;
				}
				if (curStep == 378 || curStep == 1149)
				{
					camGame.visible = true;
					toggelUTMode();
				}
				if (curStep == 384 || curStep == 1537)
				{
					game.bumpRate = 1;
				}
				if (curStep == 400 || curStep == 662)
				{
					game.doutshit();
				}
				if (curStep == 405 || curStep == 415 || curStep == 430 || curStep == 455 || curStep == 481 || curStep == 674 || curStep == 684
					|| curStep == 700 || curStep == 710 || curStep == 725 || curStep == 735)
				{
					game.blastem(game.soul.y);
				}
				if (curStep == 508 || curStep == 762)
				{
					game.dontutshit();
				}
				if (curStep == 640 || curStep == 1521)
				{
					game.bumpRate = 4;
				}
				if (curStep == 895)
				{
					toggelUTMode();
				}
				if (curStep == 1408)
				{
					game.bumpRate = 1;
					toggelUTMode();
				}
				if (curStep == 1664)
				{
					FlxG.camera.zoom += 0.2;
					FlxTween.tween(this, {defaultCamZoom: oldDefaultCamZoom + 0.3}, 14, {ease: FlxEase.quadInOut});
					game.bumpRate = 4;
				}
				if (curStep == 1902)
				{
					FlxG.camera.zoom += 0.2;
					FlxTween.tween(camHUD, {alpha: 0.0}, 4.5, {ease: FlxEase.quadInOut});
					FlxTween.tween(this, {defaultCamZoom: oldDefaultCamZoom + 0.15}, 4.5, {ease: FlxEase.quadInOut});
					game.bumpRate = 64;
				}
			case 'bad-time':
				if(curStep == 384 || curStep == 768 || curStep == 1184)
					nightmareSansBGManager('beatdrop');
				if(curStep == 512 || curStep ==  928 || curStep == 1440)
					nightmareSansBGManager('beatdropFinished');
				if(curStep == 140 ||
					curStep == 268 ||
					curStep == 333 ||
					curStep == 528 ||
					curStep == 669 ||
					curStep == 720 ||
					curStep == 778 ||
					curStep == 832 ||
					curStep == 856 ||
					curStep == 941 ||
					curStep == 969 ||
					curStep == 1072 ||
					curStep == 1136 ||
					curStep == 1232 ||
					curStep == 1313 ||
					curStep == 1366 ||
					curStep == 1456){
					blue = !blue;
				if (blue)
					game.triggerEvent('Sans Bones Attack', 'blue', '', 0);
				else
					game.triggerEvent('Sans Bones Attack', 'orange', '', 0);
			}
		}
	}
	

	override function beatHit()
	{
		if (PlayState.curStage == 'nightmare-hall' && curBeat % 2 == 0)
			{
				nightmareSansBgs[1].animation.play('beatHit', true);
			}
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

	function toggelUTMode()
	{
		if ((dad.curCharacter == 'sans' || dad.curCharacter == 'sans-mad')
			&& (boyfriend.curCharacter == 'bfSans' || boyfriend.curCharacter == 'chara'))
		{
			if (game.bfDodge != null)
				game.bfDodge.alpha = 0.0001;
			boyfriend.alpha = 1;
			battleBG.alpha = 1;
			game.utMode = true;
			var playerUT:String;
			if (boyfriend.curCharacter == 'chara')
				playerUT = 'bf-utchara';
			else
				playerUT = 'UT_BF';
			PlayState.instance.triggerEvent('Change Character', '', playerUT, 0);
			PlayState.instance.triggerEvent('Change Character', 'dad', 'sans-ut', 0);

			if (bg != null)
			{
				bg.alpha = 0.0001;
			}

			PlayState.instance.attackHud.alpha = 0.0001;
			PlayState.instance.dodgeHud.alpha = 0.0001;

			// defaultCamZoom = 0.35;
			defaultCamZoom = 0.45;
		}
		else
		{
			boyfriend.alpha = 1;
			battleBG.alpha = 0.0001;
			game.utMode = false;
			var playerUT:String;
			if (boyfriend.curCharacter == 'bf-utchara')
				playerUT = 'chara';
			else
				playerUT = 'bfSans';
			PlayState.instance.triggerEvent('Change Character', '', playerUT, 0);
			if (songName == 'burning-in-hell')
				PlayState.instance.triggerEvent('Change Character', 'dad', 'sans-mad', 0);
			else
				PlayState.instance.triggerEvent('Change Character', 'dad', 'sans', 0);
			bg.alpha = 1;

			PlayState.instance.attackHud.alpha = game.dodgeHud.getDefaultAlpha();
			PlayState.instance.dodgeHud.alpha = game.dodgeHud.getDefaultAlpha();

			defaultCamZoom = 0.9;
		}
	}

	function blackBars()
	{
		if (!hasBlackBars)
		{
			hasBlackBars = true;

			FlxTween.tween(finalStretchBarTop, {y: finalStretchBarTop.y + 112}, 1.5, {ease: FlxEase.quadInOut});

			FlxTween.tween(finalStretchBarBottom, {y: finalStretchBarBottom.y - 112}, 1.5, {ease: FlxEase.quadInOut});

			for (i in 0...8)
			{
				if (ClientPrefs.data.downScroll)
				{
					FlxTween.tween(PlayState.instance.strumLineNotes.members[i], {y: PlayState.instance.opponentStrums.members[0].y - 70}, 1.5,
						{ease: FlxEase.quadInOut});
				}
				else
				{
					FlxTween.tween(PlayState.instance.strumLineNotes.members[i], {y: PlayState.instance.opponentStrums.members[0].y + 70}, 1.5,
						{ease: FlxEase.quadInOut});
				}
			}
		}
		else
		{
			hasBlackBars = false;

			if (finalStretchBarTop != null)
			{
				FlxTween.tween(finalStretchBarTop, {y: finalStretchBarTop.y - 112}, 1.5, {ease: FlxEase.quadInOut});
			}

			if (finalStretchBarBottom != null)
			{
				FlxTween.tween(finalStretchBarBottom, {y: finalStretchBarBottom.y + 112}, 1.5, {ease: FlxEase.quadInOut});
			}

			for (i in 0...8)
			{
				if (ClientPrefs.data.downScroll)
				{
					FlxTween.tween(PlayState.instance.strumLineNotes.members[i], {y: PlayState.instance.opponentStrums.members[0].y + 70}, 1.5,
						{ease: FlxEase.quadInOut});
				}
				else
				{
					FlxTween.tween(PlayState.instance.strumLineNotes.members[i], {y: PlayState.instance.opponentStrums.members[0].y - 70}, 1.5,
						{ease: FlxEase.quadInOut});
				}
			}
		}
	}

	override function opponentNoteHit(){
		if(PlayState.curStage == 'nightmare-hall'){
			FlxG.camera.shake(0.030, 0.1);
			game.camHUD.shake(0.010, 0.1);
			game.chromVal = (FlxG.random.float(0.005, 0.01) * 2);
			FlxTween.tween(game, {chromVal: 0}, FlxG.random.float(0.05, 0.12));
		}
	}

	function waterFallEvent()
	{
		if (finalStretchWaterFallBG.alpha != 1)
		{
			finalStretchWaterFallBG.alpha = 1;
			PlayState.instance.triggerEvent('Change Character', '', 'bfSansWT', 0);
			PlayState.instance.triggerEvent('Change Character', 'dad', 'sans-tired', 0);
		}
		else
		{
			finalStretchWaterFallBG.alpha = 0.0001;
			PlayState.instance.triggerEvent('Change Character', 'dad', 'sans', 0);
			PlayState.instance.triggerEvent('Change Character', '', "bfSans", 0);
		}
	}

	function nightmareSansBGManager(mode:String)
		{
			if(PlayState.curStage == 'nightmare-hall'){
			switch (mode)
			{
				case 'normal':
					nightmareSansBgs[0].animation.play('normal', true);
					nightmareSansBgs[0].alpha = 1;
					nightmareSansBgs[1].alpha = 0;
				case 'beatdrop':
					nightmareSansBgs[0].animation.play('beatdrop', true);
					nightmareSansBgs[0].alpha = 1;
					nightmareSansBgs[1].alpha = 0;
				case 'beatdropFinished':
					nightmareSansBgs[0].animation.play('beatDropFinish', true);
					nightmareSansBgs[0].alpha = 1;
					nightmareSansBgs[1].alpha = 1;
			}
		}
	}
}
