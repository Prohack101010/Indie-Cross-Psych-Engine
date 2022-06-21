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
import Achievements;
import editors.MasterEditorMenu;
import flixel.FlxCamera;

using StringTools;

class FreeplaySelectState extends MusicBeatState
{
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	public static var psychEngineVersion:String = '0.5.2h';
	public static var curSelected:Int = 0;

	var optionShit:Array<String> = ['story_songs', 'bonus_songs', 'nightmare_songs'];
	var menuItems:FlxTypedGroup<FlxSprite>;
	var story_songs:FlxSprite;
	var bonus_songs:FlxSprite;
	var nightmare_songs:FlxSprite;
	var bg:FlxSprite;	

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		story_songs = new FlxSprite(-100, -400).loadGraphic(Paths.image('mainmenu/freeplay/story_songs'));
		menuItems.add(story_songs);
		story_songs.scrollFactor.set();
		story_songs.antialiasing = ClientPrefs.globalAntialiasing;
		story_songs.setGraphicSize(Std.int(story_songs.width * 0.7));
		story_songs.y += 220;		
		story_songs.x -= 200;
		story_songs.alpha = 0.60;


		bonus_songs = new FlxSprite(-100, -400).loadGraphic(Paths.image('mainmenu/freeplay/bonus_songs'));
		menuItems.add(bonus_songs);
		bonus_songs.scrollFactor.set();
		bonus_songs.antialiasing = ClientPrefs.globalAntialiasing;
		bonus_songs.setGraphicSize(Std.int(bonus_songs.width * 0.7));
		bonus_songs.y += 200;		
		bonus_songs.x -= 200;
		bonus_songs.alpha = 0.60;

		nightmare_songs = new FlxSprite(-100, -400).loadGraphic(Paths.image('mainmenu/freeplay/nightmare_songs'));
		menuItems.add(nightmare_songs);
		nightmare_songs.scrollFactor.set();
		nightmare_songs.antialiasing = ClientPrefs.globalAntialiasing;
		nightmare_songs.setGraphicSize(Std.int(nightmare_songs.width * 0.7));
		nightmare_songs.y += 220;
		nightmare_songs.x -= 200;
		nightmare_songs.alpha = 0.60;

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var IndieLogo:FlxSprite = new FlxSprite(-310, -170).loadGraphic(Paths.image('mainmenu/LOGO'));
		IndieLogo.updateHitbox();
		IndieLogo.setGraphicSize(Std.int(IndieLogo.width * 0.7));
		IndieLogo.antialiasing = ClientPrefs.globalAntialiasing;
		add(IndieLogo);

		// NG.core.calls.event.logEvent('swag').send();

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
				MusicBeatState.switchState(new MainMenuState());
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));
				

		}
	}

		super.update(elapsed);

	}

	public function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
		case 'story_songs':
		MusicBeatState.switchState(new FreeplayState());
		case 'bonus_songs':
		MusicBeatState.switchState(new FreeplayBonusState());
		case 'nightmare_songs':
		MusicBeatState.switchState(new FreeplayNightmareState());
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
			case 'story_songs':
			story_songs.alpha = 1;
			bonus_songs.alpha = 0.6; 
			nightmare_songs.alpha = 0.6; 

			case 'bonus_songs':
			bonus_songs.alpha = 1; 
			story_songs.alpha = 0.6;
			nightmare_songs.alpha = 0.6; 				
			case 'nightmare_songs':
			nightmare_songs.alpha = 1; 
			bonus_songs.alpha = 0.6;
			story_songs.alpha = 0.6;
		}						
	}
}
