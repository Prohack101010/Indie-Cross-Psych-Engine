package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var fpsVar:FPS;
	public static var toastManager:ToastHandler;
 
	public function new()
	{
		super();

		SUtil.uncaughtErrorHandler();

		SUtil.check();

		ClientPrefs.loadDefaultKeys();

		addChild(new FlxGame(0, 0, TitleState, 1, 60, 60, true, false));

		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		if (fpsVar != null)
			fpsVar.visible = ClientPrefs.showFPS;

		toastManager = new ToastHandler();
		addChild(toastManager); 

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
	}
}
