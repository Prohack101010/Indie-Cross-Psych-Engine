package;

import flixel.util.FlxTimer;
import haxe.Timer;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxCamera;
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import Song.SwagSong;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
#if MODS_ALLOWED
import sys.FileSystem;
#end
import openfl.filters.ShaderFilter;
import Shaders;
import openfl.filters.BitmapFilter;
import Conductor;
import Song;
using StringTools;

class FreeplayState extends MusicBeatState {
	var canPress:Bool = true;
	var cupTea:FlxSprite;
  var defaultZoom:Float = 1;
	var camZoom:FlxTween;
  public var chromVal:Float = 0;
  public var FlxTimer:FlxTimerManager;
  var allowInstPrev:Bool = false;
	var songs:Array<SongMetadata> = [];
public static var SONG:SwagSong = null;
	var selector:FlxText;
	private static var curSelected:Int = 0;
	var curDifficulty:Int = 0;
	private static var lastDifficultyName:String = '';
	public var camHud:FlxCamera;
	public var camGame:FlxCamera;
	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];
	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var filters:Array<BitmapFilter> = [];
	var selectedSongBpm:Int;

	override function create()
	{
	FlxG.game.filtersEnabled = true;
	filters.push(chromaticAberration);
	FlxG.game.setFilters(filters);
	/*if (ClientPrefs.Shaders && FreeplaySelectState.curSelectedNightmare == true) {
		FlxG.camera.setFilters([Shaders.chromaticAberration]);
		camHud.setFilters([Shaders.chromaticAberration]);
		Shaders.setChrome(0);
	}*/
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if allow_discord_rpc
		
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		for (i in 0...WeekData.weeksList.length) {
			if(weekIsLocked(WeekData.weeksList[i])) continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		WeekData.loadTheFirstEnabledMod();

		/*		//KIND OF BROKEN NOW AND ALSO PRETTY USELESS//

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		for (i in 0...initSonglist.length)
		{
			if(initSonglist[i] != null && initSonglist[i].length > 0) {
				var songArray:Array<String> = initSonglist[i].split(":");
				ong(songArray[0], 0, songArray[1], Std.parseInt(songArray[2]));
			}
		}*/
		camGame = new FlxCamera();
		camHud = new FlxCamera();


		camHud.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHud, false);

		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("Bronx.otf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);
		for (i in 0...songs.length)
			{
				var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
				songText.isMenuItem = true;
				songText.targetY = i;
				grpSongs.add(songText);
	
				if (songText.width > 980)
				{
					var textScale:Float = 980 / songText.width;
					songText.scale.x = textScale;
					for (letter in songText.lettersArray)
					{
						letter.x *= textScale;
						letter.offset.x *= textScale;
					}
					//songText.updateHitbox();
					//trace(songs[i].songName + ' new scale: ' + textScale);
				}
	
			scoreText.cameras = [camHud];
			scoreBG.cameras = [camHud];
			diffText.cameras = [camHud];
	
				Paths.currentModDirectory = songs[i].folder;
				var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
				icon.sprTracker = songText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
	
				// songText.x += 40;
				// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
				// songText.screenCenter(X);
			}

		if(curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].color;
		intendedColor = bg.color;

		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		//curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		changeDiff(false);
		changeSelection();
		

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		cupTea = new FlxSprite();
		cupTea.frames = Paths.getSparrowAtlas('the_thing2.0');
		cupTea.animation.addByPrefix('start', "BOO instance 1", 24, false);
		cupTea.setGraphicSize(Std.int((FlxG.width / FlxG.camera.zoom) * 1.1), Std.int((FlxG.height / FlxG.camera.zoom) * 1.1));
		cupTea.updateHitbox();
		cupTea.screenCenter();
		cupTea.scrollFactor.set();
		cupTea.alpha = 0.0001;
		cupTea.cameras = [camHud];

		#if PRELOAD_ALL
			#if android
			var leText:String = "Press X to enable/disable instrument preview / Press C to open the Gameplay Changers Menu / Press Y to Reset your Score and Accuracy.";
			var size:Int = 16;
			#else
			var leText:String = "Press Q to enable/disable instrument preview / Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
			var size:Int = 16;
			#end
		#else
			#if android
			var leText:String = "Press C to open the Gameplay Changers Menu / Press Y to Reset your Score and Accuracy.";
			var size:Int = 18;
			#else
			var leText:String = "Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
			var size:Int = 18;
			#end
		#end
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("Bronx.otf"), size, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);
		camZoom = FlxTween.tween(this, {}, 0);
		#if android
		addVirtualPad(LEFT_FULL, A_B_C_X_Y_Z);
		//virtualPad.y = -26;
		#end

		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	/*public function addWeek(songs:Array<String>, weekNum:Int, weekColor:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);
			this.songs[this.songs.length-1].color = weekColor;

			if (songCharacters.length != 1)
				num++;
		}
	}*/
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
		curDifficulty = 0;
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';
		positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var q = FlxG.keys.justPressed.Q #if android || virtualPad.buttonX.justPressed #end;
		var ctrl = FlxG.keys.justPressed.CONTROL #if android || virtualPad.buttonC.justPressed #end;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT #if android || virtualPad.buttonZ.pressed #end) shiftMult = 3;

		if(songs.length > 1)
		{
			if (upP)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (downP)
			{
				changeSelection(shiftMult);
				holdTime = 0;
			}

			if(controls.UI_DOWN || controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					changeDiff(false);
				}
			}

			if(FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				changeSelection(-shiftMult * FlxG.mouse.wheel, false);
				changeDiff(false);
			}
		}

		if (controls.UI_LEFT_P)
			changeDiff();
		else if (controls.UI_RIGHT_P)
			changeDiff();
		else if (upP || downP) changeDiff(false);

		if (controls.BACK)
		{
			persistentUpdate = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new FreeplaySelectState());
		if (allowInstPrev) {
		FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
		FlxG.sound.music.fadeIn(4, 0, 0.7);
		allowInstPrev = false;
			}
		}

		if(ctrl)
		{
			#if android
			removeVirtualPad();
			#end
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		if(q && canPress)
		{
		canPress = false;
		new FlxTimer().start(2, function(tmr:FlxTimer) {
			canPress = true;
			});
		if (!allowInstPrev) { 
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxG.sound.music.fadeOut(1, 0);
				allowInstPrev = true;
				trace('inst preview is now enabled');
				var enabling:FlxTimer;
				enabling = new FlxTimer();
				enabling.start(1.5, enableInstPrev);
				return;
		}
		else if (allowInstPrev) {
		  FlxG.sound.play(Paths.sound('cancelMenu'));
		  FlxG.sound.music.fadeOut(0.5, 0);
		  allowInstPrev = false;
		var disabling:FlxTimer;
		disabling = new FlxTimer();
		disabling.start(0.5, disablingInstPrev);
		  trace('inst preview is now disabled');
		}
		}

		if (accepted)
		{
					if (songs[curSelected].songName == 'devils-gambit' || songs[curSelected].songName == 'satanic-funkin' || songs[curSelected].songName == 'snake-eyes' || songs[curSelected].songName == 'technicolor-tussle' || songs[curSelected].songName == 'knockout') {
		cupTea.alpha = 1;
		cupTea.animation.play('start', true);
		FlxG.sound.play(Paths.sound('boing'));
		FlxTransitionableState.skipNextTransIn = true;
					}
			//persistentUpdate = false;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
			/*#if MODS_ALLOWED
			if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
			#else
			if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
			#end
				poop = songLowercase;
				curDifficulty = 1;
				trace('Couldnt find file');
			}*/
			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
			if(colorTween != null) {
				colorTween.cancel();
			}
			
			if (FlxG.keys.pressed.SHIFT #if android || virtualPad.buttonZ.pressed #end){
				LoadingState.loadAndSwitchState(new ChartingState());
			}else{
				LoadingState.target = new PlayState();
				LoadingState.stopMusic = true;
				MusicBeatState.switchState(new LoadingState());
				//LoadingState.loadAndSwitchState(new PlayState(), true);
			}

			FlxG.sound.music.volume = 0;
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
		}
		else if(controls.RESET #if android || virtualPad.buttonY.justPressed #end)
		{
			#if android
			removeVirtualPad();
			#end
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		super.update(elapsed);
		Shaders.setChrome(chromVal);
		switch(songs[curSelected].songName.toLowerCase()) {
			case 'snake eyes':
			selectedSongBpm = 221;
			case 'tehcnicolor tussle':
			selectedSongBpm = 140;
			case 'knockout':
			selectedSongBpm = 136;
			case 'whoopee':
			selectedSongBpm = 120;
			case 'sansational':
			selectedSongBpm = 130;
			case 'burning in hell':
			selectedSongBpm = 170;
			case 'final stretch':
			selectedSongBpm = 175;
			case 'imminent demise':
			selectedSongBpm = 100;
			case 'terrible sin':
			selectedSongBpm = 220;
			case 'last reel':
			selectedSongBpm = 180;
			case 'nightmare-run':
			selectedSongBpm = 167;
			case 'satanic funkin':
			selectedSongBpm = 180;
			case 'bad to the bone':
			selectedSongBpm = 118;
			case 'bonedoggle':
			selectedSongBpm = 150;
			case 'ritual':
			selectedSongBpm = 160;
			case 'freaky machine':
			selectedSongBpm = 130;
			case 'devils-gambit':
			selectedSongBpm = 175;
			case 'bad-time':
			selectedSongBpm = 330;
			case 'despair':
			selectedSongBpm = 375;
		}
	}
	override function beatHit()
	{
		super.beatHit();
		if (allowInstPrev == true) {
				FlxG.camera.zoom += 0.015;
				camZoom = FlxTween.tween(FlxG.camera, {zoom: defaultZoom}, 0.1);
	
				if (FreeplaySelectState.curSelectedNightmare == true && allowInstPrev == true)
				{
					if (songs[curSelected].songName == 'bad-time'
						&& curBeat % 2 == 0)
					{
						FlxG.camera.shake(0.015, 0.1);
					}
					if (chromVal == 0)
					{
						chromVal = FlxG.random.float(0.03, 0.10);
						FlxTween.tween(this, {chromVal: 0}, FlxG.random.float(0.05, 0.2), {ease: FlxEase.expoOut}); // added easing to it, dunno if it looks better
					}
				}
				else
				{
					FlxTween.tween(this, {chromVal: 0}, FlxG.random.float(0.05, 0.2), {ease: FlxEase.expoOut});
				}
			}
	}
	function changeDiff(allowShake:Bool = true)
	{
		if (allowShake) {
		FlxG.camera.shake(0.015, 0.4);
		FlxG.sound.play(Paths.sound('cancelMenu'));
		}
		/*curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;*/
		
		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
		positionHighscore();
	}

	public function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
		SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());

			if (allowInstPrev == true) {
				FlxG.sound.music.fadeOut(0.2, 0);
				var switching:FlxTimer;
				switching = new FlxTimer();
				switching.start(0.7, switched);
	}

		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
			
		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		/*if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}*/
		/*var fuck:FlxTimer;
		fuck = new FlxTimer();
		fuck.start(0.5, mf);*/
	}

	private function positionHighscore() {
		scoreText.x = FlxG.width - scoreText.width - 6;

		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}
	private function enableInstPrev(enabling:FlxTimer):Void
		{
			Paths.currentModDirectory = songs[curSelected].folder;
			Conductor.changeBPM(selectedSongBpm);
			Paths.currentModDirectory = songs[curSelected].folder;
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0);
			trace('Current Song Path: ' + Paths.inst(PlayState.SONG.song)
			+", Current Song BPM:" + selectedSongBpm
			+", Current Difficulty Number:" + curDifficulty
			);
			FlxG.sound.music.fadeIn(0.5, 0, 0.7);
		}
		private function disablingInstPrev(disabling:FlxTimer):Void {
		FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
		FlxG.sound.music.fadeIn(1.5, 0, 0.7);
			
		}
		private function switched(switched:FlxTimer):Void {
			Conductor.changeBPM(selectedSongBpm);
			Paths.currentModDirectory = songs[curSelected].folder;
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0);
			trace('Current Song Path: ' + Paths.inst(PlayState.SONG.song)
			+", Current Song BPM:" + selectedSongBpm
			+", Current Difficulty Number:" + curDifficulty
			);
			FlxG.sound.music.fadeIn(0.5, 0, 0.7);
		}
		private function mf(fuck:FlxTimer):Void {
			
		}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";
	public var songFolder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
		this.songFolder = Paths.currentModDirectory + '/songs/' + song;
	}
}
