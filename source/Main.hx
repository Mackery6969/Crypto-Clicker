package;

import PlayState;
import flixel.FlxGame;
import openfl.Assets;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var discordClient:String;

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, PlayState));

		discordClient = Assets.getText(Util.txt('data/discord'));

		#if discord_rpc
		DiscordHandler.initialize();
		#end

		trace(discordClient);
	}
}
