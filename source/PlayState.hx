package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;

class PlayState extends FlxState
{
	var coins:Int = 0;
	var player:Player;

	var spawnedCoins:FlxTypedGroup<FlxSprite>;
	var spawnedBullets:FlxTypedGroup<Bullet>;
	var spawnedZombies:FlxTypedGroup<Zombie>;

	override public function create()
	{
		super.create();

		camera.bgColor = -1;

		player = new Player();
		add(player);

		spawnedCoins = new FlxTypedGroup<FlxSprite>();
		add(spawnedCoins);

		spawnedBullets = new FlxTypedGroup<Bullet>();
		add(spawnedBullets);

		spawnedZombies = new FlxTypedGroup<Zombie>();
		add(spawnedZombies);
	}

	final COIN_INTERVAL:Float = 15;
	final ZOMB_INTERVAL:Float = 1;

	var coinTimer:Float = 0;
	var zombTimer:Float = 0;

	inline function spawnCoin(x:Float, y:Float)
	{
		var coin = new FlxSprite(x, y);
		coin.loadGraphic("assets/images/coin.png");
		spawnedCoins.add(coin);
	}

	inline function spawnZombie(x:Float, y:Float)
	{
		var zomb = new Zombie(x, y, FlxG.random.bool() ? Basic : Fast, player);
		add(zomb);
	}

	inline function spawnBullet(x:Float, y:Float, angle:Float)
	{
		var bullet = new Bullet(x, y, angle);
		spawnedBullets.add(bullet);
	}

	var shot:Bool = false;
	final SHOOT_INTERVAL:Float = 0.25;
	var shootTimer:Float = 0;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		coinTimer += elapsed;
		zombTimer += elapsed;
		// trace(coinTimer);

		if (coinTimer >= COIN_INTERVAL)
		{
			coinTimer = 0;
			var randX = FlxG.random.float(0, FlxG.width);
			var randY = FlxG.random.float(0, FlxG.height);
			spawnCoin(randX, randY);
		}

		for (coin in spawnedCoins)
		{
			if (FlxG.overlap(player, coin))
			{
				coin.destroy();
				coins++;
				trace(coins);
			}
		}

		if (zombTimer >= ZOMB_INTERVAL)
		{
			zombTimer = 0;
			var randY = FlxG.random.float(0, FlxG.height);
			spawnZombie(FlxG.width + 128, randY);
		}

		if(FlxG.mouse.pressed)
		{
			switch (player.weaponState)
			{
				case Pistol:
					if (!shot)
					{
						spawnBullet(player.x, player.y, player.angle);
						shot = true;
					}
				case Automatic:
					shootTimer += elapsed;
					if (shootTimer >= SHOOT_INTERVAL)
					{
						shootTimer = 0;
						spawnBullet(player.x, player.y, player.angle);
					}
				default:
					throw "Unknown weapon state: " + player.weaponState;
			}
		}
		else
		{
			shootTimer = 0;
			shot = false;
		}

		for (bullet in spawnedBullets)
		{
			for (zombie in spawnedZombies)
			{
				if (FlxG.overlap(bullet, zombie))
				{
					bullet.destroy();
					zombie.hurt(1);
				}
			}
		}
	}
}
