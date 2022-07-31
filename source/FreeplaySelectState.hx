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
	public static var curSelectedStory:Bool;
	public static var curSelectedBonus:Bool;
	public static var curSelectedNightmare:Bool;
	var optionShit:Array<String> = [
	'story', 
	'bonus',
	'nightmare'
	];
	var optionItems:FlxTypedGroup<FlxSprite>;
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

		bg = new FlxSprite().loadGraphic('assets/preload/menuBG');
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		for (i in 0...3)
		{
			var item:FlxSprite = new FlxSprite((370 * i) + 180, 0);
			item.loadGraphic(Paths.image('freeplayselect/' + optionShit[i]));
			item.screenCenter(Y);
			item.ID = i;
			optionItems.add(item);
		}

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
				goToState();
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

		if (curSelected >= optionItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = optionItems.length - 1;

		for (item in optionItems.members) {
			item.alpha = 0.47;
			item.color = 0xFF363636;

			if(item.ID == curSelected) {
				item.alpha = 1;
				item.color = 0xFFFFFFFF;
			}
		}
		switch (optionShit[curSelected])
		{
			case 'Story':
curSelectedStory = true;
curSelectedNightmare = false;
curSelectedBonus = false;
			case 'bonus':
curSelectedBonus = true;
curSelectedStory = false;
curSelectedNightmare = false;
			case 'nightmare':
curSelectedNightmare = true;
curSelectedStory = false;
curSelectedBonus = false;
		}
	}
}
