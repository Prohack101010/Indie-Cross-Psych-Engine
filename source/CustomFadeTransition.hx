package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class CustomFadeTransition extends FlxSubState
{
  public static var finishedTrans:Bool = false;
	var shader:DiamondTransShader;
	var rect:FlxSprite;
	var tween:FlxTween;
	public static var nextCamera:FlxCamera;
	public static inline var finishCallback:Void;
	var duration:Float;

	var fi:Bool = true;

	public function new(duration:Float = 1.0, isTransIn:Bool = true, finishCallback:())
	{
		super();

		this.duration = duration;
		this.finishCallback = finishCallback;
		this.fi = isTransIn;
	if(nextCamera != null) {
			this.cameras = [nextCamera];
		}
		nextCamera = null; 
	}

	override public function create()
	{
		super.create();

		camera = new FlxCamera();
		camera.bgColor = FlxColor.TRANSPARENT;

		FlxG.cameras.add(camera, false);

		shader = new DiamondTransShader();

		shader.progress.value = [0.0];
		shader.reverse.value = [false];

		rect = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		rect.scrollFactor.set();
		rect.shader = shader;
		rect.alpha = 0.00001;
		add(rect);

		if (fi)
			fadeIn();
		else
			fadeOut();
	}

	function __fade(from:Float, to:Float, reverse:Bool)
	{
		trace("fade initiated");

		rect.alpha = 1;
		shader.progress.value = [from];
		shader.reverse.value = [reverse];

		tween = FlxTween.num(from, to, duration, {
			ease: FlxEase.linear,
			onComplete: function(_)
			{
			finishedTrans = true;
				trace("finished");
				if (finishCallback != null)
				{
					trace("with callback");
					finishCallback();
				}
			}
		}, function(num:Float)
		{
			shader.progress.value = [num];
		});
	}

	function fadeIn()
	{
		__fade(0.0, 1.0, true);
	}

	function fadeOut()
	{
		__fade(0.0, 1.0, false);
	}

	override function destroy() {
		if(tween != null) {
			finishCallback();
			tween.cancel();
		}
		super.destroy();
	}
}
