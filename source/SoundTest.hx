package;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class SoundTest extends FlxState
{
	var bufferText:FlxText;

	var validCodes:Array<String> = ['NEIL', 'RCM'];
	var allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	var buffer:String = '';

	override public function create()
	{
		super.create();

		var text:FlxText = new FlxText(0, 0, FlxG.width, "SOUND MODDED TEST");
		text.setFormat(Util.font("comic-sans", "bold"), 26, 0xFFFFFFFF, "center");
		text.y = 10;
		add(text);

		var enterText:FlxText = new FlxText(0, 0, FlxG.width, "Please Enter Valid Code!");
		enterText.setFormat(null, 16, 0xFFFFFFFF, "center");
		enterText.y = 50;
		add(enterText);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		#if discord_rpc
		DiscordHandler.changePresence('SPOILERS :)', "SoundTest");
		#end

		if (FlxG.keys.firstJustPressed() != FlxKey.NONE) // thx psych engine
		{
			var keyPressed:FlxKey = FlxG.keys.firstJustPressed();
			var keyName:String = Std.string(keyPressed);
			if (allowedKeys.contains(keyName))
			{
				buffer += keyName;
				if (buffer.length >= 32)
					buffer = buffer.substring(1);

				for (wordRaw in validCodes)
				{
					var word:String = wordRaw.toUpperCase(); // just for being sure you're doing it right
					if (buffer.contains(word))
					{
						// trace('YOOO! ' + word);
						switch (word)
						{
							case 'RCM':
								Util.openURL("https://youtu.be/_x3Ftu6iZq0");
						}
						resetCode();
					}
				}
			}
		}

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new PlayState());
	}

	/**
	 * Resets the inputted secret code buffer.
	 */
	function resetCode()
	{
		buffer = '';
	}
}
