package;

import flixel.FlxObject;
import LandOptionsState;

class Land {
    public var y:Int;
    public var x:Int;
    public var selected:Bool;
    public var type:String;
    public var owned:Bool;
    public var cost:Float;
    public var sellPrice:Float;
    public var building:String;

    public function new(y:Int, x:Int, selected:Bool, type:String, owned:Bool, cost:Float, sellPrice:Float, building:String) {
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

    public static var lands:Array<Land>;
    var selectedOutline:FlxSprite;
    public static var curSelectedLand:Land;

    var landMinPrice:Float = 100;
    var landMaxPrice:Float = 1000;

    var landSellMinPrice:Float = 50;
    var landSellMaxPrice:Float = 500;

    override public function create() {
        ClientPrefs.loadSettings();

        super.create();

        // add background
		bgGradient = new FlxSprite(0, 0, Util.image("bgGradient"));
		// fit to the screen
		bgGradient.scale.set(FlxG.width / bgGradient.width * 2, FlxG.height / bgGradient.height * 4);
		//bgGradient.y = -bgGradient.height + FlxG.height;
		bgGradient.y = -400;
		bgGradient.antialiasing = ClientPrefs.antialiasing;
		add(bgGradient);

        // create a grid of 18x18 tiles
        // check if the land isnt already saved or not (to prevent overwriting the save file)
        if (lands == null) {
            lands = [];
            for (y in 0...18) {
                for (x in 0...18) {
                    var land = new Land(y, x, false, "land", false, Math.floor(Math.random() * (landMaxPrice - landMinPrice) + landMaxPrice), Math.floor(Math.random() * (landSellMaxPrice - landSellMinPrice) + landSellMaxPrice), "");
                    lands.push(land);
                }
            }
        }
        
        // set the center tile to be owned by the player
        lands[9 * 18 + 9].owned = true;
        lands[9 * 18 + 9].selected = true;
        lands[9 * 18 + 9].sellPrice = 0;

        // create a grid of 18x18 sprites
        for (y in 0...18) {
            for (x in 0...18) {
                var land = lands[y * 18 + x];
                var sprite = new FlxSprite(x * 64, y * 64);
                sprite.makeGraphic(64, 64, 0xff00ff00);
                add(sprite);
            }
        }

        // create a grid of 18x18 text
        // text says if the land is owned or not
        for (y in 0...18) {
            for (x in 0...18) {
                var land = lands[y * 18 + x];
                var text = new FlxText(x * 64, y * 64, 64, land.owned ? "owned" : "not owned");
                add(text);
            }
        }

        // initialize the selected outline
        selectedOutline = new FlxSprite(171 + 64, 171 + 64);
        selectedOutline.makeGraphic(64, 64, 0xffff0000);
        selectedOutline.alpha = 0.5;
        add(selectedOutline);

        // if curSelectedLand is null, set it to the center tile
        if (curSelectedLand == null) {
            curSelectedLand = lands[9 * 18 + 9];
        }
        else
        {
            // if curSelectedLand is not null, find it in the lands array
            // and set it to the found land
            for (land in lands) {
                if (land.x == curSelectedLand.x && land.y == curSelectedLand.y) {
                    curSelectedLand = land;
                }
            }
        
        }
    }
    
    override public function update(elapsed:Float) {
        super.update(elapsed);

        // check if the player clicks on a tile
        // opens a sub menu where the player can choose to buy/sell a tile
        // if its bought they can add a building to it
        // if its sold the building is removed
        
        // mark land thats clicked on as selected (and unselect the previous one)
        if (FlxG.mouse.justPressed) {
            for (y in 0...18) {
                for (x in 0...18) {
                    var land = lands[y * 18 + x];
                    if (FlxG.mouse.x >= x * 64 && FlxG.mouse.x < (x + 1) * 64 && FlxG.mouse.y >= y * 64 && FlxG.mouse.y < (y + 1) * 64) {
                        for (land in lands) {
                            land.selected = false;
                        }
                        land.selected = true;
                        curSelectedLand = land;
                    }
                }
            }
        }

        // center the camera on currently selected land (slowly move it there)
        for (y in 0...18) {
            for (x in 0...18) {
                var land = lands[y * 18 + x];
                if (land.selected) {
                    FlxG.camera.focusOn(new FlxPoint(x * 64, y * 64));
                }
            }
        }

        // highlight the selected land with a red outline
        for (y in 0...18) {
            for (x in 0...18) {
                var land = lands[y * 18 + x];
                if (land.selected) {
                    selectedOutline.x = x * 64;
                    selectedOutline.y = y * 64;
                }
            }
        }

        if (FlxG.keys.justPressed.ESCAPE) {
            FlxG.switchState(new PlayState());
        }

        if (FlxG.keys.justPressed.SPACE) {
            // save the current selected land
            // switch to the land options state
            FlxG.switchState(new LandOptionsState(curSelectedLand));
        }

        // save the lands array to the save file
        ClientPrefs.saveSettings();
    }

    // buy land
    public static function buyLand(land:Land) {
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
    }
}