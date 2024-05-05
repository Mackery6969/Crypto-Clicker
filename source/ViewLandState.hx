package;

import LandOptionsState;
import flixel.FlxObject;

class Land
{
	public var y:Int;
	public var x:Int;
	public var selected:Bool;
	public var type:String;
	public var owned:Bool;
	public var cost:Float;
	public var sellPrice:Float;
	public var building:String;

	public function new(y:Int, x:Int, selected:Bool, type:String, owned:Bool, cost:Float, sellPrice:Float, building:String)
	{
		this.y = y;
		this.x = x;
		this.selected = selected;
		this.type = type;
		this.owned = owned;
		this.building = building;
	}
}

class ViewLandState extends FlxState
{
	// a grid system of 18x18 tiles, player gets tile x 9 and y 9 free
	// you can buy tiles for 100 dollars each
	// you can sell tiles for 50 dollars each
	// you can add buildings thats in your inventory to the tiles to make them generate money for you
	// you can buy tiles in all 8 directions from your claimed ones
	var bgGradient:FlxSprite;
	var gridOne:FlxSprite;
	var gridHeight:Float;
	var gridWidth:Float;
	var numScrollingGridsX:Int;
	var numScrollingGridsY:Int;
	var scrollingGrids:Array<FlxSprite>;

	var scrollSpeed:Float = 25;

	public static var lands:Array<Land>;

	var selectedOutline:FlxSprite;

	public static var curSelectedLand:Land;

	var landMinPrice:Float = 100;
	var landMaxPrice:Float = 1000;

	var landSellMinPrice:Float = 50;
	var landSellMaxPrice:Float = 500;

	public static var ownedLand:Int = 0;

	static var songPosition:Float = 0;

	override public function create()
	{
		ClientPrefs.loadSettings();

		super.create();

		// add background
		bgGradient = new FlxSprite(0, 0, Util.image("bgGradient"));
		// fit to the screen
		bgGradient.scale.set(FlxG.width / bgGradient.width * 2, FlxG.height / bgGradient.height * 4);
		// bgGradient.y = -bgGradient.height + FlxG.height;
		bgGradient.y = -400;
		bgGradient.antialiasing = ClientPrefs.antialiasing;
		bgGradient.scrollFactor.set(0, 0);
		add(bgGradient);

		// add gridOne
		gridOne = new FlxSprite(0, 0, Util.image("LuigiGrid"));
		// gridOne.scale.set(0.5, 0.5);
		gridOne.antialiasing = ClientPrefs.antialiasing;
		gridOne.alpha = 0.5;
		gridOne.scrollFactor.set(0, 0);
		add(gridOne);

		// Create a temporary sprite to load the image and get its dimensions
		var tempSprite = new FlxSprite();
		tempSprite.loadGraphic(Util.image("LuigiGrid"), false, false);
		gridHeight = tempSprite.height;
		gridWidth = tempSprite.width;

		// Calculate the number of grids needed to fill the screen
		numScrollingGridsY = Math.ceil(FlxG.height / gridHeight) + 1;
		numScrollingGridsX = Math.ceil(FlxG.width / gridWidth) + 1;

		// Create and position the grid sprites
		scrollingGrids = new Array<FlxSprite>();
		for (i in 0...numScrollingGridsY)
		{
			for (j in 0...numScrollingGridsX)
			{
				var grid = new FlxSprite();
				grid.loadGraphic(Util.image("LuigiGrid"), false, false);
				grid.x = -gridWidth * j;
				grid.y = -gridHeight * i;
				grid.antialiasing = ClientPrefs.antialiasing;
				grid.scrollFactor.set(0, 0);

				// Add the grid to the display list and the scrollingGrids array
				add(grid);
				scrollingGrids.push(grid);
			}
		}

		// adds a red background as a border behind the tiles
		var bg = new FlxSprite(171, 171);
		bg.makeGraphic(64 * 19, 64 * 19, 0xffff0000);
		// position the background to be 5 pixels away from the outer tiles
		bg.x = -31;
		bg.y = -31;
		add(bg);

		// create a grid of 18x18 tiles
		// check if the land isnt already saved or not (to prevent overwriting the save file)
		if (lands == null)
		{
			lands = [];
			for (y in 0...18)
			{
				for (x in 0...18)
				{
					var land = new Land(y, x, false, "land", false, Math.floor(Math.random() * (landMaxPrice - landMinPrice) + landMaxPrice),
						Math.floor(Math.random() * (landSellMaxPrice - landSellMinPrice) + landSellMaxPrice), "");
					lands.push(land);
				}
			}
		}

		// set the center tile to be owned by the player
		lands[9 * 18 + 9].owned = true;
		lands[9 * 18 + 9].selected = true;
		lands[9 * 18 + 9].sellPrice = 0;

		// create a grid of 18x18 sprites
		for (y in 0...18)
		{
			for (x in 0...18)
			{
				var land = lands[y * 18 + x];
				var sprite = new FlxSprite(x * 64, y * 64);
				sprite.makeGraphic(64, 64, 0xff00ff00);
				add(sprite);
			}
		}

		// create a grid of 18x18 text
		// text says if the land is owned or not
		for (y in 0...18)
		{
			for (x in 0...18)
			{
				var land = lands[y * 18 + x];
				var text = new FlxText(x * 64, y * 64, 64, land.owned ? "owned" : "not owned");
				text.font = Util.font("comic-sans");
				text.color = 0xff000000;
				add(text);
			}
		}

		// initialize the selected outline
		selectedOutline = new FlxSprite(171 + 64, 171 + 64, Util.image("selectionBox"));
		// selectedOutline.scale.set(18, 18);
		add(selectedOutline);

		// if curSelectedLand is null, set it to the center tile
		if (curSelectedLand == null)
		{
			curSelectedLand = lands[9 * 18 + 9];
		}
		else
		{
			// if curSelectedLand is not null, find it in the lands array
			// and set it to the found land
			for (land in lands)
			{
				if (land.x == curSelectedLand.x && land.y == curSelectedLand.y)
				{
					curSelectedLand = land;
				}
			}
		}

		if (ClientPrefs.music && FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Util.music("AtlasEarth"), 0.5, true);
			FlxG.sound.music.play();
			if (songPosition != 0)
				FlxG.sound.music.time = songPosition;
		}

		// update owned land count
		for (land in lands)
		{
			if (land.owned)
			{
				ownedLand++;
			}
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		#if discord_rpc
		DiscordHandler.changePresence("Using Atlas Earth\n" + ownedLand + ' / ' + lands.length + ' tiles owned', "ViewLandState");
		#end

		/*
			if (FlxG.sound.music != null && !FlxG.sound.music.active && ClientPrefs.music)
				FlxG.sound.playMusic(Util.music("AtlasEarth"), 0.5);
		 */

		for (tile in scrollingGrids)
		{
			tile.x -= scrollSpeed * elapsed;
			tile.y += scrollSpeed * elapsed;

			// If the tile has gone off the bottom or left of the screen, move it back to the top right
			if (tile.y >= FlxG.height)
			{
				tile.y -= tile.height * numScrollingGridsY;
			}
			if (tile.x <= -tile.width)
			{
				tile.x += tile.width * numScrollingGridsX;
			}
		}

		// check if the player clicks on a tile
		// opens a sub menu where the player can choose to buy/sell a tile
		// if its bought they can add a building to it
		// if its sold the building is removed

		// mark land thats clicked on as selected (and unselect the previous one)
		if (FlxG.mouse.justPressed)
		{
			for (y in 0...18)
			{
				for (x in 0...18)
				{
					var land = lands[y * 18 + x];
					if (FlxG.mouse.x >= x * 64 && FlxG.mouse.x < (x + 1) * 64 && FlxG.mouse.y >= y * 64 && FlxG.mouse.y < (y + 1) * 64)
					{
						for (land in lands)
						{
							land.selected = false;
						}
						land.selected = true;
						curSelectedLand = land;
					}
				}
			}
		}

		// center the camera on currently selected land (slowly move it there) with a smooth camera movement
		var point:FlxPoint = new FlxPoint(curSelectedLand.x * 64 + 32, curSelectedLand.y * 64 + 32);
		FlxG.camera.focusOn(point);

		// highlight the selected land with a red outline
		for (y in 0...18)
		{
			for (x in 0...18)
			{
				var land = lands[y * 18 + x];
				if (land.selected)
				{
					selectedOutline.x = x * 64;
					selectedOutline.y = y * 64;
				}
			}
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			/*
				var sound = FlxG.sound.play(Util.sound("click"), 0.5);
				if (ClientPrefs.sound)
				{
					// add sound var so we can wait for the sound to finish playing
					sound.play();
				}
				// wait for the sound to finish playing
				// then switch to the play state
				if (sound.finished)
				{
					if (FlxG.sound.music != null)
					{
						songPosition = FlxG.sound.music.time;
						FlxG.sound.music.pause();
					}
					FlxG.switchState(new PlayState());
				}
			 */
			if (FlxG.sound.music != null)
			{
				songPosition = FlxG.sound.music.time;
				FlxG.sound.music.stop();
				FlxG.sound.music = null;
			}
			FlxG.switchState(new PlayState());
		}

		if (FlxG.keys.justPressed.SPACE)
		{
			// save the current selected land
			// switch to the land options state
			FlxG.switchState(new LandOptionsState(curSelectedLand));
		}

		// move the selected land with the arrow keys
		/*
			if (FlxG.keys.justPressed.LEFT)
			{
				if (curSelectedLand.x > 0)
				{
					curSelectedLand = lands[curSelectedLand.y * 18 + curSelectedLand.x - 1];
				}
			}
			if (FlxG.keys.justPressed.RIGHT)
			{
				if (curSelectedLand.x < 17)
				{
					curSelectedLand = lands[curSelectedLand.y * 18 + curSelectedLand.x + 1];
				}
			}
			if (FlxG.keys.justPressed.UP)
			{
				if (curSelectedLand.y > 0)
				{
					curSelectedLand = lands[(curSelectedLand.y - 1) * 18 + curSelectedLand.x];
				}
			}
			if (FlxG.keys.justPressed.DOWN)
			{
				if (curSelectedLand.y < 17)
				{
					curSelectedLand = lands[(curSelectedLand.y + 1) * 18 + curSelectedLand.x];
				}
			}
		 */

		// save the lands array to the save file
		ClientPrefs.saveSettings();
	} // buy land

	public static function buyLand(land:Land)
	{
		land.owned = true;
		ClientPrefs.saveSettings();

		// update the text on the land
		/*
			for (y in 0...18) {
				for (x in 0...18) {
					var text = new FlxText(x * 64, y * 64, 64, land.owned ? "owned" : "not owned");
					add(text);
				}
			}
		 */

		if (ClientPrefs.sound)
			FlxG.sound.play(Util.sound("buy"), 0.5);
	}

	function updateSelection()
	{
		selectedOutline.x = curSelectedLand.x * 64;
		selectedOutline.y = curSelectedLand.y * 64;
	}
}
