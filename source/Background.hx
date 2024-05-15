package;

/**
 * Globally used background(s) for the game.
 * @author Mackery
 */
class Background extends FlxGroup
{
    var gridHeight:Float;
    var gridWidth:Float;
    var numScrollingGridsX:Int;
    var numScrollingGridsY:Int;
    var scrollSpeed:Float = 25;
    var scrollingGrids:Array<FlxSprite>;
    var gridOne:FlxSprite;
    var bgGradient:FlxSprite;

    public function new() {
        super();

        // Create a temporary sprite to load the image and get its dimensions
        var tempSprite = new FlxSprite();
        tempSprite.loadGraphic(Util.image("LuigiGrid"), false, false);
		tempSprite.scrollFactor.set(0, 0); // just to be sure it loads correctly
        gridHeight = tempSprite.height;
        gridWidth = tempSprite.width;

        // Calculate the number of grids needed to fill the screen
        numScrollingGridsY = Math.ceil(FlxG.height / gridHeight) + 1;
        numScrollingGridsX = Math.ceil(FlxG.width / gridWidth) + 1;

        // Create and position the grid sprites
        scrollingGrids = new Array<FlxSprite>();
        for (i in 0...numScrollingGridsY) {
            for (j in 0...numScrollingGridsX) {
                var grid = new FlxSprite();
                grid.loadGraphic(Util.image("LuigiGrid"), false, false);
                grid.x = -gridWidth * j;
                grid.y = -gridHeight * i;
                grid.alpha = 0.9;
				grid.scrollFactor.set(0, 0);
                grid.antialiasing = ClientPrefs.antialiasing;

                // Add the grid to the display list and the scrollingGrids array
                add(grid);
                scrollingGrids.push(grid);
            }
        }

        // Add gridOne
        gridOne = new FlxSprite(0, 0, Util.image("LuigiGrid"));
        gridOne.antialiasing = ClientPrefs.antialiasing;
        gridOne.alpha = 0.5;
		gridOne.scrollFactor.set(0, 0);
        add(gridOne);

        // Add background
        bgGradient = new FlxSprite(0, 0, Util.image("bgGradient"));
        bgGradient.scale.set(FlxG.width / bgGradient.width * 2, FlxG.height / bgGradient.height * 4);
        bgGradient.y = -400;
		bgGradient.scrollFactor.set(0, 0);
        bgGradient.antialiasing = ClientPrefs.antialiasing;
        add(bgGradient);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // Scroll each tile diagonally across the screen
        if (!ClientPrefs.reducedMotion) {
            for (tile in scrollingGrids) {
                tile.x += scrollSpeed * elapsed;
                tile.y += scrollSpeed * elapsed;

                // If the tile has gone off the bottom or left of the screen, move it back to the top right
                if (tile.y >= FlxG.height) {
                    tile.y -= tile.height * numScrollingGridsY;
                }
                if (tile.x >= FlxG.width) {
                    tile.x -= tile.width * numScrollingGridsX;
                }
            }
        }
    }
}
