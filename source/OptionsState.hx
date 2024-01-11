package;

import PlayState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

class OptionsState extends FlxState
{
	var background:FlxSprite;

	// create an options menu
	override public function create()
	{
		// make background that scrolls to the bottom right and loops
		background = new FlxSprite(0, 0).loadGraphic(Util.image('ui/LuigiGrid'));
		background.scrollFactor.set(0, 0);
		background.scale.set(2, 2);
		add(background);

		var title:FlxText;
		title = new FlxText(0, FlxG.height / 2 - 20, FlxG.width, "Options");
		title.size = 16;
		title.alignment = "center";
		add(title);

		var placeholder = new FlxText(FlxG.width / 2 - 50, FlxG.height - 20, 100, "click to go back");
		placeholder.alignment = "center";
		add(placeholder);
	}

	// go back to the menu state
	override public function update(elapsed)
	{
		super.update(elapsed);
		if (FlxG.mouse.justPressed)
			FlxG.switchState(new PlayState());

		background.x += 0.5;
		background.y += 0.5;
		if (background.x >= FlxG.width)
			background.x = 0;
		if (background.y >= FlxG.height)
			background.y = 0;

		#if discord_rpc
		// update discord rich presence
		DiscordHandler.changePresence('Configuring Options\n$' + Util.FloatToString(PlayState.cookies) + '\nCash Per Click: ' + Util.FloatToString(PlayState.cookiesPerClick));
		#end

		// when r held for a second or so, reset the game
		if (FlxG.keys.justPressed.R)
		{
			ClientPrefs.reset();
		}
	}
}
