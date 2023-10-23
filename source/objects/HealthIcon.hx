package objects;
import haxe.Json;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
typedef IconData =
{
	var animations:Array<AnimationsData>;
}

typedef AnimationsData =
{
	var name:String;
	var prefix:String;
	var fps:Int;
	var loop:Bool;
	var indices:Array<Int>;
	var offsets:Array<Float>;
	var islossAnim:Bool;
}
class HealthIcon extends FlxSprite
{
	private var json:IconData;
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';
	private var animated:Bool;
	private var animationOffset:Array<Array<Float>> = [[0, 0], [0, 0]];
	private var lossAnim:String = 'loos';
	private var normalAnim:String = 'normal';

	public function new(char:String = 'bf', isPlayer:Bool = false, ?animated:Bool = false, ?allowGPU:Bool = true)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		this.animated = animated;
		changeIcon(char, animated, allowGPU);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);
		if(animated){
			//updateHitbox();
			/*if (animation.curAnim.name == normalAnim)
				offset.set(animationOffset[1][0], animationOffset[1][1]);
			else if(animation.curAnim.name == lossAnim)
				offset.set(animationOffset[0][0], animationOffset[0][1]);
		*/
		}
	}

	public var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String, ?animated:Bool = false, ?allowGPU:Bool = true) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			if(Paths.fileExists('images/' + name +'.json', TEXT)){
				var jsonPath = #if MODS_ALLOWED SUtil.getPath() + #end Paths.getPath('images/' + name + '.json', TEXT, 'shared');
				var formatted:Array<String> = jsonPath.split(':'); // prevent "shared:", "preload:" and other library names on file path
				jsonPath = formatted[formatted.length - 1];
				#if MODS_ALLOWED
				var rawJson = File.getContent(jsonPath);
				#else
				var rawJson = Assets.getText(formatted);
				#end
				json = cast Json.parse(rawJson);
				trace('icon json was found!!\n' + jsonPath);
			}
			if(animated == false){
				var graphic = Paths.image(name, allowGPU);
				loadGraphic(graphic, true, Math.floor(graphic.width / 2), Math.floor(graphic.height));
				
				animation.add(char, [0, 1], 0, false, isPlayer);
				animation.play(char);
				this.char = char;
				iconOffsets[0] = (width - 150) / 2;
				iconOffsets[1] = (height - 150) / 2;
			} else if(animated){
				frames = Paths.getSparrowAtlas(name);
				var animationsArray = json.animations;
				if (animationsArray != null && animationsArray.length > 0)
					{
					for (anim in animationsArray)
						{
						var animName:String = '' + anim.name;
						var animPrefix:String = '' + anim.prefix;
						var animFps:Int = anim.fps;
						var animLoop:Bool = !!anim.loop; // Bruh
						var animIndices:Array<Int> = anim.indices;
						if(anim.islossAnim == true){
							lossAnim = animName;
							if(anim.offsets != null || anim.offsets != [])
								animationOffset[1] = anim.offsets;
						} else if(anim.islossAnim == false) { 
							normalAnim = animName;
							if(anim.offsets != null || anim.offsets != [])
								animationOffset[0] = anim.offsets;
						}
						if (animIndices != null && animIndices.length > 0)
							{
								animation.addByIndices(animName, animPrefix, animIndices, "", animFps, animLoop, isPlayer);
						} else {
								animation.addByPrefix(animName, animPrefix, animFps, animLoop, isPlayer);
						}
					}
				}
				animation.play(normalAnim, true);
				iconOffsets[0] = (width - 150) / 2 + animationOffset[1][0];
				iconOffsets[1] = (height - 150) / 2 + animationOffset[1][1];		
			}
			updateHitbox();
			if((char.endsWith('-pixel')))
				antialiasing = false;
			else
				antialiasing = ClientPrefs.data.antialiasing;
		}
	}

	override function updateHitbox()
	{
		if(!animated)
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String {
		return char;
	}

	public function isAnimated():Bool {
		return animated;
	}

	public function playlossAnim(?force:Bool = false){
		if(!animated)
			animation.curAnim.curFrame = 1;
		else if(animated){
			if(animation.curAnim.name != lossAnim || force){
			animation.play(lossAnim, true);
			iconOffsets[0] = (width - 150) / 2 + animationOffset[1][0];
			iconOffsets[1] = (height - 150) / 2 + animationOffset[1][1];
			updateHitbox();
			}
		}
	}

	public function playNormalAnim(?force:Bool = false){
		if(!animated)
			animation.curAnim.curFrame = 0;
		else if(animated){
			if(animation.curAnim.name != normalAnim || force){
			animation.play(normalAnim, true);
			iconOffsets[0] = (width - 150) / 2 + animationOffset[0][0];
			iconOffsets[1] = (height - 150) / 2 + animationOffset[0][1];
			offset.x = iconOffsets[0];
			offset.y = iconOffsets[1];
			}
		}
	}
}
