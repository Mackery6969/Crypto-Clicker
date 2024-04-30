package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;

class PlayState extends FlxState
{
	static var version:String; // for version checker
	var cookie:FlxSprite;
	var moneyText:FlxText;
	var gear:FlxSprite;
	public static var money:Float = 0;
	public static var moneyPerClick:Float = 0.25;
	public static var moneyPerSecond:Float = 0;

	override public function create()
	{
		// Load Data
		ClientPrefs.loadSettings();

		// get the version of the game
		version = Util.txt("data/version");

		super.create();

		// add cookie to the screen
		cookie = new FlxSprite(0, 0, Util.image("quarter"));
		cookie.x = (FlxG.width - cookie.width) / 2 - 250;
		cookie.y = (FlxG.height - cookie.height) / 2;
		cookie.scale.set(2.5, 2.5);
		cookie.antialiasing = ClientPrefs.antialiasing;
		add(cookie);

		// add text to the screen that says how much money you have
		moneyText = new FlxText(0, 0, FlxG.width, "$0");
		moneyText.x = cookie.x + 10;
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
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

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
			if (FlxG.mouse.x >= gear.x - 50 && FlxG.mouse.x <= gear.x + gear.width && FlxG.mouse.y >= gear.y && FlxG.mouse.y <= gear.y + gear.height)
				FlxG.switchState(new SettingsState());
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
	}
}
