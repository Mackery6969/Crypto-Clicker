package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;

class PlayState extends FlxState
{
	var cookie:FlxSprite;
	var moneyText:FlxText;
	public static var money:Float = 0;
	public static var moneyPerClick:Float = 0.25;
	public static var moneyPerSecond:Float = 0;

	override public function create()
	{
		// Load Data
		ClientPrefs.loadSettings();

		super.create();

		// add cookie to the screen
		cookie = new FlxSprite(0, 0, Util.image("quarter"));
		cookie.x = (FlxG.width - cookie.width) / 2 - 250;
		cookie.y = (FlxG.height - cookie.height) / 2;
		cookie.scale.set(2.5, 2.5);
		add(cookie);

		// add text to the screen that says how much money you have
		moneyText = new FlxText(0, 0, FlxG.width, "$0");
		moneyText.x = cookie.x + 10;
		moneyText.y = cookie.y - 100;
		moneyText.size = 16;
		add(moneyText);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// update the text to show how much money you have
		// this is done every frame
		moneyText.text = '$' + money;

		ClientPrefs.saveSettings();
	
		// if the mouse hovers over the cookie and clicks add money
		if (FlxG.mouse.justPressed && FlxG.mouse.x >= cookie.x && FlxG.mouse.x <= cookie.x + cookie.width && FlxG.mouse.y >= cookie.y && FlxG.mouse.y <= cookie.y + cookie.height) {
			money += moneyPerClick;
			trace("Click! + " + moneyPerClick);
        }

		#if sys
		// close the game if escape is pressed
		if (FlxG.keys.justPressed.ESCAPE) {
			Sys.exit(1);
		}
		#end
	}
}
