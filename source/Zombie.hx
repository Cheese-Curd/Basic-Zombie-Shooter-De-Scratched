package;

import flixel.FlxG;
import flixel.effects.FlxFlicker;
import flixel.math.FlxVelocity;

enum ZombieType
{
	Basic;
	Fast;
}

class Zombie extends ClampedSprite
{
	var curType:ZombieType = Basic;
	var speed:Float = 0.0;
	public var health:Int  = 3;
	var _PLAYER:Player;

	public function new(x:Float, y:Float, zombieType:ZombieType, player:Player)
	{
		super(x, y);

		curType = zombieType;
		_PLAYER = player;

		switch(curType)
		{
			case Basic:
				speed  = 45;
				health = 3;
				loadGraphic("assets/images/basic_zombie.png");
			case Fast:
				speed  = 100;
				health = 6;
				loadGraphic("assets/images/fast_zombie.png");
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (health > 0)
		{
			// Face Player
			var dx = _PLAYER.x - x - width / 2;
			var dy = _PLAYER.y - y - height / 2;
			angle = Math.atan2(dy, dx) * 180 / Math.PI;

			if (Math.abs(velocity.x) < 1 && Math.abs(velocity.y) < 1)
			{
				FlxVelocity.moveTowardsObject(this, _PLAYER, speed);
			}
			else
			{
				velocity.x *= 0.9;
				velocity.y *= 0.9;
			}
		}
	}

	public function hurt(damage:Int)
	{
		FlxG.sound.play("assets/sounds/hit.ogg");
		health -= damage;
		trace(health, damage);

		// Knockback
		var knockbackStrength:Float = 150;
		var dx = x - _PLAYER.x;
		var dy = y - _PLAYER.y;
		var angle = Math.atan2(dy, dx);
		
		velocity.x = Math.cos(angle) * knockbackStrength;
		velocity.y = Math.sin(angle) * knockbackStrength;

		FlxFlicker.flicker(this, 0.25, 0.04, true);
	}
}