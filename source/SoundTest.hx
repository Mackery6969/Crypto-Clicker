package;

import KilidoorBossState;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class SoundTest extends FlxState
{
	var bufferText:FlxText;

	var validCodes:Array<String> = ['KILDARE', 'NEIL', 'RCM'];
	var allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	var buffer:String = '';

	override public function create()
	{
		super.create();

		var text:FlxText = new FlxText(0, 0, FlxG.width, "SOUND MODDED TEST");
		text.setFormat(null, 26, 0xFFFFFFFF, "center");
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
							case 'KILDARE':
								// FlxG.sound.music.stop();
								#if debug
								FlxG.switchState(new KilidoorBossState());
								#else
								if (!PlayState.kilidoorDefeated)
								{
									FlxG.switchState(new KilidoorBossState());
								}
								else
								{
									trace("Kilidoor already defeated");
								}
								#end
							case 'RCM':
								if (!PlayState.kilidoorDefeated)
								{
									Util.openURL("https://youtu.be/_x3Ftu6iZq0");
								}
								else
								{
									Util.openURL("https://www.youtube.com/channel/UCPHqigpuJLO6dWC0hzpBBTA");
								}
						}
						resetCode();
					}
				}
			}
		}

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new PlayState());
	}

	function resetCode()
	{
		buffer = '';
	}
}
