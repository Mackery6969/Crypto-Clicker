package;

import PlayState;
import flixel.FlxG;
import flixel.util.FlxSave;

class ClientPrefs
{
	// for load and saving settings
	static var settingNames:Array<String> = [
		"fullscreen",
		"sound",
		"music",
		"reducedMotion",
		"showFPS",
		"flashing",
		"framerate",
		"antialiasing",
		"autoPause"
	];
	public static var fullscreen:Bool = false;
	public static var sound:Bool = true;
	public static var music:Bool = true;
	public static var reducedMotion:Bool = false;
	public static var showFPS:Bool = false;
	public static var flashing:Bool = true; // assumes that this is true by default which should be fixed as fast as possible
	public static var framerate:Int = 60;
	public static var antialiasing:Bool = false;
	public static var autoPause:Bool = true;

	// saved stuff (non option related)
	// stuff soon xD
	static var data:Array<String> = ["money", "moneyPerSecond", "moneyPerClick"];

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
		saveData.flush();
		saveData.destroy();
	}

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

		FlxG.save.flush();
	}

	public static function resetSettings()
	{
		FlxG.save.bind("settings", "Crypto-Clicker-Settings");
		FlxG.save.erase();
		FlxG.save.flush();
		FlxG.save.bind("game", "Crypto-Clicker-Save");
		FlxG.save.erase();
		FlxG.save.flush();
	}

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
