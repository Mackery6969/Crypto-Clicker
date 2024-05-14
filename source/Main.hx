package;

import GJLogin;
import ClientPrefs;
import ShowFPS;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: PlayState, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};

	public function new()
	{
		super();
		addChild(new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate,
			game.skipSplash, game.startFullscreen));

		if (ClientPrefs.showFPS)
			addChild(new ShowFPS(10, 3, 0xFFFFFF));

		#if desktop
		var apiKey:String = Sys.getEnv('GAMEJOLT_API_KEY');
        
        if (apiKey == null) {
            // Fallback or handle the error, e.g., throw an exception or use a mock key
            trace('API key not found! Ensure GAMEJOLT_API_KEY is set.');
            apiKey = "development-key"; // Use a dummy key or handle appropriately
        }

		ClientPrefs.privateKey = apiKey;
		if (ClientPrefs.privateKey == "development-key")
			ClientPrefs.privateKey = ""; // Clear the key if it's the dummy key to prevent misuse

		//GJLogin.connect();
		#end

		#if html5
		ClientPrefs.fullscreen = true;
		ClientPrefs.autoPause = false;

		FlxG.mouse.visible = true;
		#end

		#if discord_rpc
		DiscordHandler.initialize();
		#end

		trace(PlayState.discordClient);

		if (ClientPrefs.reloadRequired)
		{
			ClientPrefs.reloadRequired = false;
			trace("Reload no longer needed!");
		}
	}
}
