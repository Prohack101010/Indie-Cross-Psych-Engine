import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;

using StringTools;

class Achievements {
	public static var achievementsStuff:Array<Dynamic> = [ //Name, Description, Achievement save tag, Hidden achievement
		["Freaky on a Friday Night",	"Play on a Friday... Night.",						'friday_night_play',	 true], //1
		["The Legendary Chalinger",		"Beat Cuphead Week with no Misses.",				'cuphead_nomiss',			false], //2
		["Determination",				"Beat Sans Week With No Misses.",				'sans_nomiss',			false], //3
		["PACIFIST.",					"Choose Peace.",					'pacifist',			false], //4
		["GENOCIDE.",					"Burtly Attack Sans.",				'genocide',			false], 
		["Bring Back Home The Bacon.",			"Beat Bendy Week with no Misses.",				'bendy_nomiss',			false], //5
		["Ultimate KnockOut.",				"Defeat Nightmare cuphead.",			'nmCup',			false], //6
		["Bad Time",					"Defeat Nightmare Sans.",			'nmSans',			false], //7
		["Inking Mistake.",				"Defeat Nightmare Bendy.",			'nmBendy',			false], //8
		["Unworthy",					"Hit 50 Blue Bone Note.",	'help',				 false] //9
	];
		public static var achievementsMap:Map<String, Bool> = new Map<String, Bool>();

	public static var henchmenDeath:Int = 0;
	public static function unlockAchievement(name:String):Void {
		FlxG.log.add('Completed achievement "' + name +'"');
		achievementsMap.set(name, true);
		FlxG.sound.play(Paths.sound('achievement'), 1);
	}

	public static function isAchievementUnlocked(name:String) {
		if(achievementsMap.exists(name) && achievementsMap.get(name)) {
			return true;
		}
		return false;
	}

	public static function getAchievementIndex(name:String) {
		for (i in 0...achievementsStuff.length) {
			if(achievementsStuff[i][2] == name) {
				return i;
			}
		}
		return -1;
	}

	public static function loadAchievements():Void {
		if(FlxG.save.data != null) {
			if(FlxG.save.data.achievementsMap != null) {
				achievementsMap = FlxG.save.data.achievementsMap;
			}
			if(henchmenDeath == 0 && FlxG.save.data.henchmenDeath != null) {
				henchmenDeath = FlxG.save.data.henchmenDeath;
			}
		}
	}

	public static function giveAchievement(achieve:String, achievementEnd:Void->Void = null):Void {
		var achieveID:Int = Achievements.getAchievementIndex(achieve);
		Main.toastManager.createToast(Paths.achievementImage('achievements/' + achieve), Achievements.achievementsStuff[achieveID][0], Achievements.achievementsStuff[achieveID][1], true);
		if (achievementEnd != null)
			Main.toastManager.onFinish = achievementEnd;

		trace('Giving achievement ' + achieve);

		ClientPrefs.saveSettings();
	}
}

class AttachedAchievement extends FlxSprite {
	public var sprTracker:FlxSprite;
	private var tag:String;
	public function new(x:Float = 0, y:Float = 0, name:String) {
		super(x, y);

		changeAchievement(name);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function changeAchievement(tag:String) {
		this.tag = tag;
		reloadAchievementImage();
	}

	public function reloadAchievementImage() {
		if(Achievements.isAchievementUnlocked(tag)) {
			loadGraphic(Paths.image('achievements/' + tag));
		} else {
			loadGraphic(Paths.image('achievements/lockedachievement'));
		}
		scale.set(0.7, 0.7);
		updateHitbox();
	}

	override function update(elapsed:Float) {
		if (sprTracker != null)
			setPosition(sprTracker.x - 130, sprTracker.y + 25);

		super.update(elapsed);
	}
}
