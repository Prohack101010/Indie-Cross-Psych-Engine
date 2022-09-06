package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.ui.FlxUIState;

class K extends MusicBeatState
{
		public static var curState:Dynamic = FlxG.state;
		var leState:MusicBeatState = curState;
	public static var disableNextTransIn:Bool = false;
	public static var disableNextTransOut:Bool = false;

	public static var enableTransIn:Bool = true;
	public static var enableTransOut:Bool = true;

	public static var transOutRequested:Bool = false;
	public static var finishedTransOut:Bool = false;

	override function create()
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

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
public static function switchTheFuckingState(balls:FlxState)
  {
    switchState(balls);
  }
	public static function switchState(state:FlxState)
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

	public static function fadeIn()
	{
		leState.openSubState( new CustomFadeTransition(0.5, true, function()
		{
			closeSubState();
		}));
	}

	public static function fadeOut(finishCallback:() -> Void)
	{
		trace("trans out");
		leState.openSubState(new CustomFadeTransition(0.5, false, finishCallback));
	}

/*	public static function subStateRecv(from:FlxState, state:FlxSubState)
	{
		if (from.subState == null)
			from.openSubState(state);
		else
			subStateRecv(from.subState, state);
	}*/
}
