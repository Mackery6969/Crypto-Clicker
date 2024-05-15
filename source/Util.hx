package;

import flixel.graphics.frames.FlxAtlasFrames;
import lime.utils.Assets;
import openfl.utils.Assets;
#if html5
import openfl.text.Font;
#end

/**
 * some utility functions
 * @author Mackery, 504Brandon, ...
 */
class Util
{
	static var file:String;

	/**
	 * Loads an image from the assets folder
	 * @param image Path to the image file
	 * @param folder If the image file is in a folder thats different from the default
	 * @return Full path to the image file
	 */
	inline public static function image(image:String, folder:String = 'images'):String
	{
		return file = 'assets/$folder/$image.png';
	}

	/**
	 * Loads a sound from the assets folder.
	 * Different from music because it reads from the sounds folder by default
	 * @param sound Path to the sound file
	 * @param folder If the sound file is in a folder thats different from the default
	 * @return Full path to the sound file
	 */
	inline public static function sound(sound:String, folder:String = 'sounds'):String
	{
		return file = 'assets/$folder/$sound.ogg';
	}

	/**
	 * Loads a music file from the assets folder
	 * Different from sound because it reads from the music folder by default
	 * @param music Path to the music file
	 * @param folder If the music file is in a folder thats different from the default
	 * @return Full path to the music file
	 */
	inline public static function music(music:String, folder:String = 'music'):String
	{
		return file = 'assets/$folder/$music.ogg';
	}

	/**
	 * Loads a XML file from the assets folder
	 * @param xml Path to the XML file
	 * @param folder Folder the XML file is in
	 * @return Full path to the XML file
	 */
	inline public static function xml(xml:String, folder:String):String
	{
		return file = 'assets/$folder/$xml.xml';
	}

	/**
	 * Converts a integer to a string
	 * @param i The integer to convert
	 * @return The integer as a string
	 */
	inline public static function IntToString(i:Int):String
	{
		var strbuf:StringBuf = new StringBuf();
		strbuf.add(i);
		return strbuf.toString();
	}

	/**
	 * Converts a float to a string
	 * @param i The float to convert
	 * @return The float as a string
	 */
	inline public static function FloatToString(i:Float):String
	{
		var strbuf:StringBuf = new StringBuf();
		strbuf.add(i);
		return strbuf.toString();
	}

	/**
	 * Converts a float to an integer
	 * @param f 
	 * @return Integer value of the float
	 */
	inline public static function convertFloatToInt(f:Float):Int
	{
		return Std.int(f);
	}

	/**
	 * Converts an integer to a float
	 * @param i 
	 * @return Float value of the integer
	 */
	inline public static function convertIntToFloat(i:Int):Float
	{
		return i;
	}

	/**
	 * Loads a text file from the assets folder
	 * @param text The name of the text file
	 * @param folder The folder the text file is in
	 * @return Full path to the text file
	 */
	inline public static function txt(text:String, folder:String):String
	{
		return file = 'assets/$folder/$text.txt';
	}

	/**
	 * Loads a json file from the assets folder
	 * @param path Path to the json file
	 * @param folder Folder the json file is in'
	 * @return Full path to the json file
	 */
	inline public static function json(path:String, folder:String):String
	{
		return file = 'assets/$folder/$path.json';
	}

	/**
	 * Loads a font from the assets folder
	 * @param font Name of the font file
	 * @param type Type of font (bold, italic, bold italic)
	 * @param extention Extention of the font file (ttf, woff, woff2)
	 * @return Full path to the font file
	 */
	inline public static function font(?font:String, ?type:String = '', ?extention:String = 'ttf')
	{
		if (font == '')
			font = ClientPrefs.defaultFont;
		if (type != '')
		{
			if (type == 'bold italic')
			{
				font = font + '-' + 'bold-italic';
			}
			else if (type == 'italic')
			{
				font = font + '-italic';
			}
			else if (type == 'bold')
			{
				font = font + '-bold';
			}
		}

		#if html5
		extention = 'woff';

		if (type != '')
		{
			return file = 'assets/fonts/woff/duplicates/$font.$extention';
		}
		return file = 'assets/fonts/woff/$font.$extention';
		#else
		if (type != '')
		{
			return file = 'assets/fonts/duplicates/$font.$extention';
		}
		return file = 'assets/fonts/$font.$extention';
		#end
	}

	/**
	 * Capitalizes every letter in a string
	 * @param text String to capitalize
	 * @return Capitalized string
	 */
	inline public static function capitalize(text:String):String
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();

	/**
	 * Floor a number to a certain number of decimal places
	 * @param value Number to floor
	 * @param decimals Number of decimal places to floor to
	 * @return Floored number
	 */
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

	/**
	 * Opens a URL in the default browser
	 * @param site URL to open
	 */
	inline public static function openURL(site:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	/**
	 * Grabs the text from a URL
	 * @param site URL to grab the text from
	 * @return Text from the URL
	 */
	inline public static function getURL(site:String):String // grabs the text, like a github raw file
	{
		var request = new haxe.Http(site);
		var response = "";
		request.onData = function(data)
		{
			response = data;
		}
		request.onError = function(error)
		{
			trace('Error: $error');
			response = '';
		}
		request.request(false);

		return (response);
	}

	/**
	 * Rounds a number to a certain number of decimal places
	 * @param value Number to round
	 * @param decimals Number of decimal places to round to
	 * @return Rounded number
	 */
	inline public static function round(value:Float, decimals:Int):Float
	{
		if (decimals < 1)
			return Math.round(value);

		var tempMult:Float = 1;
		for (i in 0...decimals)
			tempMult *= 10;

		var newValue:Float = Math.round(value * tempMult);
		return newValue / tempMult;
	}

	/**
	 * Rounds a number down to a certain number of decimal places
	 * @param value Number to round down
	 * @param decimals Number of decimal places to round down to
	 * @return Rounded down number
	 */
	inline public static function roundDown(value:Float, decimals:Int):Float
	{
		if (decimals < 1)
			return Math.floor(value);

		var tempMult:Float = 1;
		for (i in 0...decimals)
			tempMult *= 10;

		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}

	/**
	 * Rounds a number up to a certain number of decimal places
	 * @param value Number to round up
	 * @param decimals Number of decimal places to round up to
	 * @return Rounded up number
	 */
	inline public static function roundUp(value:Float, decimals:Int):Float
	{
		if (decimals < 1)
			return Math.ceil(value);

		var tempMult:Float = 1;
		for (i in 0...decimals)
			tempMult *= 10;

		var newValue:Float = Math.ceil(value * tempMult);
		return newValue / tempMult;
	}

	/**
	 * Rounds a number to the nearest interval
	 * @param value Number to round
	 * @param interval Interval to round to
	 * @return Rounded number
	 */
	inline public static function roundToInterval(value:Float, interval:Float):Float
	{
		return Math.round(value / interval) * interval;
	}

	#if desktop
	/**
	 * Displays an error message in a popup window (DESKTOP ONLY)
	 * @param error Error message
	 * @param name Name on the top left of the window
	 */
	inline public static function error(error:String, name:String):Void
	{
		FlxG.stage.window.alert(error, name);
	}
	#end

	/**
	 * Reads a file and returns an array of strings
	 * @param path Path to the file
	 * @return An array of strings with each line as an element
	 */
	inline public static function readFile(path:String):Array<String> // read each line as an element in an array
	{
		var file = Assets.getText('assets/' + path + '.txt');
		return file.split('\n');
	}

	/**
	 * Reads a single line from a file
	 * @param path Path to the file
	 * @param line Line to read, default is 0 (1st line in the file)
	 * @return Line as a string
	 */
	inline public static function readOneLine(path:String, ?line:Int = 0):String // only read the first line
	{
		var file = Assets.getText('assets/' + path + '.txt');
		return file.split('\n')[line];
	}

	/**
	 * @brief Loads a video file
	 * @param video Name of the video file
	 * @param folder Folder the video file is in
	 * @return Full path to the video file
	 */
	inline public static function video(video:String, folder:String = 'videos'):String
	{
		return file = 'assets/$folder/$video.mp4';
	}

	/**
	 * Loads a sprite sheet from a Sparrow atlas
	 * @param path Name of the sprite sheet (image + xml)
	 * @param folder Folder the sprite sheet is in
	 * @return FlxAtlasFrames object
	 */
	inline public static function sparrowAtlas(path:String, folder:String = 'images'):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow('assets/$folder/$path.png', 'assets/$folder/$path.xml');
	}

	/**
	 * Converts a number to a string with a suffix
	 * @param num Number to convert
	 * @return Converted number as a string with a suffix
	 */
	public static function numToString(num:Float):String
	{
		if (num >= 1000000000000000)
		{
			return Std.string(Util.round(num / 1000000000000000, 3)) + ' quadrillion';
		}
		else if (num >= 1000000000000)
		{
			return Std.string(Util.round(num / 1000000000000, 3)) + ' trillion';
		}
		else if (num >= 1000000000)
		{
			return Std.string(Util.round(num / 1000000000, 3)) + ' billion';
		}
		else if (num >= 1000000)
		{
			return Std.string(Std.int(num / 1000000)) + ' million';
		}
		else if (num >= 1000)
		{
			return Std.string(Util.round(num / 1000, 3)) + ' thousand';
		}
		return Std.string(num);
	}

	/**
	 * formats a time in seconds to "DD:HH:MM:SS" for easier reading
	 * @param time Time (in seconds)
	 * @return Formatted time
	 */
	public static function formatTime(time:Float):String
	{
		var hours:Int = Std.int(time / 3600);
		var minutes:Int = Std.int(time / 60);
		var seconds:Int = Std.int(time % 60);
		var secondsString:String = '';
		if (seconds < 10)
			secondsString = '0';
		if (hours > 0)
			return '$hours:$minutes:$secondsString$seconds';
		else if (minutes > 0)
			return '$minutes:$secondsString$seconds';
		return '0:$secondsString$seconds';
	}

	/**
	 * Checks if a file exists in the filesystem
	 * @param path Full path to the file
	 * @return True if the file exists, false if it doesn't
	 */
	inline public static function fileExists(path:String):Bool
	{
		return Assets.exists(path);
	}

	#if desktop
	/**
	 * Writes data to a file (DESKTOP ONLY)
	 * @param path Path to the file to write to
	 * @param data Data to write to the file
	 */
	inline public static function writeToFile(path:String, data:String):Void
	{
		sys.io.File.saveContent(path, data);
	}

	/**
	 * Deletes a file (DESKTOP ONLY)
	 * @param path Path to the file to delete
	 */
	inline public static function deleteFile(path:String):Void
	{
		sys.FileSystem.deleteFile(path);
	}
	#end
}
