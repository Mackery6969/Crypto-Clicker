package;

// fps counter in the top right corner
import external.fabric.engine.Utilities;
import external.memory.Memory;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
	@author 504brandon
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class ShowFPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		autoSize = LEFT;
		defaultTextFormat = new TextFormat("_sans", 12, color);
		text = "FPS: ";

		cacheCount = 0;
		currentTime = 0;
		times = [];
	}

	var textLength:Int = 0;

	// Event Handlers

	@:noCompletion
	private override function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);

		if (currentCount != cacheCount /*&& visible*/)
		{
			text = '${currentFPS}FPS\n${Utilities.format_bytes(Memory.getCurrentUsage())} / ${Utilities.format_bytes(Memory.getPeakUsage())}';

			textLength = text.length;
		}

		cacheCount = currentCount;
	}
}
