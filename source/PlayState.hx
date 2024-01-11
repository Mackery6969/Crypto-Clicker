package;

#if discord_rpc
import DiscordHandler;
#end
import Util;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class PlayState extends FlxState
{
	var background:FlxSprite;
	var clicker:FlxSprite;
	var clickSound:FlxSound; // Add a variable for the sound
	var cookiesText:FlxText;

	public static var cookies:Float = 0;
	public static var cookiesPerClick:Float = 0.25;
	public static var upgrades:Array<Upgrade> = new Array<Upgrade>();

	override public function create()
	{
		// load saved data if it isnt null
		if (FlxG.save.data != null)
		{
			cookies = FlxG.save.data.cookies;
			cookiesPerClick = FlxG.save.data.cookiesPerClick;
			upgrades = haxe.Unserializer.run(FlxG.save.data.upgrades);
		}

		super.create();

		// make background that scrolls to the bottom right and loops
		background = new FlxSprite(0, 0).loadGraphic(Util.image('ui/LuigiGrid'));
		background.scrollFactor.set(0, 0);
		background.scale.set(2, 2);
		add(background);

		// Make cookie clicker
		clicker = new FlxSprite(50, 200).loadGraphic(Util.image('Quarter')); // Adjust position as needed
		clicker.scale.set(1.8, 1.8); // Adjust scale as needed
		add(clicker);

		// Make text
		cookiesText = new FlxText(0, 0, 200); // Adjust position as needed
		cookiesText.setFormat(null, 24, 0xFFFFFF, "left"); // Add missing fields for the FlxText object initialization
		cookiesText.size = 24; // Adjust size as needed
		add(cookiesText);

		// add a button to go to the options menu in the top right corner
		var optionsButton:FlxButton = new FlxButton(0, 0, "Options", function()
		{
			trace("Went to Options????");
			FlxG.switchState(new OptionsState());
		});
		optionsButton.x = FlxG.width - optionsButton.width;
		add(optionsButton);

		// shop button
		var shopButton:FlxButton = new FlxButton(0, 0, "Shop", function()
		{
			trace("Went to Shop????");
			FlxG.switchState(new ShopState());
		});
		shopButton.x = FlxG.width - shopButton.width;
		shopButton.y = optionsButton.height;
		add(shopButton);

		// Load click sound
		if (ClientPrefs.sound)
			clickSound = new FlxSound().loadEmbedded(Util.sound('Click')); // Create an instance of FlxSound and load the sound
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		#if discord_rpc
		// update discord rpc
		DiscordHandler.changePresence('Clicking Crypto\n$' + Util.FloatToString(cookies) + '\nCash Per Click: ' + Util.FloatToString(cookiesPerClick));
		#end

		if (ClientPrefs.music)
		{
			if (FlxG.sound.music == null || !FlxG.sound.music.playing)
				FlxG.sound.playMusic(Util.music('menuMusic'), 0.5);
		}

		// background moves to the bottom right and loops
		background.x += 0.5;
		background.y += 0.5;
		if (background.x >= FlxG.width)
			background.x = 0;
		if (background.y >= FlxG.height)
			background.y = 0;

		// Update text
		cookiesText.text = '$' + Util.FloatToString(cookies);
		// Check for click on cookie
		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.x >= clicker.x
				&& FlxG.mouse.x <= clicker.x + clicker.width
				&& FlxG.mouse.y >= clicker.y
				&& FlxG.mouse.y <= clicker.y + clicker.height)
			{
				cookies += cookiesPerClick;
				// Play the click sound stack if spammed
				if (ClientPrefs.sound)
					clickSound.play(true);
				trace('Click! (+ ' + cookiesPerClick + ')');
			}
		}

		// save data
		FlxG.save.data.cookies = cookies;
		FlxG.save.data.cookiesPerClick = cookiesPerClick;
		FlxG.save.flush();
	}

	public static function upgradeApply():Void
	{
		// Iterate through upgrades and apply their effects
		for (upgrade in upgrades)
		{
			switch (upgrade.name)
			{
				case "Half Dollar":
					// Apply the effects of the "Half Dollar" upgrade
					cookiesPerClick += 0.25;
					FlxG.save.data.cookiesPerClick += 0.25;
					break;
					// Add more cases for other upgrades as needed
			}
		}
	}

	public static function saveUpgrades():Void
	{
		// Serialize and save upgrades to FlxG save data
		FlxG.save.data.upgrades = haxe.Serializer.run(PlayState.upgrades);
		FlxG.save.flush();
	}

	public static function loadUpgrades():Void
	{
		// Load and deserialize upgrades from FlxG save data
		if (FlxG.save.data != null && FlxG.save.data.upgrades != null)
		{
			PlayState.upgrades = haxe.Unserializer.run(FlxG.save.data.upgrades);
		}
	}
}
