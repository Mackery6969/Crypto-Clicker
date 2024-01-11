package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSave;

class Util
{
	inline public static function roundDown(num:Float):Int
	{
		return Math.floor(num);
	}

	static var file:String;

	inline public static function image(image:String, folder:String = 'images')
	{
		return file = 'assets/$folder/$image.png';
	}

	inline public static function sound(sound:String, folder:String = 'sounds')
	{
		return file = 'assets/$folder/$sound.ogg';
	}

	inline public static function music(music:String, folder:String = 'music')
	{
		return file = 'assets/$folder/$music.ogg';
	}

	inline public static function IntToString(i:Int):String
	{
		var strbuf:StringBuf = new StringBuf();
		strbuf.add(i);
		return strbuf.toString();
	}

	inline public static function FloatToString(i:Float):String
	{
		var strbuf:StringBuf = new StringBuf();
		strbuf.add(i);
		return strbuf.toString();
	}

	inline public static function convertFloatToInt(f:Float):Int
	{
		return Std.int(f);
	}

	inline public static function convertIntToFloat(i:Int):Float
	{
		return i;
	}

	inline public static function txt(path:String)
	{
		return file = 'assets/$path.txt';
	}

	inline public static function capitalize(text:String)
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();

	public static function floorDecimal(value:Float, decimals:Int):Float
	{
		if (decimals < 1)
			return Math.floor(value);

		var tempMult:Float = 1;
		for (i in 0...decimals)
			tempMult *= 10;

		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}

	inline public static function browserLoad(site:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}
}
