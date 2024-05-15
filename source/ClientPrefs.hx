package;

import PlayState;
import ViewLandState;
import flixel.FlxG;
import flixel.util.FlxSave;

class ClientPrefs
{
	// for load and saving settings
	static var settingNames:Array<String> = [
		"fullscreen", "sound", "music", "reducedMotion", "showFPS", "flashing", "framerate", "antialiasing", "autoPause", "reloadRequired", "preload", "secretSounds", "username", "token", "privateKey"
	];
	public static var fullscreen:Bool = false;
	public static var sound:Bool = true;
	public static var music:Bool = true;
	public static var reducedMotion:Bool = false;
	public static var showFPS:Bool = false;
	public static var flashing:Bool = true; // assumes that this is true by default which should be fixed as fast as possible
	public static var framerate:Int = 60;
	public static var antialiasing:Bool = false;
	public static var autoPause:Bool = false;
	public static var preload:Bool = false; // for the preloader
	public static var secretSounds:Bool = false; // for raldi sfx

	public static var reloadRequired:Bool = false; // not actually an option, just a flag to know if the game needs to be reloaded to apply the settings

	// feel free to modify these to your hearts content!
	// these are the default values for the game
	public static var defaultFont:String = "comic-sans";

	// stuff for gamejolt api
	public static var gameJolt:Bool = false;
	public static var gjGameID:Int = 895023;
	public static var privateKey:String;
	public static var sessionRunning:Bool = false;
	public static var username:String = "Username";
	public static var token:String = "Token";

	// saved stuff (non option related)
	// stuff soon xD
	static var data:Array<String> = ["money", "moneyPerSecond", "moneyPerClick", "lands", "inDebt", "lost", "timeLeft"];

	// stuff for results
	public static var totalMoneyGained:Float = 0;
	public static var totalMoneyLost:Float = 0;
	public static var totalMoneySpent:Float = 0;
	public static var totalLandBought:Int = 0;
	public static var totalBuildingsBought:Int = 0;
	public static var totalClicks:Int = 0;
	public static var finalMoney:Float = 0;
	public static var finalMoneyPerSecond:Float = 0;
	public static var finalMoneyPerClick:Float = 0;
	public static var finalLands:Int = 0;
	public static var runTime:Float = 0;

	/**
	 * Save the settings to the save file
	 * As well as the game data
	 */
	public static function saveSettings()
	{
		FlxG.save.bind("settings", "Crypto-Clicker-Settings");
		for (setting in settingNames)
		{
			Reflect.setField(FlxG.save.data, setting, Reflect.getProperty(ClientPrefs, setting));
		}
		Reflect.setField(FlxG.save.data, "framerate", framerate);
		#if (flixel > "5.0.0")
		FlxSprite.defaultAntialiasing = antialiasing;
		#end
		FlxG.autoPause = autoPause;
		FlxG.fullscreen = fullscreen;

		FlxG.save.flush();

		var saveData:FlxSave = new FlxSave();
		saveData.bind("game", "Crypto-Clicker-Save"); // saved here so it can be reset and leave the options untouched.
		saveData.data.money = PlayState.money;
		saveData.data.moneyPerSecond = PlayState.moneyPerSecond;
		saveData.data.moneyPerClick = PlayState.moneyPerClick;
		saveData.data.inDebt = PlayState.inDebt;
		saveData.data.lands = ViewLandState.lands;
		saveData.data.lost = PlayState.lost;
		saveData.data.timeLeft = PlayState.timeLeft;

		// for the results screen
		saveData.data.totalMoneyGained = totalMoneyGained;
		saveData.data.totalMoneyLost = totalMoneyLost;
		saveData.data.totalMoneySpent = totalMoneySpent;
		saveData.data.totalLandBought = totalLandBought;
		saveData.data.totalBuildingsBought = totalBuildingsBought;
		saveData.data.totalClicks = totalClicks;
		saveData.data.finalMoney = finalMoney;
		saveData.data.finalMoneyPerSecond = finalMoneyPerSecond;
		saveData.data.finalMoneyPerClick = finalMoneyPerClick;
		saveData.data.finalLands = finalLands;
		saveData.data.runTime = runTime;

		saveData.flush();
		saveData.destroy();
	}

	/**
	 * Load the settings from the save file
	 * As well as the game data
	 */
	public static function loadSettings()
	{
		FlxG.save.bind("settings", "Crypto-Clicker-Settings");
		for (setting in settingNames)
		{
			if (Reflect.hasField(FlxG.save.data, setting))
			{
				Reflect.setProperty(ClientPrefs, setting, Reflect.field(FlxG.save.data, setting));
			}
		}
		if (Reflect.hasField(FlxG.save.data, "reloadRequired"))
		{
			reloadRequired = Reflect.field(FlxG.save.data, "reloadRequired");
		}

		if (Reflect.hasField(FlxG.save.data, "framerate"))
		{
			framerate = Reflect.field(FlxG.save.data, "framerate");
		}
		// update framerate
		if (framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = framerate;
			FlxG.drawFramerate = framerate;
		}
		else
		{
			FlxG.drawFramerate = framerate;
			FlxG.updateFramerate = framerate;
		}
		#if (flixel > "5.0.0")
		if (Reflect.hasField(FlxG.save.data, "antialiasing"))
		{
			antialiasing = Reflect.field(FlxG.save.data, "antialiasing");
			FlxSprite.defaultAntialiasing = antialiasing;
		}
		#end
		FlxG.autoPause = autoPause;
		FlxG.fullscreen = fullscreen;

		FlxG.save.bind("game", "Crypto-Clicker-Save");
		if (Reflect.hasField(FlxG.save.data, "money"))
		{
			PlayState.money = Reflect.field(FlxG.save.data, "money");
		}
		if (Reflect.hasField(FlxG.save.data, "moneyPerSecond"))
		{
			PlayState.moneyPerSecond = Reflect.field(FlxG.save.data, "moneyPerSecond");
		}
		if (Reflect.hasField(FlxG.save.data, "moneyPerClick"))
		{
			PlayState.moneyPerClick = Reflect.field(FlxG.save.data, "moneyPerClick");
		}
		if (Reflect.hasField(FlxG.save.data, "inDebt"))
		{
			PlayState.inDebt = Reflect.field(FlxG.save.data, "inDebt");
		}
		if (Reflect.hasField(FlxG.save.data, "lands"))
		{
			ViewLandState.lands = Reflect.field(FlxG.save.data, "lands");
		}
		if (Reflect.hasField(FlxG.save.data, "lost"))
		{
			PlayState.lost = Reflect.field(FlxG.save.data, "lost"); // so if the player goes into debt, they cant just reload the game to get out of it
		}
		if (Reflect.hasField(FlxG.save.data, "timeLeft"))
		{
			PlayState.timeLeft = Reflect.field(FlxG.save.data, "timeLeft");
		}

		// for the results screen
		if (Reflect.hasField(FlxG.save.data, "totalMoneyGained"))
		{
			totalMoneyGained = Reflect.field(FlxG.save.data, "totalMoneyGained");
		}
		if (Reflect.hasField(FlxG.save.data, "totalMoneyLost"))
		{
			totalMoneyLost = Reflect.field(FlxG.save.data, "totalMoneyLost");
		}
		if (Reflect.hasField(FlxG.save.data, "totalMoneySpent"))
		{
			totalMoneySpent = Reflect.field(FlxG.save.data, "totalMoneySpent");
		}
		if (Reflect.hasField(FlxG.save.data, "totalLandBought"))
		{
			totalLandBought = Reflect.field(FlxG.save.data, "totalLandBought");
		}
		if (Reflect.hasField(FlxG.save.data, "totalBuildingsBought"))
		{
			totalBuildingsBought = Reflect.field(FlxG.save.data, "totalBuildingsBought");
		}
		if (Reflect.hasField(FlxG.save.data, "totalClicks"))
		{
			totalClicks = Reflect.field(FlxG.save.data, "totalClicks");
		}
		if (Reflect.hasField(FlxG.save.data, "finalMoney"))
		{
			finalMoney = Reflect.field(FlxG.save.data, "finalMoney");
		}
		if (Reflect.hasField(FlxG.save.data, "finalMoneyPerSecond"))
		{
			finalMoneyPerSecond = Reflect.field(FlxG.save.data, "finalMoneyPerSecond");
		}
		if (Reflect.hasField(FlxG.save.data, "finalMoneyPerClick"))
		{
			finalMoneyPerClick = Reflect.field(FlxG.save.data, "finalMoneyPerClick");
		}
		if (Reflect.hasField(FlxG.save.data, "finalLands"))
		{
			finalLands = Reflect.field(FlxG.save.data, "finalLands");
		}
		if (Reflect.hasField(FlxG.save.data, "runTime"))
		{
			runTime = Reflect.field(FlxG.save.data, "runTime");
		}

		FlxG.save.flush();

		trace("Settings loaded");
	}

	/**
	 * Reset the settings to the default values
	 * @param category The category to reset, either "settings" or "game"
	 */
	public static function resetSettings(category:String)
	{
		if (category == "settings")
			FlxG.save.bind("settings", "Crypto-Clicker-Settings");
		else if (category == "game")
			FlxG.save.bind("game", "Crypto-Clicker-Save");
		else
			return;
		FlxG.save.erase();
		FlxG.save.flush();

		#if sys
		Sys.exit(1);
		#end
	}

	/**
	 * Set the framerate
	 * @param fps The framerate to set
	 */
	public static function setFPS(fps:Int)
	{
		framerate = fps;
		if (framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = framerate;
			FlxG.drawFramerate = framerate;
		}
		else
		{
			FlxG.drawFramerate = framerate;
			FlxG.updateFramerate = framerate;
		}

		saveSettings();
	}
}
