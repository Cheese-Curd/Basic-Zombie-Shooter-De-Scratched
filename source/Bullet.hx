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

		// Edge removal
		if (!isOnScreen())
			destroy();

		velocity = FlxVelocity.velocityFromAngle(angle, 250);
	}
}