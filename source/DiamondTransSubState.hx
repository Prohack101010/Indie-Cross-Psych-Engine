package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import DiamondTransShader;

class DiamondTransSubState extends FlxSubState
{
	var shader:DiamondTransShader;
	var rect:FlxSprite;
	public var leTween:FlxTween;
	public static var finishCallback:Void->Void;
	var isTransIn:Bool = false;
    var duration:Float;

	public function new(duration:Float, isTransIn:Bool)
	{
        this.duration = duration;
		super();
		this.isTransIn = isTransIn;
        var zoom:Float = CoolUtil.boundTo(FlxG.camera.zoom, 0.05, 1);
        var width:Int = Std.int(FlxG.width / zoom);
		var height:Int = Std.int(FlxG.height / zoom);

        camera = new FlxCamera();
		camera.bgColor = FlxColor.TRANSPARENT;

		FlxG.cameras.add(camera, false);

		shader = new DiamondTransShader();

		shader.progress.value = [0.0];
		shader.reverse.value = [false];

		rect = new FlxSprite(0, 0).makeGraphic(width, height, 0xFF000000);
		rect.scrollFactor.set();
		rect.shader = shader;
		rect.alpha = 0.00001;
		add(rect);

		if (isTransIn) {
            rect.alpha = 1;
		shader.progress.value = [0.0];
		shader.reverse.value = [true];

		leTween = FlxTween.num(0.0, 1, duration, {
			ease: FlxEase.linear,
			onComplete: function(_)
			{
				trace("finished");
                close();
			}
		}, function(num:Float)
		{
			shader.progress.value = [num];
		});
         }else{
            trace("fade initiated");

		rect.alpha = 1;
		shader.progress.value = [0.0];
		shader.reverse.value = [false];

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
			shader.progress.value = [num];
		});
    }
		closeCallback = _closeCallback;
	}

	override public function create()
	{
		super.create();
	}

	function __fade(from:Float, to:Float, reverse:Bool)
	{
		trace("fade initiated");

		rect.alpha = 1;
		shader.progress.value = [from];
		shader.reverse.value = [reverse];

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