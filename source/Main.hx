package;

import PlayState;
import flixel.FlxGame;
import openfl.Assets;
import openfl.display.Sprite;
import lime.app.Application;
import openfl.Lib;
import openfl.events.Event;
import flixel.graphics.FlxGraphic;
import sys.FileSystem;
import sys.io.File;

#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
#end

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

		if (!ClientPrefs.startedBefore)
			setupGame();
	}

	private function setupGame():Void
	{
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;

		#if discord_rpc
		DiscordHandler.prepare();
		#end

		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end

		ClientPrefs.startedBefore = true;
	}

	#if CRASH_HANDLER
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "./crash/" + "CryptoClicker_" + dateNow + ".txt";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "UH OH!\nUncaught Error: " + e.error + "\nPlease report this error to the GitHub page: https://github.com/Mackery6969/Crypto-Luigi-Clicker\n\n> Crash Handler written by: sqirra-rng";

		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		Application.current.window.alert(errMsg, "Error!");
		DiscordHandler.shutdown();
		Sys.exit(1);
	}
	#end
}
