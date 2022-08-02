package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;

using StringTools;

class FreeplaySelectState extends MusicBeatState
{

	public static var curSelected:Int = 0;
	public static var curSelected:Int = 0;
	public static var curSelectedStory:Bool;
	public static var curSelectedBonus:Bool;
	public static var curSelectedNightmare:Bool;
	var optionShit:Array<String> = ['story', 'bonus', 'nightmare'];
	var menuItems:FlxTypedGroup<FlxSprite>;
	var story:FlxSprite;
	var bonus:FlxSprite;
	var nightmare:FlxSprite;
	var bg:FlxSprite;	

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		story = new FlxSprite(-100, -400).loadGraphic(Paths.image('freeplaySelect/story'));
		menuItems.add(story);
		story.scrollFactor.set();
		story.antialiasing = ClientPrefs.globalAntialiasing;
		story.setGraphicSize(Std.int(story.width * 0.7));


		bonus = new FlxSprite(-100, -400).loadGraphic(Paths.image('freeplaySelect/bonus'));
		menuItems.add(bonus);
		bonus.scrollFactor.set();
		bonus.antialiasing = ClientPrefs.globalAntialiasing;
		bonus.setGraphicSize(Std.int(bonus.width * 0.7));

		nightmare = new FlxSprite(-100, -400).loadGraphic(Paths.image('freeplaySelect/nightmare'));
		menuItems.add(nightmare);
		nightmare.scrollFactor.set();
		nightmare.antialiasing = ClientPrefs.globalAntialiasing;
		nightmare.setGraphicSize(Std.int(nightmare.width * 0.7));
		changeItem();

		#if android
		addVirtualPad(LEFT_RIGHT, A_B);
		#end

		super.create();
	}
	
	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));
				
				if (curSelected == 0)
				{
					//FlxTween.tween(storySplash, {alpha: 1}, 0.1, {ease: FlxEase.linear, onComplete: function(twn:FlxTween) { FlxTween.tween(Story_modeSplash, {alpha: 0}, 0.4, {ease: FlxEase.linear, onComplete: function(twn:FlxTween) { goToState(); }}); }});
				}
				else if (curSelected == 1)
				{
					//FlxTween.tween(bonusSplash, {alpha: 1}, 0.1, {ease: FlxEase.linear, onComplete: function(twn:FlxTween) { FlxTween.tween(freeplaySplash, {alpha: 0}, 0.4, {ease: FlxEase.linear, onComplete: function(twn:FlxTween) { goToState(); }}); }});
				} 
				else if (curSelected == 2) 
				{
					//FlxTween.tween(nightmareSplash, {alpha: 1}, 0.1, {ease: FlxEase.linear, onComplete: function(twn:FlxTween) { FlxTween.tween(optionsSplash, {alpha: 0}, 0.4, {ease: FlxEase.linear, onComplete: function(twn:FlxTween) { goToState(); }}); }});
				}
				}
			}

		super.update(elapsed);
	}

	public function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
		    case 'story':
				MusicBeatState.switchState(new FreeplayState());
			case 'bonus':
				MusicBeatState.switchState(new FreeplayState());
			case 'nightmare':
				MusicBeatState.switchState(new FreeplayState());
	}
}
	public function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;	

		switch (optionShit[curSelected])
		{
			case 'story':
			  story.alpha = 1;
				bonus.alpha = 0.6; 
				nightmare.alpha = 0.6;
curSelectedStory = true;
curSelectedNightmare = false;
curSelectedBonus = false;
			case 'bonus':
				bonus.alpha = 1;
				story.alpha = 0.6;
				nightmare.alpha = 0.6;
curSelectedStory = false;
curSelectedNightmare = true;
curSelectedBonus = false;
			case 'nightmare':
				bonus.alpha = 0.6;
				story.alpha = 0.6;
				nightmare.alpha = 1;
curSelectedStory = false;
curSelectedNightmare = false;
curSelectedBonus = true;
		}
	}
}