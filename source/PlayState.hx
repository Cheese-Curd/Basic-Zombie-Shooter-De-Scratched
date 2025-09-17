package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxRandom;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	var coins:Int = 0;
	var player:Player;

	var spawnedCoins:FlxTypedGroup<FlxSprite>;
	var spawnedBullets:FlxTypedGroup<Bullet>;
	var spawnedZombies:FlxTypedGroup<Zombie>;

	var bgLevel:FlxSprite;

	var random:FlxRandom = new FlxRandom();

	var coinText:FlxText;

	override public function create()
	{
		super.create();

		bgLevel = new FlxSprite();
		bgLevel.loadGraphic("assets/images/levels/grass.png");
		add(bgLevel);

		camera.bgColor = -1;

		spawnedCoins = new FlxTypedGroup<FlxSprite>();
		add(spawnedCoins);

		spawnedBullets = new FlxTypedGroup<Bullet>();
		add(spawnedBullets);

		spawnedZombies = new FlxTypedGroup<Zombie>();
		add(spawnedZombies);
		
		player = new Player();
		add(player);

		// UI Stuff
		var UIBorder:FlxSprite = new FlxSprite(0,0);
		UIBorder.loadGraphic("assets/images/UIBorder.png");
		UIBorder.alpha = 0.5;
		add(UIBorder);

		var coinIcon:FlxSprite = new FlxSprite(5, 5);
		coinIcon.loadGraphic("assets/images/coin.png");
		add(coinIcon);

		coinText = new FlxText(45, 15);
		add(coinText);
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
		spawnedZombies.add(zomb);
	}

	inline function spawnBullet(x:Float, y:Float, angle:Float)
	{
		FlxG.sound.play("assets/sounds/shoot.ogg");
		var bullet = new Bullet(x, y, angle);
		spawnedBullets.add(bullet);
	}

	var shootInterval:Float = 0;
	var shootTimer:Float = 0;

	inline function handleZombDeath(zombie:Zombie)
	{
		if (random.int(0, 10) > 5)
			spawnCoin(zombie.x, zombie.y);

		spawnedZombies.remove(zombie);
		zombie.destroy();

	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		shootInterval = 1 / player.shootRate;

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
				FlxG.sound.play("assets/sounds/coin.ogg");
				coin.destroy();
				coins++;
				trace(coins);
			}
		}

		if (zombTimer >= ZOMB_INTERVAL)
		{
			zombTimer = 0;
			var randY = FlxG.random.float(0, FlxG.height);
			spawnZombie(FlxG.width + 250, randY);
		}

		shootTimer += elapsed;

		if(FlxG.mouse.pressed)
		{
			if (shootTimer >= shootInterval)
			{
				shootTimer -= shootInterval;  // subtract instead of reset to keep precision
				spawnBullet(player.x, player.y, player.angle);
			}
		}
		else
			shootTimer = shootInterval - elapsed;

		for (bullet in spawnedBullets)
		{
			for (zombie in spawnedZombies)
			{
				if (FlxG.overlap(bullet, zombie))
				{
					bullet.destroy();
					spawnedBullets.remove(bullet);
					zombie.hurt(1);
					if (zombie.health <= 0)
						handleZombDeath(zombie);
				}
			}
		}

		#if debug
		if (FlxG.keys.justPressed.R)
		{
			for (zombie in spawnedZombies)
			{
				zombie.hurt(999);
				handleZombDeath(zombie);
			}
		}
		#end

		coinText.text = '$coins';
	}
}
