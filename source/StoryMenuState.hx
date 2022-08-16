package;
import ClientPrefs;
import CoolUtil;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

using StringTools;

#if desktop
import Discord.DiscordClient;
#end

class DiffButton extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var daZoom:Float = 1;
	public var curAnimName:String = 'idle';

	public function new(x:Int, y:Int)
	{
		super(x, y);
		animOffsets = new Map<String, Array<Dynamic>>();
		
		frames = Paths.getSparrowAtlas('story mode/Difficulties', 'preload');
		//diffmechSpr.animation.addByPrefix('Off', 'Mechs Dis instance 1', 24, true);
		//diffmechSpr.animation.addByPrefix('Standrad', 'Mechs Hard instance 1', 24, true);
		//diffmechSpr.animation.addByPrefix('Hell', 'Mechs Hell instance 1', 24, true);

		diffmechSpr.addOffset('Off', 0, 0);
		diffmechSpr.addOffset('Standrad', 0, 0);
		diffmechSpr.addOffset('Hell', 10, 30);

		//playAnim(HelperFunctions.mechDifficultyFromInt(StoryMenuState.curMechDifficulty), true);

        offset.set(0, 0);
		antialiasing = ClientPrefs.globalAntialiasing;
        scrollFactor.set();
	}

	public function setZoom(?toChange:Float = 1):Void
	{
		daZoom = toChange;
		scale.set(toChange, toChange);
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);
		curAnimName = AnimName;

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0] * daZoom, daOffset[1] * daZoom);
		}
		else
		{
			offset.set(0, 0);
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}

class StoryMenuState extends MusicBeatState
{
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();
	public static var weekData:Array<Dynamic> = [
		['Snake-Eyes', 'Technicolor-Tussle', 'Knockout'],
		['Whoopee', 'Sansational', 'Burning-In-Hell', 'Final-Stretch'],
		['Imminent-Demise', 'Terrible-Sin', 'Last-Reel', 'Nightmare-Run']
	];

	var scoreText:FlxText;

	static var curDifficulty:Int = 1;
	public static var curMechDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [true, true, true, false];

	static var curWeek:Int = 0;

	var daScaling:Float = 0.675;

	var actualBG:FlxSprite;

	var bendoBG:FlxSprite;

	var diffifSpr:FlxSprite;
	var diffOrigX:Float = 0;
	var diffTween:FlxTween;

	var diffmechSpr:DiffButton;
	var diffmechOrigX:Int = -2;
	var diffmechTween:FlxTween;

	var options:Array<FlxSprite>;
	var optFlashes:Array<FlxSprite>;
	var optionShit:Array<String> = ['Week1', 'Week2', 'Week3'];

	var actualLeft:Float = 0; // doing this only bc the screen zero isn't the real left side

	var gamingCup:FlxSprite;
	var gamingSands:FlxSprite;
	
	var ismech:Bool = false;

	var cupTea:FlxSprite;

	public static var fromWeek:Int = -1;

	public static var leftDuringWeek:Bool = false;

	var allowTransit:Bool = false;

	var holdshifttext:FlxText;

	override function create()
	{
		super.create();

		persistentUpdate = true;

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		actualBG = new FlxSprite().loadGraphic(Paths.image('story mode/BG', 'preload'));
		actualBG.scrollFactor.set();
		actualBG.setGraphicSize(Std.int(actualBG.width * daScaling));
		actualBG.updateHitbox();
		actualBG.screenCenter();
		actualBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(actualBG);

		gamingSands = new FlxSprite();
		gamingSands.frames = Paths.getSparrowAtlas('story mode/SansStorymodeMenu', 'preload');
		gamingSands.animation.addByPrefix('bruh', 'Saness instance 1', 24, true);
		gamingSands.animation.play('bruh');
		gamingSands.scrollFactor.set();
		gamingSands.setGraphicSize(Std.int(gamingSands.width * (daScaling * 1.5)));
		gamingSands.updateHitbox();
		gamingSands.x = -13;
		gamingSands.y = -41;
		gamingSands.antialiasing = ClientPrefs.globalAntialiasing;
		add(gamingSands);

		bendoBG = new FlxSprite();
		bendoBG.frames = Paths.getSparrowAtlas('story mode/Bendy_Gaming', 'preload');
		bendoBG.animation.addByPrefix('bruh', 'Creepy shit instance 1');
		bendoBG.animation.play('bruh');
		bendoBG.scrollFactor.set();
		bendoBG.setGraphicSize(Std.int(bendoBG.width * daScaling));
		bendoBG.updateHitbox();
		bendoBG.screenCenter();
		bendoBG.antialiasing = ClientPrefs.globalAntialiasing;
		bendoBG.alpha = 0;
		add(bendoBG);

		var leftpanel:FlxSprite = new FlxSprite().loadGraphic(Paths.image('story mode/Left-Panel_above BGs', 'preload'));
		leftpanel.scrollFactor.set();
		leftpanel.updateHitbox();
		leftpanel.screenCenter();
		leftpanel.antialiasing = ClientPrefs.globalAntialiasing;
		add(leftpanel);

		gamingCup = new FlxSprite();
		gamingCup.frames = Paths.getSparrowAtlas('story mode/Cuphead_Gaming', 'preload');
		gamingCup.animation.addByPrefix('bruh', 'Cuphead Gaming instance 1', 24, true);
		gamingCup.animation.play('bruh');
		gamingCup.scrollFactor.set();
		gamingCup.setGraphicSize(Std.int(gamingCup.width * daScaling));
		gamingCup.updateHitbox();
		gamingCup.x = 760;
		gamingCup.y = 233;
		gamingCup.antialiasing = ClientPrefs.globalAntialiasing;
		add(gamingCup);

		var bottompannel:FlxSprite = new FlxSprite().loadGraphic(Paths.image('story mode/Score_bottom panel', 'preload'));
		bottompannel.scrollFactor.set();
		bottompannel.setGraphicSize(Std.int(bottompannel.width * daScaling));
		bottompannel.updateHitbox();
		bottompannel.screenCenter();
		bottompannel.antialiasing = ClientPrefs.globalAntialiasing;
		add(bottompannel);

		diffifSpr = new FlxSprite();
		diffifSpr.frames = Paths.getSparrowAtlas('story mode/Difficulties', 'preload');
		diffifSpr.animation.addByPrefix('EASY', 'Chart Easy instance 1', 24, true);
		diffifSpr.animation.addByPrefix('NORMAL', 'Chart Normal instance 1', 24, true);
		diffifSpr.animation.addByPrefix('HARD', 'Chart Hard instance 1', 24, true);
		diffifSpr.animation.play('NORMAL');
		diffifSpr.scrollFactor.set();
		diffifSpr.setGraphicSize(Std.int(diffifSpr.width * 1.0));
		diffifSpr.updateHitbox();
		diffOrigX = -2;
		diffifSpr.y = 128;
		diffifSpr.antialiasing = ClientPrefs.globalAntialiasing;
		add(diffifSpr);

		diffTween = FlxTween.tween(this, {}, 0);

		diffmechSpr = new DiffButton(diffmechOrigX, 200);
		add(diffmechSpr);

		diffmechTween = FlxTween.tween(this, {}, 0);

		holdshifttext = new FlxText(8, 257, 0, "Hold 'SHIFT' to change", 24);
		holdshifttext.setFormat(Paths.font("Bronx.otf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		holdshifttext.borderSize = 1.5;
		holdshifttext.antialiasing = ClientPrefs.globalAntialiasing;
		holdshifttext.alpha = 0.8;
		add(holdshifttext);

		var storyPanel:FlxSprite = new FlxSprite().loadGraphic(Paths.image('story mode/Storymode', 'preload'));
		storyPanel.scrollFactor.set();
		storyPanel.setGraphicSize(Std.int(storyPanel.width * daScaling));
		storyPanel.updateHitbox();
		storyPanel.screenCenter();
		storyPanel.antialiasing = ClientPrefs.globalAntialiasing;
		add(storyPanel);

		options = [];
		optFlashes = [];

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite().loadGraphic(Paths.image('story mode/Weeks/' + optionShit[i], 'preload'));
			menuItem.setGraphicSize(Std.int(menuItem.width * daScaling));
			add(menuItem);
			options.push(menuItem);
			menuItem.alpha = 0.5;
			menuItem.scrollFactor.set();
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.updateHitbox();
			menuItem.screenCenter();
			actualLeft = menuItem.x;

			var flash = new FlxSprite().loadGraphic(Paths.image('story mode/Weeks/' + optionShit[i] + '_selected', 'preload'));
			flash.setGraphicSize(Std.int(flash.width * daScaling));
			add(flash);
			optFlashes.push(flash);
			flash.alpha = 0;
			flash.scrollFactor.set();
			flash.antialiasing = ClientPrefs.globalAntialiasing;
			flash.updateHitbox();
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat(Paths.font("Bronx.otf"), 32, FlxColor.WHITE, CENTER);
		scoreText.screenCenter();
		scoreText.borderSize = 2.4;
		scoreText.y += 335;
		
		trace("Line 124");

		changeDifficulty();
		changeMechDifficulty();
		changeWeek(curWeek);

		add(scoreText);

		cupTea = new FlxSprite();
		cupTea.frames = Paths.getSparrowAtlas('the_thing2.0', 'preload');
		cupTea.animation.addByPrefix('start', "BOO instance 1", 24, false);
		cupTea.setGraphicSize(Std.int((FlxG.width / FlxG.camera.zoom) * 1.1), Std.int((FlxG.height / FlxG.camera.zoom) * 1.1));
		cupTea.updateHitbox();
		cupTea.screenCenter();
		cupTea.antialiasing = ClientPrefs.globalAntialiasing;
		cupTea.scrollFactor.set();
		if (fromWeek == 0)
		{
			cupTea.alpha = 1;
			cupTea.animation.play('start', true);
			cupTea.animation.finishCallback = function(name)
			{
				cupTea.alpha = 0.00001;
			}
		}
		else
		{
			cupTea.alpha = 0.00001;
		}
		add(cupTea);

		#if android
		addvirtualPad(UP_DOWN, A_B_C);
		#end

//		new FlxTimer().start(Main.transitionDuration, function(tmr:FlxTimer)
//		{
//			allowTransit = true;
//		});
  	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null && !lockInput)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music("freakyMenu"));
		}

		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));
		
		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "WEEK SCORE: " + lerpScore;
		scoreText.x = FlxG.width / 2 - scoreText.width / 2;

		if (!lockInput)
		{
			if (controls.UI_UP_P)
			{
				changeWeek(curWeek - 1);
			}

			if (controls.UI_DOWN_P)
			{
				changeWeek(curWeek + 1);
			}

			if (FlxG.keys.pressed.SHIFT #if android || virtualPad.buttonC.pressed #end) //holding shift while changing diffiuclty, change mech diff
			{
				if (controls.UI_RIGHT_P)
					changeMechDifficulty(-1);
				if (controls.UI_LEFT_P)
					changeMechDifficulty(1);
			}
			else //not holding shift, change chart diffiuclty
			{
				if (controls.UI_RIGHT_P)
					changeDifficulty(1);
				if (controls.UI_LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}

			if (controls.BACK)
			{
				backOut();
			}
		}

		for (i in 0...options.length)
		{
			if (i != curWeek && options[i].alpha > 0.5)
				options[i].alpha -= 0.01;
			options[i].x += (actualLeft - options[i].x) / 6;

			if (optFlashes[i].alpha > 0)
				optFlashes[i].alpha -= 0.01;
			optFlashes[i].x = options[i].x;
			optFlashes[i].y = options[i].y;
		}

		super.update(elapsed);
	}
	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}
	function backOut()
	{
		if (!lockInput && allowTransit)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			lockInput = true;
	
			FlxG.switchState(new MainMenuState());
		}
	}

	var stopspamming:Bool = false;
	var lockInput:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek] && curWeek < 3)
		{
			if (stopspamming == false)
			{
				{
					aaaaa();
				}
			}
		}
		else
		{
			FlxG.camera.shake(0.01);
			FlxG.sound.play(Paths.sound('weekDeny', 'shared'));
		}
	}

	function aaaaa()
	{
		var waitDuration:Float = 1;

		switch (curWeek)
		{
			case 0:
//				FNFState.disableNextTransOut = true; removed because idk how to remove the transition in psych :v
//				waitDuration = 1.1;
				cupTea.alpha = 1;
				cupTea.animation.play('start', true, true);
				FlxG.sound.play(Paths.sound('boing', 'cup'), 1);
				FlxG.sound.music.volume = 0;

//				OptionsMenu.returnedfromOptions = false;
			default:
				if (FlxG.sound.music != null)
				{
					FlxG.sound.music.fadeOut(1, 0);
				}
				FlxG.sound.play(Paths.sound('confirmMenu'));

				options[curWeek].x -= 15;
				optFlashes[curWeek].alpha = 1;

//				OptionsMenu.returnedfromOptions = false;

				for (i in 0...options.length)
				{
					var spr = options[i];
					if (curWeek != i)
					{
						FlxTween.tween(spr, {alpha: 0}, 1.3, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
				}
		}

		if (curWeek == 2 && curDifficulty != 2)
		{
			PlayState.storyPlaylist = ['Imminent-Demise', 'Terrible-Sin', 'Last-Reel'];
		}
		else
		{
			if (curWeek == 1)
			{
				PlayState.storyPlaylist = ['Whoopee', 'Sansational'];
			}
			else
			{
				PlayState.storyPlaylist = weekData[curWeek];
			}
		}
		
		PlayState.isStoryMode = true;
		lockInput = true;

		PlayState.storyDifficulty = curDifficulty;
		PlayState.storyDifficulty = curDifficulty;

		var poop:String = Highscore.formatSong(PlayState.storyPlaylist[0], curDifficulty);

//		PlayState.geno = false;

//		HelperFunctions.checkExistingChart(PlayState.storyPlaylist[0], poop);
		CoolUtil.getDifficultyFilePath(curDifficulty);
		PlayState.storyWeek = curWeek;
		PlayState.mechStoryDifficulty = curMechDifficulty;
		PlayState.campaignScore = 0;

//		MusicBeatState.switchState( new PlayState());
		//LoadingState.stopMusic = true;

//		PlayState.storyIndex = 1;

		new FlxTimer().start(waitDuration, function(tmr:FlxTimer)
		{
			PlayState.seenCutscene = true;

			MusicBeatState.switchState(new PlayState());
		});

		stopspamming = true;
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		switch (curDifficulty)
		{
			case 0:
				diffifSpr.animation.play('EASY');
			case 1:
				diffifSpr.animation.play('NORMAL');
			case 2:
				diffifSpr.animation.play('HARD');
		}

		diffifSpr.x = diffOrigX - 20;

		if (diffTween != null)
			diffTween.cancel();

		diffTween = FlxTween.tween(diffifSpr, {x: diffOrigX}, 0.2, {ease: FlxEase.quadOut});

		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}

	function changeMechDifficulty(change:Int = 0):Void
	{
		curMechDifficulty += change;

		if (curMechDifficulty < 0)
			curMechDifficulty = 2;
		if (curMechDifficulty > 2)
			curMechDifficulty = 0;

		switch (curMechDifficulty)
		{
			case 0:
		diffmechSpr.animation.addByPrefix('Off', 'Mechs Dis instance 1', 24, true);
		diffmechSpr.animation.addByPrefix('Standrad', 'Mechs Hard instance 1', 24, true);
		diffmechSpr.animation.addByPrefix('Hell', 'Mechs Hell instance 1', 24, true);
				diffmechSpr.playAnim('Off');
			case 1:
		diffmechSpr.animation.addByPrefix('Off', 'Mechs Dis instance 1', 24, true);
		diffmechSpr.animation.addByPrefix('Standrad', 'Mechs Hard instance 1', 24, true);
		diffmechSpr.animation.addByPrefix('Hell', 'Mechs Hell instance 1', 24, true);
				diffmechSpr.playAnim('Standrad');
			case 2:
		diffmechSpr.animation.addByPrefix('Off', 'Mechs Dis instance 1', 24, true);
		diffmechSpr.animation.addByPrefix('Standrad', 'Mechs Hard instance 1', 24, true);
		diffmechSpr.animation.addByPrefix('Hell', 'Mechs Hell instance 1', 24, true);
				diffmechSpr.playAnim('Hell');
		}

		diffmechSpr.x = diffmechOrigX - 20;

		if (diffmechTween != null)
			diffmechTween.cancel();

		diffmechTween = FlxTween.tween(diffmechSpr, {x: diffmechOrigX}, 0.2, {ease: FlxEase.quadOut});
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		var lSel = curWeek;

		if (change >= weekData.length)
			change = 0;
		if (change < 0)
			change = weekData.length - 1;

		curWeek = change;

		switch (curWeek)
		{
			default:
				actualBG.alpha = 1;
				bendoBG.alpha = 0;
				actualBG.loadGraphic(Paths.image('story mode/BG', 'preload'));
				gamingCup.alpha = 1;
				gamingSands.alpha = 0;
			case 1:
				actualBG.alpha = 0;
				bendoBG.alpha = 0;
				gamingCup.alpha = 0;
				gamingSands.alpha = 1;
			case 2:
				actualBG.alpha = 0;
				bendoBG.alpha = 1;
				gamingCup.alpha = 0;
				gamingSands.alpha = 0;
			case 3:
				actualBG.alpha = 0;
				bendoBG.alpha = 0;
				gamingCup.alpha = 0;
				gamingSands.alpha = 0;
		}

		if (change != curWeek)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}

		optionUpdate(lSel, '');
		optionUpdate(curWeek, '_selected');

		options[curWeek].x -= 40;
		options[curWeek].alpha = 1;

		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}

	function optionUpdate(num:Int, type:String)
	{
		options[num].loadGraphic(Paths.image('story mode/Weeks/' + optionShit[num] + type, 'preload'));
		options[num].updateHitbox();
		options[num].screenCenter(X);
	}
}
