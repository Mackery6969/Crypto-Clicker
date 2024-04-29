package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;

class PlayState extends FlxState
{
	override public function create()
	{
		// Load Data
		ClientPrefs.loadSettings();

		super.create();

		// add cookie to the screen
		var cookie:FlxSprite = new FlxSprite(0, 0, Util.image("quarter"));
		// position at the center of the screen
		cookie.x = (FlxG.width - cookie.width) / 2;
		cookie.y = (FlxG.height - cookie.height) / 2;
		cookie.scale.set(2, 2);
		add(cookie);

		// add text to the screen that says how much money you have
		var text:FlxText = new FlxText(0, 0, FlxG.width, "You have $0");
		text.x = cookie.x;
		// above the cookie
		text.y = cookie.y - 100;
		text.size = 16;
		add(text);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
