package;

enum ZombieType
{
	Basic;
	Fast;
}

class Zombie extends ClampedSprite
{
	var curType:ZombieType = Basic;
	var speed:Float = 0.0;
	var health:Int  = 3;
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

		// Face Player
		var dx = _PLAYER.x - x - width / 2;
		var dy = _PLAYER.y - y - height / 2;
		angle = Math.atan2(dy, dx) * 180 / Math.PI;
	}
}