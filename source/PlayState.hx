package;

import SoundTest;
import flash.display.GradientType;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import haxe.io.Output;
import openfl.geom.Matrix;

class PlayState extends FlxState
{
	static var version:String; // for version checker
	static var outdated:Bool = false; // for version checker

	var bgGradient:FlxSprite;
	var gridOne:FlxSprite;
	var scrollingGrid:FlxSprite;
	var versionText:FlxText;
	var quarter:FlxSprite;
	var moneyText:FlxText;
	var gear:FlxSprite;
	var shop:FlxSprite;
	var atlasEarth:FlxSprite;
	var computers:FlxText; // flxtext for placeholder

	var gridHeight:Float;
	var gridWidth:Float;
	var scrollingGrids:Array<FlxSprite> = new Array<FlxSprite>();
	var numScrollingGridsX:Int;
	var numScrollingGridsY:Int;
	var scrollSpeed:Float = 25;

	public static var money:Float = 0;
	public static var moneyPerClick:Float = 0.25;
	public static var moneyPerSecond:Float = 0;
	public static var buildings:Array<Int> = [0];
	public static var inDebt:Bool = false;

	var moneyShownAsText:Float = 0;

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
		// bgGradient.y = -bgGradient.height + FlxG.height;
		bgGradient.y = -400;
		bgGradient.antialiasing = ClientPrefs.antialiasing;
		add(bgGradient);

		// add gridOne
		gridOne = new FlxSprite(0, 0, Util.image("LuigiGrid"));
		// gridOne.scale.set(0.5, 0.5);
		gridOne.antialiasing = ClientPrefs.antialiasing;
		gridOne.alpha = 0.5;
		add(gridOne);

		// Create a temporary sprite to load the image and get its dimensions
		var tempSprite = new FlxSprite();
		tempSprite.loadGraphic(Util.image("LuigiGrid"), false, false);
		gridHeight = tempSprite.height;
		gridWidth = tempSprite.width;

		// Calculate the number of grids needed to fill the screen
		numScrollingGridsY = Math.ceil(FlxG.height / gridHeight) + 1;
		numScrollingGridsX = Math.ceil(FlxG.width / gridWidth) + 1;

		// Create and position the grid sprites
		scrollingGrids = new Array<FlxSprite>();
		for (i in 0...numScrollingGridsY)
		{
			for (j in 0...numScrollingGridsX)
			{
				var grid = new FlxSprite();
				grid.loadGraphic(Util.image("LuigiGrid"), false, false);
				grid.x = -gridWidth * j;
				grid.y = -gridHeight * i;
				grid.antialiasing = ClientPrefs.antialiasing;

				// Add the grid to the display list and the scrollingGrids array
				add(grid);
				scrollingGrids.push(grid);
			}
		}

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

		// add the Atlas Earth button below the shop button
		atlasEarth = new FlxSprite(0, 0, Util.image("AtlasEarth"));
		atlasEarth.x = FlxG.width - atlasEarth.width + 75;
		atlasEarth.y = shop.y + shop.height - 125;
		atlasEarth.scale.set(0.3, 0.3);
		atlasEarth.antialiasing = ClientPrefs.antialiasing;
		add(atlasEarth);

		// add placeholder for computers
		computers = new FlxText(0, 0, FlxG.width, "Computers:" + buildings[0]);
		// center of the screen
		computers.x = (FlxG.width - computers.width) / 2 - 200;
		computers.y = (FlxG.height - computers.height) / 2 + 100;
		computers.size = 20;
		computers.visible = false;
		add(computers);

		// play the menu music
		if (ClientPrefs.music && FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Util.music("menu"), 0.5);
			FlxG.sound.music.volume = 0.75;
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Scroll each tile diagonally across the screen
		for (tile in scrollingGrids)
		{
			tile.x -= scrollSpeed * elapsed;
			tile.y += scrollSpeed * elapsed;

			// If the tile has gone off the bottom or left of the screen, move it back to the top right
			if (tile.y >= FlxG.height)
			{
				tile.y -= tile.height * numScrollingGridsY;
			}
			if (tile.x <= -tile.width)
			{
				tile.x += tile.width * numScrollingGridsX;
			}
		}

		// loop the music
		if (FlxG.sound.music != null && !FlxG.sound.music.active && ClientPrefs.music)
			FlxG.sound.playMusic(Util.music("menu"), 0.5);

		if (FlxG.sound.music != null)
		{
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
		moneyShownAsText = Util.round(money, 3); // i want it to show how much money you are in debt
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
				// play buy.ogg
				if (ClientPrefs.sound)
					FlxG.sound.play(Util.sound("buy"), 0.5);
				money += moneyPerClick;
				trace("Click! + " + moneyPerClick);
			}
			// check for settings button click
			if (FlxG.mouse.x >= gear.x - 50 && FlxG.mouse.x <= gear.x + gear.width && FlxG.mouse.y >= gear.y && FlxG.mouse.y <= gear.y + gear.height)
			{
				if (ClientPrefs.sound)
					FlxG.sound.play(Util.sound("click"), 0.5);
				FlxG.switchState(new SettingsState());
			}
			// check for shop button click
			if (FlxG.mouse.x >= shop.x - 50 && FlxG.mouse.x <= shop.x + shop.width && FlxG.mouse.y >= shop.y && FlxG.mouse.y <= shop.y + shop.height)
			{
				if (ClientPrefs.sound)
					FlxG.sound.play(Util.sound("click"), 0.5);
				// FlxG.switchState(new ShopState());
			}
			// check for atlas earth button click
			if (FlxG.mouse.x >= atlasEarth.x - 50
				&& FlxG.mouse.x <= atlasEarth.x + atlasEarth.width
				&& FlxG.mouse.y >= atlasEarth.y
				&& FlxG.mouse.y <= atlasEarth.y + atlasEarth.height)
			{
				if (ClientPrefs.sound)
					FlxG.sound.play(Util.sound("click"), 0.5);
				FlxG.switchState(new ViewLandState());
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
		#end

		// add money per second
		// every second
		money += moneyPerSecond * elapsed;

		if (buildings[0] > 0)
		{
			computers.visible = true;
			moneyPerSecond = buildings[0] * 0.001;
		}

		if (FlxG.keys.justPressed.F1)
		{
			FlxG.switchState(new SoundTest());
		}
	}
}
