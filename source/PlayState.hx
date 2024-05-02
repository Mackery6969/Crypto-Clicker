package;

import openfl.geom.Matrix;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import haxe.io.Output;
import flash.display.GradientType;
import flixel.input.keyboard.FlxKey;

class PlayState extends FlxState
{
	static var version:String; // for version checker
	static var outdated:Bool = false; // for version checker

	var bgGradient:FlxSprite;
	var versionText:FlxText;
	var quarter:FlxSprite;
	var moneyText:FlxText;
	var gear:FlxSprite;
	var shop:FlxSprite;
	var updateButton:FlxSprite;
	var computers:FlxText; // flxtext for placeholder

	public static var money:Float = 0;
	public static var moneyPerClick:Float = 0.25;
	public static var moneyPerSecond:Float = 0;
	public static var buildings:Array<Int> = [0];
	public static var inDebt:Bool = false;

	var moneyShownAsText:Float = 0;
	// make an array for the correct keys to be pressed (konomi code) in order
	var easterEggKeys:Array<String> = [
		'KILDARE'
	];
	var allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	var easterEggKeysBuffer:String = '';

	override public function create()
	{
		// Load Data
		ClientPrefs.loadSettings();

		// get the version of the game
		version = Util.read("data/version.txt");
		// get the contents of a raw github file
		var latestVersion = Util.getURL("https://raw.githubusercontent.com/Mackery6969/Crypto-Luigi-Clicker/main/assets/data/version.txt");
		if (latestVersion != version)
		{
			outdated = true;
			trace("New version available! " + latestVersion);
			trace("Current version: " + version);
		}

		super.create();

		// add background
		bgGradient = new FlxSprite(0, 0, Util.image("bgGradient"));
		// fit to the screen
		bgGradient.scale.set(FlxG.width / bgGradient.width * 2, FlxG.height / bgGradient.height * 4);
		//bgGradient.y = -bgGradient.height + FlxG.height;
		bgGradient.y = -400;
		bgGradient.antialiasing = ClientPrefs.antialiasing;
		add(bgGradient);

		// add version text at the bottom left corner
		versionText = new FlxText(0, 0, FlxG.width, version);
		versionText.x = 10;
		versionText.y = FlxG.height - 20;
		versionText.size = 12;
		add(versionText);

		// add quarter to the screen
		quarter = new FlxSprite(0, 0, Util.image("quarter"));
		quarter.x = (FlxG.width - quarter.width) / 2 - 400;
		quarter.y = (FlxG.height - quarter.height) / 2;
		quarter.scale.set(2.5, 2.5);
		quarter.antialiasing = ClientPrefs.antialiasing;
		add(quarter);

		// add text to the screen that says how much money you have
		moneyText = new FlxText(0, 0, FlxG.width, "$0");
		moneyText.x = quarter.x + 15;
		moneyText.y = quarter.y - 100;
		moneyText.size = 20;
		add(moneyText);

		// add gear in top right corner to open settings
		gear = new FlxSprite(0, 0, Util.image("gear"));
		gear.x = FlxG.width - gear.width - 10;
		gear.y = 10;
		gear.scale.set(0.5, 0.5);
		gear.antialiasing = ClientPrefs.antialiasing;
		add(gear);

		// add the shop button below the settings button
		shop = new FlxSprite(0, 0, Util.image("tradicus"));
		shop.x = FlxG.width - shop.width + 45;
		shop.y = gear.y + gear.height - 100;
		shop.scale.set(0.3, 0.3);
		shop.antialiasing = ClientPrefs.antialiasing;
		add(shop);

		// add placeholder for computers
		computers = new FlxText(0, 0, FlxG.width, "Computers:" + buildings[0]);
		// center of the screen
		computers.x = (FlxG.width - computers.width) / 2 - 200;
		computers.y = (FlxG.height - computers.height) / 2 + 100;
		computers.size = 20;
		computers.visible = false;
		add(computers);

		// play the menu music
		if (ClientPrefs.music && FlxG.sound.music == null) {
			FlxG.sound.playMusic(Util.music("menu"), 0.5);
			FlxG.sound.music.volume = 0.75;
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// loop the music
		if (FlxG.sound.music != null && !FlxG.sound.music.active && ClientPrefs.music)
			FlxG.sound.playMusic(Util.music("menu"), 0.5);

		if (FlxG.sound.music != null) {
			if (!ClientPrefs.music)
				FlxG.sound.music.stop();
			else 
				FlxG.sound.music.play();
		}

		if (outdated)
		{
			versionText.text = version + " (Update Available!)";
			versionText.color = 0xD9FF00;
		}

		// update the text to show how much money you have
		// this is done every frame
		if (money > 0)
			moneyShownAsText = Util.roundToInterval(money, 0.25);
		else 
			moneyShownAsText = Util.round(money, 2); // i want it to show how much money you are in debt
		moneyText.text = '$' + moneyShownAsText;

		ClientPrefs.saveSettings();

		// if the mouse hovers over the quarter and clicks add money
		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.x >= quarter.x
				&& FlxG.mouse.x <= quarter.x + quarter.width
				&& FlxG.mouse.y >= quarter.y
				&& FlxG.mouse.y <= quarter.y + quarter.height)
			{
				money += moneyPerClick;
				trace("Click! + " + moneyPerClick);
			}
			// check for settings button click
			if (FlxG.mouse.x >= gear.x - 50 && FlxG.mouse.x <= gear.x + gear.width && FlxG.mouse.y >= gear.y && FlxG.mouse.y <= gear.y + gear.height)
			{
				FlxG.switchState(new SettingsState());
			}
			// check for shop button click
			if (FlxG.mouse.x >= shop.x - 50 && FlxG.mouse.x <= shop.x + shop.width && FlxG.mouse.y >= shop.y && FlxG.mouse.y <= shop.y + shop.height)
			{
				// FlxG.switchState(new ShopState());
			}
		}

		#if sys
		// close the game if escape is pressed
		if (FlxG.keys.justPressed.ESCAPE)
		{
			trace("Bye!");
			Sys.exit(1);
		}
		#end

		// check if money is in the negatives
		if (money < 0)
		{
			// user is in debt, they have 1 minute to pay it off or else they lose
			moneyText.color = 0xFF0000;
			// make moneyText shake

			// if the user doesn't pay off their debt in 1 minute they lose
			// they will be taken to the game over screen
			// the game over screen will show how much money they made overall
			inDebt = true;
			FlxG.sound.music.pause();
		} else {
			moneyText.color = 0xFFFFFF;
			inDebt = false;
			FlxG.sound.music.resume();
		}

		#if debug
		// debug stuff
		if (FlxG.keys.justPressed.U)
			outdated = !outdated;
		else if (FlxG.keys.justPressed.C)
			buildings[0]++;
		else if (FlxG.keys.justPressed.PLUS)
			money += 10;
		else if (FlxG.keys.justPressed.MINUS)
			money -= 10;
		else if (FlxG.keys.justPressed.V)
			FlxG.switchState(new ViewLandState());
		#end

		// add money per second
		// every second
		money += moneyPerSecond * elapsed;

		if (buildings[0] > 0)
		{
			computers.visible = true;
			moneyPerSecond = buildings[0] * 0.001;
		}

		// check if the konomi code is pressed
		if (FlxG.keys.firstJustPressed() != FlxKey.NONE) // thx psych engine
		{
			var keyPressed:FlxKey = FlxG.keys.firstJustPressed();
			var keyName:String = Std.string(keyPressed);
			if(allowedKeys.contains(keyName)) {
				easterEggKeysBuffer += keyName;
				if(easterEggKeysBuffer.length >= 32) easterEggKeysBuffer = easterEggKeysBuffer.substring(1);

				for (wordRaw in easterEggKeys)
				{
					var word:String = wordRaw.toUpperCase(); //just for being sure you're doing it right
					if (easterEggKeysBuffer.contains(word))
					{
						//trace('YOOO! ' + word);
						switch(word) {
							case 'KILDARE':
								#if desktop
								Util.error("Nice Try", "Kildare");
								#if sys
								Sys.exit(1);
								#end
								#end
						}
					}
				}
			}
		}
	}
}
