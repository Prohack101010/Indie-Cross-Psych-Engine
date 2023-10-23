package substates;

import states.StoryMenuState;
import backend.WeekData;
import backend.Highscore;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxSubState;
import objects.HealthIcon;
import states.FreeplayState;

class ResetScoreSubState extends MusicBeatSubstate
{
	var bg:FlxSprite;
	var alphabetArray:Array<Alphabet> = [];
	var icon:HealthIcon;
	var onYes:Bool = false;
	var yesText:Alphabet;
	var noText:Alphabet;

	var song:String;
	var difficulty:Int;
	var week:Int;
	var isAnimated:Bool;
	var character:String;

	override function beatHit(){
	if(week == -1){
		super.beatHit();
		if(FlxG.save.data.instPrev)
			FreeplayState.instance.bopOnBeat();
	}
}
	// Week -1 = Freeplay
	public function new(song:String, difficulty:Int, character:String, week:Int = -1)
	{		
		this.character = character;	
		if(character == 'sansn')
			isAnimated = true;
		else 
			isAnimated = false;
		FlxG.mouse.visible = true;
		if(week == -1)
			cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		this.song = song;
		this.difficulty = difficulty;
		this.week = week;

		super();

		var name:String = song;
		if(week > -1) {
			name = WeekData.weeksLoaded.get(WeekData.weeksList[week]).weekName;
		}
		name += ' (' + Difficulty.getString(difficulty) + ')?';

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var tooLong:Float = (name.length > 18) ? 0.8 : 1; //Fucking Winter Horrorland
		var text:Alphabet = new Alphabet(0, 180, "Reset the score of", true);
		text.screenCenter(X);
		alphabetArray.push(text);
		text.alpha = 0;
		add(text);
		var text:Alphabet = new Alphabet(0, text.y + 90, name, true);
		text.scaleX = tooLong;
		text.screenCenter(X);
		if(week == -1) text.x += 60 * tooLong;
		alphabetArray.push(text);
		text.alpha = 0;
		add(text);
		if(week == -1) {
			icon = new HealthIcon(character, false, isAnimated);
			/*if(character == 'sansn')
				icon.animationOffset = [70, 60, 90, 80];*/
			icon.setGraphicSize(Std.int(icon.width * tooLong));
			icon.updateHitbox();
			icon.setPosition(text.x - icon.width + (10 * tooLong), text.y - 30);
			icon.alpha = 0;
			icon.playNormalAnim(true);
			add(icon);
		}

		yesText = new Alphabet(0, text.y + 150, 'Yes', true);
		yesText.screenCenter(X);
		yesText.x -= 200;
		add(yesText);
		noText = new Alphabet(0, text.y + 150, 'No', true);
		noText.screenCenter(X);
		noText.x += 200;
		add(noText);

		#if mobileC
		addVirtualPad(LEFT_RIGHT, A);
		addPadCamera(false);
		#end

		updateOptions();
	}

	override function update(elapsed:Float)
	{
		
		Conductor.songPosition = FlxG.sound.music.time;
		bg.alpha += elapsed * 1.5;
		if(bg.alpha > 0.6) bg.alpha = 0.6;

		for (i in 0...alphabetArray.length) {
			var spr = alphabetArray[i];
			spr.alpha += elapsed * 2.5;
		}
		if(week == -1) icon.alpha += elapsed * 2.5;

		/*if(controls.UI_LEFT_P || controls.UI_RIGHT_P) {
			FlxG.sound.play(Paths.sound('scrollMenu'), 1);
			onYes = !onYes;
			updateOptions();*/

			if (#if desktop FlxG.mouse.justMoved #else FlxG.mouse.justReleased #end)
				{
					if (!onYes && FlxG.mouse.overlaps(yesText)){
						onYes = true;
						updateOptions();
						FlxG.sound.play(Paths.sound('scrollMenu'), 1);
						}
					
					if (onYes && FlxG.mouse.overlaps(noText)){
						onYes = false;
						updateOptions();
						FlxG.sound.play(Paths.sound('scrollMenu'), 1);
						}

				}
		if(controls.BACK #if android || FlxG.android.justReleased.ANY #end) {
			FlxG.sound.play(Paths.sound('cancelMenu'), 1);
			close();
			FreeplayState.instance.selectedSong = false;
			#if mobileC
			MusicBeatState.instance.virtualPad.visible = true;
			#end
			FlxG.game.filtersEnabled = ClientPrefs.data.shaders;
			FreeplayState.instance.camGame.filtersEnabled = false;
			FreeplayState.instance.scoreCam.filtersEnabled = false;
		
		}
		if (FlxG.mouse.justPressed) {
			if(onYes && FlxG.mouse.overlaps(yesText)) {
				if(week == -1) {
					Highscore.resetSong(song, difficulty);
				} else {
					Highscore.resetWeek(WeekData.weeksList[week], difficulty);
				}
			}
			FlxG.mouse.visible = false;
			FlxG.sound.play(Paths.sound('cancelMenu'), 1);
			close();
			FreeplayState.instance.selectedSong = false;
			#if mobileC
			MusicBeatState.instance.virtualPad.visible = true;
			#end
			FlxG.game.filtersEnabled = ClientPrefs.data.shaders;
			FreeplayState.instance.camGame.filtersEnabled = false;
			FreeplayState.instance.scoreCam.filtersEnabled = false;
		}
		#if mobileC
		if (MusicBeatSubstate.virtualPad == null){ //sometimes it dosent add the vpad, hopefully this fixes it
		addVirtualPad(LEFT_RIGHT, A_B);
		addPadCamera(false);
		
		}
		#end
		super.update(elapsed);
	}

	function updateOptions() {
		var scales:Array<Float> = [0.75, 1];
		var alphas:Array<Float> = [0.6, 1.25];
		var confirmInt:Int = onYes ? 1 : 0;

		yesText.alpha = alphas[confirmInt];
		yesText.scale.set(scales[confirmInt], scales[confirmInt]);
		noText.alpha = alphas[1 - confirmInt];
		noText.scale.set(scales[1 - confirmInt], scales[1 - confirmInt]);
		if(week == -1)
		{
			if(confirmInt == 0)
				icon.playNormalAnim();
			else
				icon.playlossAnim();
		}
	}
}
