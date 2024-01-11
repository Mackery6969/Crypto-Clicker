package;

import PlayState;
import flixel.FlxG;
import flixel.FlxSprite;

class ClientPrefs
{
	static var settingNames:Array<String> = [
		"fullscreen",
		"flashing",
		"sound",
		"music",
		"antialiasing",
		"framerate",
		"autoPause",
		"startedBefore"
	];
	public static var fullscreen:Bool = false;
	public static var flashing:Bool = true;
	public static var sound:Bool = true;
	public static var music:Bool = true;
	public static var antialiasing:Bool = true;
	public static var framerate:Int = 60;
	public static var autoPause:Bool = true;

	public static var startedBefore:Bool = false;

	public static function saveSettings()
	{
		for (setting in settingNames)
		{
			Reflect.setField(FlxG.save.data, setting, Reflect.getProperty(ClientPrefs, setting));
		}
		FlxG.save.data.framerate = framerate;
		#if (flixel > "5.0.0")
		FlxSprite.defaultAntialiasing = antialiasing;
		#end

		FlxG.save.flush();
	}

	public static function loadSettings()
	{
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
		}
		#end
	}

	public static function reset()
	{
		fullscreen = false;
		flashing = true;
		sound = true;
		music = true;
		#if (flixel > "5.0.0")
		antialiasing = true;
		#end
		framerate = 60;
		trace('reset all data...');
		if (FlxG.save != null)
		{
			FlxG.save.erase();
		}
		else
			trace('erase failed!');
		PlayState.upgrades = [];
		PlayState.cookies = 0;
		FlxG.save.data.cookies = 0;
		PlayState.cookiesPerClick = 0.25;
		FlxG.save.data.cookiesPerClick = 0.25;
	}
}
