package;

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
	static var version:String = "1.0.0";
	public static var fullscreen:Bool = false;
	public static var sound:Bool = true;
	public static var music:Bool = true;
	public static var reducedMotion:Bool = false;
	public static var showFPS:Bool = false;
	public static var flashing:Bool = true;
	public static var framerate:Int = 60;
	public static var antialiasing:Bool = false;
	public static var autoPause:Bool = true;

	// saved stuff (non option related)
	public static var money:Float = 0;
	public static var moneyPerSecond:Float = 0;
	public static var moneyPerClick:Float = 0.25;

	public static function saveSettings()
	{
		for (setting in settingNames)
		{
			Reflect.setField(FlxG.save.data, setting, Reflect.getProperty(ClientPrefs, setting));
		} // thx srt for this xD
		FlxG.save.data.framerate = framerate;
		#if (flixel > "5.0.0")
		FlxSprite.defaultAntialiasing = antialiasing;
		#end

		FlxG.save.flush();

		var saveData:FlxSave = new FlxSave();
		saveData.bind("game", "Crypto-Clicker-Save"); // saved here so it can be reset and leave the options untouched.
		saveData.data.money = money;
		saveData.data.moneyPerSecond = moneyPerSecond;
		saveData.data.moneyPerClick = moneyPerClick;
		saveData.flush();
		saveData.destroy();
	}

	public static function loadSettings()
	{
		FlxG.save.bind('crypto', 'Crypto-Clicker-Save');
		for (setting in settingNames) {
			var savedData = Reflect.field(FlxG.save.data, setting);
			if (savedData != null)
				Reflect.setProperty(ClientPrefs, setting, savedData);
		}

		if (FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
			if (framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}

		#if (flixel > "5.0.0")
		FlxSprite.defaultAntialiasing = antialiasing;
		#end

		FlxG.autoPause = autoPause;
		FlxG.fullscreen = fullscreen;
		
		/* might use for later lol
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
		#if (flixel > "5.0.0")
		if (Reflect.hasField(FlxG.save.data, "antialiasing"))
		{
			antialiasing = Reflect.field(FlxG.save.data, "antialiasing");
			FlxSprite.defaultAntialiasing = antialiasing;
		}
		#end
		*/
	}
}
