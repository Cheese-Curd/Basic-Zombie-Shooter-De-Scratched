package;

import flixel.FlxG;
import flixel.FlxSprite;

class ClampedSprite extends FlxSprite
{
	override function update(elapsed:Float) {
		super.update(elapsed);

		// Left edge
		if (x < 0) x = 0;

		// Right edge
		if (x + width > FlxG.width)
			x = FlxG.width - width;

		// Top
		if (y < 0) y = 0;

		// Bottom
		if (y + height > FlxG.height)
			y = FlxG.height - height;
	}
}