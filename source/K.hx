package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.ui.FlxUIState;

class K extends FlxUIState
{
	public static var disableNextTransIn:Bool = false;
	public static var disableNextTransOut:Bool = false;

	public var enableTransIn:Bool = true;
	public var enableTransOut:Bool = true;

	var transOutRequested:Bool = false;
	var finishedTransOut:Bool = false;

	function create()
	{
		super.create();

		if (disableNextTransIn)
		{
			enableTransIn = false;
			disableNextTransIn = false;
		}

		if (disableNextTransOut)
		{
			enableTransOut = false;
			disableNextTransOut = false;
		}

		if (enableTransIn)
		{
			trace("transIn");
			fadeIn();
		}
	}

	function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	override public function switchTo(state:FlxState)
	{
		if (!finishedTransOut && !transOutRequested)
		{
			if (enableTransOut)
			{
				fadeOut(function()
				{
					finishedTransOut = true;
					FlxG.switchState(state);
				});

				transOutRequested = true;
			}
			else
				return true;
		}

		return finishedTransOut;
	}

	function fadeIn()
	{
		subStateRecv(this, new CustomFadeTransition(0.5, true, function()
		{
			closeSubState();
		}));
	}

	function fadeOut(finishCallback:() -> Void)
	{
		trace("trans out");
		subStateRecv(this, new CustomFadeTransition(0.5, false, finishCallback));
	}

	function subStateRecv(from:FlxState, state:FlxSubState)
	{
		if (from.subState == null)
			from.openSubState(state);
		else
			subStateRecv(from.subState, state);
	}
}
