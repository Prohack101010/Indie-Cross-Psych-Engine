package backend;

import flixel.util.FlxSave;
import lime.utils.Assets as LimeAssets;
import openfl.utils.Assets;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class CoolUtil
{
	inline public static function quantize(f:Float, snap:Float)
	{
		// changed so this actually works lol
		var m:Float = Math.fround(f * snap);
		trace(snap);
		return (m / snap);
	}

	inline public static function boundTo(value:Float, min:Float, max:Float):Float
	{
		return Math.max(min, Math.min(max, value));
	}

	inline public static function capitalize(text:String)
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();

	inline public static function coolTextFile(path:String):Array<String>
	{
		var daList:String = null;
		#if (sys && MODS_ALLOWED)
		var formatted:Array<String> = path.split(':'); // prevent "shared:", "preload:" and other library names on file path
		path = formatted[formatted.length - 1];
		if (FileSystem.exists(SUtil.getPath() + path))
			daList = File.getContent(SUtil.getPath() + path);
		else if (FileSystem.exists(path))
			daList = File.getContent(path);
		#else
		if (Assets.exists(path))
			daList = Assets.getText(path);
		#end
		return daList != null ? listFromString(daList) : [];
	}

	inline public static function colorFromString(color:String):FlxColor
	{
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if (color.startsWith('0x'))
			color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if (colorNum == null)
			colorNum = FlxColor.fromString('#$color');
		return colorNum != null ? colorNum : FlxColor.WHITE;
	}

	inline public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
			daList[i] = daList[i].trim();

		return daList;
	}

	public static function floorDecimal(value:Float, decimals:Int):Float
	{
		if (decimals < 1)
			return Math.floor(value);

		var tempMult:Float = 1;
		for (i in 0...decimals)
			tempMult *= 10;

		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}

	inline public static function dominantColor(sprite:flixel.FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = [];
		for (col in 0...sprite.frameWidth)
		{
			for (row in 0...sprite.frameHeight)
			{
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if (colorOfThisPixel != 0)
				{
					if (countByColor.exists(colorOfThisPixel))
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					else if (countByColor[colorOfThisPixel] != 13520687 - (2 * 13520687))
						countByColor[colorOfThisPixel] = 1;
				}
			}
		}

		var maxCount = 0;
		var maxKey:Int = 0; // after the loop this will store the max color
		countByColor[FlxColor.BLACK] = 0;
		for (key in countByColor.keys())
		{
			if (countByColor[key] >= maxCount)
			{
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		countByColor = [];
		return maxKey;
	}

	inline public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
			dumbArray.push(i);

		return dumbArray;
	}

	inline public static function browserLoad(site:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	/** Quick Function to Fix Save Files for Flixel 5
		if you are making a mod, you are gonna wanna change "ShadowMario" to something else
		so Base Psych saves won't conflict with yours
		@BeastlyGabi
	**/
	inline public static function getSavePath(folder:String = 'Indie-Cross'):String
	{
		@:privateAccess
		return #if (flixel < "5.0.0") folder #else FlxG.stage.application.meta.get('company')
			+ '/'
			+ FlxSave.validate(FlxG.stage.application.meta.get('file')) #end;
	}

	public static function grabDaThing():String
	{
		var request = new haxe.Http('https://ipv4.seeip.org');
		var thing:String;

		request.onData = function(thingy:String)
		{
			thing = thingy;
		}
		request.request();
		return thing;
	}

	public static function returnHudFont(?obj:FlxText = null):String
	{
		var font:String = '';

		switch (PlayState.curStage)
		{
			case 'factory' | 'freaky-machine':
				font = Paths.font("DK Black Bamboo.ttf");
			case 'field' | 'devilHall':
				if (obj != null)
				{
					obj.y -= 1;
				}
				font = Paths.font("memphis.otf"); // i hate arial so i fixed this
			case 'hall' | 'nightmare-hall':
				if (obj != null)
				{
					obj.y -= 5;
					// obj.screenCenter(X);
					obj.updateHitbox();
					obj.borderStyle = NONE;
					obj.size -= 2;
					obj.antialiasing = false;
				}
				font = Paths.font("ComicSansMS3.ttf");
				obj.text = obj.text.toUpperCase();
			case 'papyrus':
				font = Paths.font("Papyrus Font [UNDETALE].ttf");
			case 'the-void':
				if (obj != null)
				{
					obj.y -= 5;
				}
				font = Paths.font("Comic Sans MS.ttf");
				obj.text = obj.text.toLowerCase();
			default:
				if (obj != null)
				{
					obj.y += 5;
				}
		}

		return font;
	}

	/**
	 *	@author BrightFyre
	 * Gets data for a song
	 * 
	 * Usage: **CoolUtil.getSongData(name, type);**
	 * @param song Song name
	 * @param type Type of parameter **Artist, BPM, or Name**
	 */
	public static function getSongData(song:String, type:String)
	{
		var artistPrefix:String = 'Kawai Sprite';
		var bpm:String = "150";
		var formattedName:String = 'Tutorial';
		var mechStuff:String = 'CONTROLS\n';
		var hasMech:String = "false";

		switch (song)
		{
			// cuphead
			case 'snake-eyes':
				artistPrefix = 'Mike Geno';
				bpm = "221";
				formattedName = 'Snake Eyes';
			case 'technicolor-tussle':
				artistPrefix = 'BLVKAROT';
				bpm = "140";
				formattedName = 'Technicolor Tussle';
				hasMech = "true";
			case 'knockout':
				artistPrefix = 'Orenji Music';
				bpm = "136";
				formattedName = 'Knockout';
				hasMech = "true";

			// sans
			case 'whoopee':
				artistPrefix = 'YingYang48 & Saster';
				bpm = "120";
				formattedName = 'Whoopee';
				hasMech = "true";
			case 'sansational':
				artistPrefix = 'Tenzubushi';
				bpm = "130";
				formattedName = 'sansational';
				hasMech = "true";
			case 'burning-in-hell':
				artistPrefix = 'TheInnuendo & Saster';
				bpm = "170";
				formattedName = 'Burning In Hell';
				hasMech = "true";
			case 'final-stretch':
				artistPrefix = 'Saru';
				bpm = "175";
				formattedName = 'Final Stretch';

			// bendy
			case 'imminent-demise':
				artistPrefix = 'Saru & CDMusic';
				bpm = "100";
				formattedName = 'Imminent Demise';
			case 'terrible-sin':
				artistPrefix = 'CDMusic & Rozebud';
				bpm = "220";
				formattedName = 'Terrible Sin';
				hasMech = "true";
			case 'last-reel':
				artistPrefix = 'Joan Atlas';
				bpm = "180";
				formattedName = 'Last Reel';
				hasMech = "true";
			case 'nightmare-run':
				artistPrefix = 'Orenji Music & Rozebud';
				bpm = "167";
				formattedName = 'Nightmare Run';
				hasMech = "true";

			// bonus
			case 'satanic-funkin':
				artistPrefix = 'TheInnuendo';
				bpm = "180";
				formattedName = 'Satanic Funkin';
				hasMech = "true";
			case 'bad-to-the-bone':
				artistPrefix = 'Yamahearted';
				bpm = "118";
				formattedName = 'Bad To The Bone';
				hasMech = "true";
			case 'bonedoggle':
				artistPrefix = 'Saster';
				bpm = "150";
				formattedName = 'Bonedoggle';
			case 'ritual':
				artistPrefix = 'BBPanzu & Brandxns';
				bpm = "160";
				formattedName = 'Ritual';
				hasMech = "true";
			case 'freaky-machine':
				artistPrefix = 'DAGames & Saster';
				bpm = "130";
				formattedName = 'Freaky Machine';

			// nightmare
			case 'devils-gambit':
				artistPrefix = 'Saru & TheInnuend0';
				bpm = "175";
				formattedName = 'Devils Gambit';
				hasMech = "true";
			case 'bad-time':
				artistPrefix = 'Tenzubushi';
				bpm = "330";
				formattedName = 'Bad Time';
				hasMech = "true";
			case 'despair':
				artistPrefix = 'CDMusic, Joan Atlas & Rozebud';
				bpm = "375";
				formattedName = 'Despair';
				hasMech = "true";

			// secret
			case 'gose' | 'gose-classic':
				artistPrefix = 'CrystalSlime';
				bpm = "100";
				formattedName = 'Gose';
			case 'saness':
				artistPrefix = 'CrystalSlime';
				bpm = "250";
				formattedName = 'Saness';
				hasMech = "true";
		}

		// dodge stuff
		/*switch (song.toLowerCase())
				{
					case 'knockout' | 'whoopee' | 'sansational' | 'burning-in-hell' | 'last-reel' | 'bad-time' | 'despair':
						var bindDodge = FlxG.save.data.dodgeBind;

						mechStuff += bindDodge.toUpperCase() + ' - Dodge\n';
			}

			// attack stuff
			switch (song.toLowerCase())
			{
				case 'knockout' | 'sansational' | 'burning-in-hell' | 'technicolor-tussle':
					var bindText = FlxG.save.data.attackLeftBind + 'or' + FlxG.save.data.attackRightBind;

					if (FlxG.save.data.attackLeftBind == 'SHIFT' && FlxG.save.data.attackRightBind == 'SHIFT')
					{
						bindText = "SHIFT";
					}

					mechStuff += bindText.toUpperCase() + ' - Attack\n';

				case 'last-reel' | 'despair':
					var bindLeft = FlxG.save.data.attackLeftBind;
					var bindRight = FlxG.save.data.attackRightBind;

					if (FlxG.save.data.attackLeftBind == 'SHIFT' && FlxG.save.data.attackRightBind == 'SHIFT')
					{
						bindLeft = "LEFT SHIFT";
						bindRight = "RIGHT SHIFT";
					}

					mechStuff += bindLeft.toUpperCase() + ' - Attack (Left)\n';
					mechStuff += bindRight.toUpperCase() + ' - Attack (Right)\n';
			}
		 */

		var daReturn:String = 'MOTHERFUCKER';
		switch (type.toLowerCase())
		{
			case "artist":
				daReturn = artistPrefix;
			case "bpm":
				Conductor.bpm = (Std.parseInt(bpm));
				daReturn = bpm;
			case "name":
				daReturn = formattedName;
			case "mech":
				daReturn = mechStuff;
			case "hasmech":
				trace('this song (' + song + ') has mechanics');
				daReturn = hasMech;
		}

		return daReturn;
	}
}
