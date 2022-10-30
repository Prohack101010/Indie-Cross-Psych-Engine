package;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
#if desktop
import Discord.DiscordClient;
#end
#if desktop
import sys.io.File;
import sys.FileSystem;
#end
import flixel.FlxObject;
import openfl.utils.Object;
import WhiteOverlayShader;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Lib;
import flixel.system.debug.Window;
import flixel.addons.transition.FlxTransitionableState;
import Achievements;
import editors.MasterEditorMenu;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public function new()
		{
			super();
		}
	public static var psychEngineVersion:String = 'INDIE CROSS V1';
	public static var curSelected:Int = 0;
	var buttonsFlash:FlxSprite = new FlxSprite();
	var optionShit:Array<String> = ['storymode', 'freeplay', 'options', 'credits', 'achievements'];
	var menuString:FlxTypedGroup<FlxSprite>;
	var motherfucker:Array<FlxTween>;
	var menuSketch:FlxSprite;
	var bg:FlxSprite;
	static final pussy:Float = 50;
	public static final fuckersScale:Float = 0.675;
	static final fuckersTweenShitcifbidbfgis:TweenOptions = {ease: FlxEase.circOut};
	static var imagesToCache:Array<String> = ['mainmenu/ButtonsFlash/'];


	override function create()
	{
		for (image in optionShit)
			{
				trace("Caching image " + image);
				FlxG.bitmap.add(Paths.image('mainmenu/ButtonsFlash/' + image));
			}
		#if allow_discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var IndieLogo:FlxSprite = new FlxSprite(-310, -170).loadGraphic(Paths.image('mainmenu/LOGO'));
		IndieLogo.updateHitbox();
		IndieLogo.setGraphicSize(Std.int(IndieLogo.width * 0.7));
		IndieLogo.antialiasing = ClientPrefs.globalAntialiasing;
		add(IndieLogo);

		var sketch:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('mainmenu/sketch/sketch'));
		sketch.frames = Paths.getSparrowAtlas('mainmenu/sketch/sketch');
		sketch.animation.addByPrefix('bump', 'menu bru', 3); 
		sketch.animation.play('bump');
		sketch.setGraphicSize(Std.int(sketch.width * 0.7));
		sketch.x -= 300;
		sketch.y -= 200;
		add(sketch);

		menuString = new FlxTypedGroup<FlxSprite>();
		add(menuString);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font("Bronx.otf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Psych Engine v0.5.2h", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font("Bronx.otf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		addBitches(270, 100);
		changeItem(curSelected);
		// NG.core.calls.event.logEvent('swag').send();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				Achievements.giveAchievement('friday_night_play');
			}
		}
		#end

		#if mobile
		addVirtualPad(UP_DOWN, A_B_E);
		#end

		super.create();
	}
	
	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		var selectedButton:FlxSprite = menuString.members[curSelected];
		if (optionShit[curSelected] != "achievements") {buttonsFlash.x = selectedButton.x -113; buttonsFlash.y = selectedButton.y -25;} else {buttonsFlash.x = selectedButton.x -143; buttonsFlash.y = selectedButton.y -15;}
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin && !selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(curSelected-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(curSelected+1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
			enterBitches();								
			}
			else if (FlxG.keys.justPressed.SEVEN #if android || virtualPad.buttonE.justPressed #end)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
		}

		super.update(elapsed);

	}

	public function changeItem(selection:Int = 0)
	{
		if (selection != curSelected)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
	
			if (selection < 0)
				selection = optionShit.length - 1;
			if (selection >= optionShit.length)
				selection = 0;
	
			for (i in 0...optionShit.length)
			{
				var str:String = optionShit[i];
				var menuItem:FlxSprite = menuString.members[i];
				if (i == selection)
				{
					menuItem.alpha = 1.0;
					if (motherfucker[i] != null)
					{
						motherfucker[i].cancelChain();
						motherfucker[i].destroy();
						motherfucker[i] = null;
					}
					if (str == "achievements") {
						motherfucker[i] = FlxTween.tween(menuItem, {x: 1280 - menuItem.width}, 0.2, fuckersTweenShitcifbidbfgis);
					} else {
						motherfucker[i] = FlxTween.tween(menuItem, {x: 0}, 0.2, fuckersTweenShitcifbidbfgis);
					}
				}
				else
				{
					if (menuItem.alpha == 1.0)
					{
						if (motherfucker[i] != null)
						{
							motherfucker[i].cancelChain();
							motherfucker[i].destroy();
							motherfucker[i] = null;
						}
					}
	
					if (str == "achievements") {
						motherfucker[i] = FlxTween.tween(menuItem, {x: 1280 - menuItem.width + pussy}, 0.35, fuckersTweenShitcifbidbfgis);
					} else {
						motherfucker[i] = FlxTween.tween(menuItem, {x: -pussy}, 0.35, fuckersTweenShitcifbidbfgis);
				}
					menuItem.alpha = 0.5;
				}
			}
	
			curSelected = selection;
	}
	function addBitches(yPos:Float, sep:Float)
		{
			if (menuString == null)
				return;
	
			if (menuString.members != null && menuString.members.length > 0)
				menuString.forEach(function(_:FlxSprite)
				{
					menuString.remove(_);
					_.destroy();
				});
		
	
			motherfucker = new Array<FlxTween>();
	
			for (i in 0...optionShit.length)
			{
				motherfucker.push(null);
	
				var str:String = optionShit[i];
	
				var menuItem:FlxSprite = new FlxSprite();
				if(str != null && str.length > 0)
					{
				trace('added the button ' + str);
				menuItem.loadGraphic(Paths.image("mainmenu/Buttons/" + str));
					}
				menuItem.origin.set();
				menuItem.scale.set(fuckersScale, fuckersScale);
				menuItem.updateHitbox();
				menuItem.alpha = 0.5;

				//buttonsFlash.loadGraphic(Paths.image('mainmenu/ButtonsFlash/storymode'));
				buttonsFlash.origin.set();
				buttonsFlash.scale.set(fuckersScale, fuckersScale);
				buttonsFlash.updateHitbox();
				buttonsFlash.alpha = 0;

				//menuItem.shader = new WhiteOverlayShader();
	
				if (str == "achievements")
				{
					menuItem.setPosition(1280 - menuItem.width + pussy, 630);
				} else {
					menuItem.setPosition(-pussy, yPos + (i * sep));
				}
	
				menuString.add(menuItem);
				add(buttonsFlash);
			}
		}
		function enterBitches()
			{
				selectedSomethin = true;
		
				var str:String = optionShit[curSelected];
				var menuItem:FlxSprite = menuString.members[curSelected];
		
				if (motherfucker[curSelected] != null)
					motherfucker[curSelected].cancel();
				if (str == "achievements")
				{
					menuItem.x = 1280 - menuItem.width + pussy;
					motherfucker[curSelected] = FlxTween.tween(menuItem, {x: 1280 - menuItem.width}, 0.4, fuckersTweenShitcifbidbfgis);
				}
				else
				{
					menuItem.x = -pussy;
					motherfucker[curSelected] = FlxTween.tween(menuItem, {x: 0}, 0.4, fuckersTweenShitcifbidbfgis);
				}
		
				//menuItem.shader.data.progress.value = [1.0];
				buttonsFlash.loadGraphic(Paths.image("mainmenu/ButtonsFlash/" + str));
				FlxTween.num(1.0, 0.0, 1.0, {ease: FlxEase.cubeOut}, function(num:Float)
				{
					buttonsFlash.alpha = num;
					//menuItem.shader.data.progress.value = [num];
				});
		
				for (i in 0...menuString.members.length)
				{
					if (i != curSelected)
					{
						FlxTween.tween(menuString.members[i], {alpha: 0}, 1, {ease: FlxEase.cubeOut});
					}
					if (i == curSelected) {
						menuString.members[i].color = 0xffffff;
						FlxTween.color(menuString.members[i], 1, FlxColor.WHITE, FlxColor.TRANSPARENT,{ease: FlxEase.cubeOut});	
					}
				}
		
				if (str == 'options')
					{
						if (FlxG.sound.music != null)
						{
							FlxG.sound.music.fadeOut(1, 0);
						}
					}
				FlxG.sound.play(Paths.sound('confirmMenu'));
		
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					switch (str)
					{
						case "storymode":
							MusicBeatState.switchState(new StoryMenuState());
						case "freeplay":
							MusicBeatState.switchState(new FreeplaySelectState());
						case "options":
							LoadingState.loadAndSwitchState(new options.OptionsState());
							FlxG.sound.playMusic(Paths.music('settin'), 1, true);
							FlxG.sound.music.fadeIn(2, 0, 1);
						case "credits":
							MusicBeatState.switchState(new CreditsState());
						case "achievements":
							MusicBeatState.switchState(new AchievementsMenuState());
					}
				});
			}
}
