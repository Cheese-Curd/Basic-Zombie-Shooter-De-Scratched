package;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;

enum WeaponState
{
	Pistol;
	Automatic;
	Burst;
}

class Player extends ClampedSprite
{
	public var weaponState:WeaponState = Pistol;
	var weaponsUnlocked:Int = 1;

	public var shootRate = 1; // x per second

	public function new(?x:Int = 0, ?y:Int = 0)
	{
		super(x, y);

		loadGraphic("assets/images/player.png", true, 48, 32);
		animation.add("pistol_idle",  [0],    1);
		animation.add("pistol_shoot", [1, 0], 5, false);

		animation.add("auto_idle",  [2],    1);
		animation.add("auto_shoot", [2, 3], 8);

		animation.add("death", [4], 1);

		origin.set(width / 2, height / 2);

		animation.play("pistol_idle");
	}

	var sprinting:Bool = false;

	final BASE_SPEED:Float = 90;

	public var curSpeed:Float = 0;

	var xDir:Int = 0;
	var yDir:Int = 0;

	var pressedKey:FlxKey;

	override function update(elapsed:Float) {
		super.update(elapsed);

		// Face Mouse
        var dx = FlxG.mouse.x - x - width / 2;
		var dy = FlxG.mouse.y - y - height / 2;
		angle = Math.atan2(dy, dx) * 180 / Math.PI;

		// Movemnt
		xDir = (FlxG.keys.pressed.D ? 1 : 0) - (FlxG.keys.pressed.A ? 1 : 0);
		yDir = (FlxG.keys.pressed.S ? 1 : 0) - (FlxG.keys.pressed.W ? 1 : 0);

		sprinting = FlxG.keys.pressed.SHIFT;

		curSpeed = BASE_SPEED * (sprinting ? 2.25 : 1);

		var curVel:FlxPoint = FlxPoint.get(curSpeed * xDir,  curSpeed * yDir);

		if (!curVel.isZero())
			curVel = curVel.normalize();

		velocity.set(curVel.x * curSpeed, curVel.y * curSpeed);

		// Weapon stuff
		if(FlxG.mouse.pressed)
		{
			switch (weaponState)
			{
				case Pistol:
					animation.play("pistol_shoot");
				default:
					animation.play("auto_shoot");
			}
		}
		else
		{
			switch (weaponState)
			{
				case Pistol:
					animation.play("pistol_idle");
				default:
					animation.play("auto_idle");
			}
		}

		if      (FlxG.keys.justPressed.ONE)   pressedKey = FlxKey.ONE;
		else if (FlxG.keys.justPressed.TWO)   pressedKey = FlxKey.TWO;
		else if (FlxG.keys.justPressed.THREE) pressedKey = FlxKey.THREE;
		else if (FlxG.keys.justPressed.FOUR)  pressedKey = FlxKey.FOUR;

		switch (pressedKey)
		{
			case FlxKey.ONE:
				weaponState = Pistol;
				shootRate   = 4;
			case FlxKey.TWO:
				weaponState = Automatic;
				shootRate   = 6;
			case FlxKey.THREE:
				weaponState = Burst;
				shootRate   = 10;
			// case FlxKey.FOUR:
			// 	weaponState = Pistol;
			// 	shootRate   = 1;
			default:
				return; // Nothing needed is being pressed
		}
	}
}