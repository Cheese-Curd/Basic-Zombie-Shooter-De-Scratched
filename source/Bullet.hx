package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;
import flixel.tweens.FlxTween;

class Bullet extends FlxSprite
{
	public function new(x:Float, y:Float, angle:Float)
	{
		super(x, y);

		loadGraphic("assets/images/bullet.png");
		this.angle = angle;
	}

	override function destroy()
	{
		// FlxTween.tween(this, { alpha = 0; }, 0.25, {onComplete: () -> {
			super.destroy();
		// }});
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		// Left edge
		if (x < 0)
			destroy();

		// Right edge
		if (x + width > FlxG.width)
			destroy();

		// Top
		if (y < 0)
			destroy();

		// Bottom
		if (y + height > FlxG.height)
			destroy();

		velocity = FlxVelocity.velocityFromAngle(angle, 100);
	}
}