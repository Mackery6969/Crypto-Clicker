package;

import haxe.io.Output;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;

class PlayState extends FlxState
{
	static var version:String; // for version checker
	static var outdated:Bool = false; // for version checker
	var versionText:FlxText;
	var cookie:FlxSprite;
	var moneyText:FlxText;
	var gear:FlxSprite;
	var shop:FlxSprite;
	var updateButton:FlxSprite;
	public static var money:Float = 0;
	public static var moneyPerClick:Float = 0.25;
	public static var moneyPerSecond:Float = 0;

	override public function create()
	{
		// Load Data
		ClientPrefs.loadSettings();

		// get the version of the game
		version = Util.read("data/version.txt");
		// get the contents of a raw github file
		var latestVersion = Util.getURL("https://raw.githubusercontent.com/Mackery6969/Crypto-Luigi-Clicker/main/assets/data/version.txt");
		if (latestVersion != version) {
			outdated = true;
			trace("New version available! " + latestVersion);
			trace("Current version: " + version);
		}

		super.create();

		// add version text at the bottom left corner
		versionText = new FlxText(0, 0, FlxG.width, version);
		versionText.x = 10;
		versionText.y = FlxG.height - 20;
		versionText.size = 12;
		add(versionText);

		// add cookie to the screen
		cookie = new FlxSprite(0, 0, Util.image("quarter"));
		cookie.x = (FlxG.width - cookie.width) / 2 - 300;
		cookie.y = (FlxG.height - cookie.height) / 2;
		cookie.scale.set(2.5, 2.5);
		cookie.antialiasing = ClientPrefs.antialiasing;
		add(cookie);

		// add text to the screen that says how much money you have
		moneyText = new FlxText(0, 0, FlxG.width, "$0");
		moneyText.x = cookie.x + 15;
		moneyText.y = cookie.y - 100;
		moneyText.size = 16;
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
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (outdated) {
			versionText.text = version + " (Update Available!)";
			versionText.color = 0xD9FF00;
		}

		// update the text to show how much money you have
		// this is done every frame
		moneyText.text = '$' + money;

		ClientPrefs.saveSettings();
	
		// if the mouse hovers over the cookie and clicks add money
		if (FlxG.mouse.justPressed) {
			if (FlxG.mouse.x >= cookie.x && FlxG.mouse.x <= cookie.x + cookie.width && FlxG.mouse.y >= cookie.y && FlxG.mouse.y <= cookie.y + cookie.height) {
				money += moneyPerClick;
				trace("Click! + " + moneyPerClick);
			}
			// check for settings button click
			if (FlxG.mouse.x >= gear.x - 50 && FlxG.mouse.x <= gear.x + gear.width && FlxG.mouse.y >= gear.y && FlxG.mouse.y <= gear.y + gear.height) {
				FlxG.switchState(new SettingsState());
			}
			// check for shop button click
			if (FlxG.mouse.x >= shop.x - 50 && FlxG.mouse.x <= shop.x + shop.width && FlxG.mouse.y >= shop.y && FlxG.mouse.y <= shop.y + shop.height) {
				//FlxG.switchState(new ShopState());
			}
        }

		#if sys
		// close the game if escape is pressed
		if (FlxG.keys.justPressed.ESCAPE) {
			Sys.exit(1);
		}
		#end

		// check if money is in the negatives
		if (money < 0) {
			// user is in debt, they have 1 minute to pay it off or else they lose
		}

		#if debug
		// debug stuff
		if (FlxG.keys.justPressed.U) {
			outdated = !outdated;
		}
		#end
	}
}
