import ClientPrefs;
import PlayState;
import ShowFPS;
#if desktop
import GJLogin;
#end
import Util;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
//import external.flixel.addons.ui.FlxInputText;
//import external.flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUI;

// import important states/classes
// import sys
using StringTools;

#if desktop
import Sys;
#end
#if discord_rpc
import DiscordHandler;
#end
// hcodec
#if hxCodec
import hxcodec.flixel.FlxVideo;
#end

/*
	#if sys
	import js.io.File;
	#else
	import haxe.io.Path;
	#end
 */
