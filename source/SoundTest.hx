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

		bufferText = new FlxText(0, 0, FlxG.width, buffer);
		bufferText.setFormat(null, 8, 0xFFFFFFFF, "center");
		bufferText.y = 70;
		add(bufferText);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		bufferText.text = buffer;

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
								FlxG.sound.music.stop();
								#if debug
								#if desktop
								Util.error("all you players are the same", "you all want the same thing");
								Util.error("you want to be the best", "you want to be the best");
								Util.error("I wont let you do that", "fight me");
								#end
								FlxG.switchState(new KilidoorBossState());
								#else
								if (!PlayState.kilidoorDefeated)
								{
									#if desktop
									Util.error("all you players are the same", "you all want the same thing");
									Util.error("you want to be the best", "you want to be the best");
									Util.error("I wont let you do that", "fight me");
									#end
									FlxG.switchState(new KilidoorBossState());
								}
								else
								{
									#if desktop
									Util.error("Sound, Sound! Somethings up with killdare!", "Please.");
									#end
								}
								#end
							case 'NEIL':
								#if desktop
								Util.error("Im not ready yet.", "Try Again Another Update..");
								#end
							case 'RCM':
								if (!PlayState.kilidoorDefeated)
								{
									Util.openURL("https://youtu.be/_x3Ftu6iZq0");
								}
								else
								{
									Util.openURL("https://www.youtube.com/channel/UCPHqigpuJLO6dWC0hzpBBTA");
									#if desktop
									Util.error("I'm not continuing this yet.", "check again another update.");
									#end
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
