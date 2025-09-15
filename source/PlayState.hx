package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;

class PlayState extends FlxState
{
	var coins:Int = 0;
	var player:Player;

	var spawnedCoins:FlxGroup;

	override public function create()
	{
		super.create();

		camera.bgColor = -1;

		player = new Player();
		add(player);

		spawnedCoins = new FlxGroup();
		add(spawnedCoins);
	}

	var coinTimer:Float = 0;
	var coinSpawn:Float = 15;

	function spawnCoin(x:Float, y:Float)
	{
		var coin = new FlxSprite(x, y);
		coin.loadGraphic("assets/images/coin.png");
		spawnedCoins.add(coin);
		// add(coin);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		coinTimer += elapsed;
		trace(coinTimer);

		if (coinTimer >= coinSpawn)
		{
			coinTimer = 0;
			var randX = FlxG.random.float(0, FlxG.width);
			var randY = FlxG.random.float(0, FlxG.height);
			spawnCoin(randX, randY);
		}
	}
}
