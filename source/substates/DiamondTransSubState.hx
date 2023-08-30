package substates;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import shaders.DiamondTransShader;

class DiamondTransSubState extends MusicBeatSubstate
{
	var diamondTrans:DiamondTransShader;
	var rect:FlxSprite;
	public var leTween:FlxTween;
	public static var finishCallback:Void->Void;
	var isTransIn:Bool = false;
    var duration:Float;
    public static var nextCamera:FlxCamera;

	public function new(duration:Float, isTransIn:Bool)
	{super();
		camera = new FlxCamera();
		camera.bgColor = FlxColor.TRANSPARENT;

		FlxG.cameras.add(camera, false);
        this.duration = duration;
		this.isTransIn = isTransIn;
	}

	override public function create()
	{
		super.create();
	//	diamondTrans = new DiamondTransShader();


		rect = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		rect.scrollFactor.set();
		rect.shader = new DiamondTransShader();
		rect.shader.data.progress.value = [0.0];
		rect.shader.data.reverse.value = [false];
		rect.alpha = 0.00001;
		rect.cameras = [camera];
		add(rect);

		if (isTransIn) {
        rect.alpha = 1;
		rect.shader.data.progress.value = [0.0];
		rect.shader.data.reverse.value = [true];

		leTween = FlxTween.num(0.0, 1, duration, {
			ease: FlxEase.linear,
			onComplete: function(_)
			{
				trace("finished");
                close();
			}
		}, function(num:Float)
		{
			rect.shader.data.progress.value = [num];
		});
         }else{
            trace("fade initiated");

		rect.alpha = 1;
		rect.shader.data.progress.value = [0.0];
		rect.shader.data.reverse.value = [false];

		leTween = FlxTween.num(0.0, 1, duration, {
			ease: FlxEase.linear,
			onComplete: function(_)
			{
				trace("finished");
				if (finishCallback != null)
				{
					finishCallback();
				}
			}
		}, function(num:Float)
		{
			rect.shader.data.progress.value = [num];
		});
    }
		closeCallback = _closeCallback;

       /* if(nextCamera != null) {
			rect.cameras = [nextCamera];
		}
        nextCamera = null;*/
	}

	function __fade(from:Float, to:Float, reverse:Bool)
	{
		trace("fade initiated");

		rect.alpha = 1;
		rect.shader.data.progress.value = [from];
		rect.shader.data.reverse.value = [reverse];

		leTween = FlxTween.num(from, to, duration, {
			ease: FlxEase.linear,
			onComplete: function(_)
			{
				trace("finished");
				if (finishCallback != null)
				{
					trace("with callback");
					finishCallback();
				}
			}
		}, function(num:Float)
		{
			rect.shader.data.progress.value = [num];
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

	function _closeCallback()
	{
		if (leTween != null)
			leTween.cancel();
	}
    override function destroy() {
		if(leTween != null) {
			//finishCallback();
			leTween.cancel();
		}
		super.destroy();
	}
}