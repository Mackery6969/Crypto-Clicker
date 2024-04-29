package;

class ClientPrefs
{
	static var settingNames = [
		"fullscreen",
		"sound",
		"music",
		"reducedMotion",
		"showFPS",
		"flashing",
		"framerate"
	];
	static var version = "1.0.0";
	public static var fullscreen:Bool = false;
	public static var sound:Bool = true;
	public static var music:Bool = true;
	public static var reducedMotion = false;
	public static var showFPS = false;
	public static var flashing = true;
	public static var framerate = 60;

	public static function saveSettings()
	{
		for (setting in settingNames)
		{
			Reflect.setField(FlxG.save.data, setting, Reflect.getProperty(ClientPrefs, setting));
		} // thx srt for this xD
		FlxG.save.data.framerate = framerate;
	}
}
