package objects;

import flixel.math.FlxRect;
import flixel.FlxSprite;


class Soul extends FlxSprite
{
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(Paths.image('heart', 'sans'));
	}



	public function isInside(rect:FlxRect):Bool
		{
			var thing = frame.frame;
			thing.x = x;
			thing.y = y;
			if (thing.bottom > rect.bottom || thing.top < rect.top || thing.left < rect.left || thing.right > rect.right)
				return false;
    
			return true;



		}
}
