package;

#if desktop
import flixel.addons.ui.FlxUIInputText;
import tentools.api.FlxGameJolt as GJApi;
import flixel.addons.ui.FlxUIState;
import openfl.display.Sprite;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.display.BitmapData;
import openfl.text.TextField;
import openfl.display.Bitmap;
import openfl.text.TextFormat;
import openfl.Lib;

class GJLogin extends FlxState {
    var backArrow:FlxSprite;
    var typeUsername:FlxUIInputText;
    var typeToken:FlxUIInputText;

    public static var loggedIn:Bool = false;

    var login:FlxButton;
    var logout:FlxButton;

    public static function getUserInfo(username:Bool = true):String
    {
        if(username)return GJApi.username;
        else return GJApi.usertoken;
    }

    public static function getStatus():Bool
    {
        return loggedIn;
    }

    override public function create() {
        var title:FlxText = new FlxText(0, 16, FlxG.width, "GameJolt Login");
        title.setFormat(null, 16, 0xffffff, "center");
        title.font = Util.font("comic-sans", "bold");
        add(title);

        backArrow = new FlxSprite(0, 0, Util.image("Arrow_Back_L"));
		backArrow.scale.set(0.6, 0.6);
		add(backArrow);
        
        // username is a text input field that extends to the width of the screen and is 24 pixels high at y = 64
        typeUsername = new FlxUIInputText(16, 96, FlxG.width - 32, ClientPrefs.username, 16, 0xff000000, 0xffffffff);
        //typeUsername.font = Util.font("comic-sans");
        add(typeUsername);

        // token is a text input field that extends to the width of the screen and is 24 pixels high at y = 96
        typeToken = new FlxUIInputText(16, 128, FlxG.width - 32, ClientPrefs.token, 16, 0xff000000, 0xffffffff);
        //typeToken.font = Util.font("comic-sans");
        add(typeToken);

        trace(GJApi.initialized);
        
        login = new FlxButton(16, 160, "Login", function() {
            trace("Logging in...");
            trace("Username: " + typeUsername.text);
            trace("Token: " + typeToken.text);
            authDaUser(ClientPrefs.username, ClientPrefs.token, true);
        });

        logout = new FlxButton(16, 160, "Logout", function() {
            deAuthDaUser();
        });

        if (getStatus()) {
            add(logout);
        } else {
            add(login);
        }
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        typeUsername.update(elapsed);
        typeToken.update(elapsed);

        ClientPrefs.username = typeUsername.text;
        ClientPrefs.token = typeToken.text;
        ClientPrefs.saveSettings();

        if (FlxG.keys.justPressed.ESCAPE) {
            FlxG.switchState(new PlayState());
        }

        if (FlxG.mouse.justPressed) {
            if (FlxG.mouse.x >= backArrow.x && FlxG.mouse.x <= backArrow.x + backArrow.width && FlxG.mouse.y >= backArrow.y && FlxG.mouse.y <= backArrow.y + backArrow.height) {
                FlxG.switchState(new PlayState());
            }
        }
    }

    public static function connect() 
    {
        trace("Grabbing API keys...");
        GJApi.init(Std.int(ClientPrefs.gjGameID), Std.string(ClientPrefs.privateKey), function(data:Bool){
            #if debug
            //Main.gjToastManager.createToast(GameJoltInfo.imagePath, "Game " + (data ? "authenticated!" : "not authenticated..."), (!data ? "If you are a developer, check GJKeys.hx\nMake sure the id and key are formatted correctly!" : "Yay!"), false);
            #end
        });
    }

    public static function authDaUser(in1, in2, ?loginArg:Bool = false)
    {
        if(!loggedIn)
        {
            GJApi.authUser(in1, in2, function(v:Bool)
            {
                trace("user: "+(in1 == "" ? "n/a" : in1));
                trace("token: "+in2);
                if(v)
                    {
                        //Main.gjToastManager.createToast(GameJoltInfo.imagePath, in1 + " SIGNED IN!", "CONNECTED TO GAMEJOLT", false);
                        trace("User authenticated!");
                        FlxG.save.data.gjUser = in1;
                        FlxG.save.data.gjToken = in2;
                        FlxG.save.flush();
                        loggedIn = true;
                        startSession();
                        if(loginArg)
                        {
                            //GameJoltLogin.login=true;
                            //FlxG.switchState(new GameJoltLogin());
                        }
                    }
                else 
                    {
                        if(loginArg)
                        {
                            //GameJoltLogin.login=true;
                            //FlxG.switchState(new GameJoltLogin());
                        }
                        //Main.gjToastManager.createToast(GameJoltInfo.imagePath, "Not signed in!\nSign in to save GameJolt Trophies and Leaderboard Scores!", "", false);
                        trace("User login failure!");
                        // FlxG.switchState(new GameJoltLogin());
                    }
            });
        }
    }

    public static function deAuthDaUser()
    {
        closeSession();
        loggedIn = false;
        trace(FlxG.save.data.gjUser + FlxG.save.data.gjToken);
        FlxG.save.data.gjUser = "";
        FlxG.save.data.gjToken = "";
        FlxG.save.flush();
        trace(FlxG.save.data.gjUser + FlxG.save.data.gjToken);
        trace("Logged out!");
        //Sys.exit(0);
    }

    /**
     * Give a trophy!
     * @param trophyID Trophy ID. Check your game's API settings for trophy IDs.
     */
    public static function getTrophy(trophyID:Int) /* Awards a trophy to the user! */
    {
        if(loggedIn)
        {
            GJApi.addTrophy(trophyID, function(data:Map<String,String>){
                trace(data);
                var bool:Bool = false;
                if (data.exists("message"))
                    bool = true;
            });
        }
    }

    /**
     * Checks a trophy to see if it was collected
     * @param id TrophyID
     * @return Bool (True for achieved, false for unachieved)
     */
    public static function checkTrophy(id:Int):Bool
    {
        var value:Bool = false;
        GJApi.fetchTrophy(id, function(data:Map<String, String>)
            {
                trace(data);
                if (data.get("achieved").toString() != "false")
                    value = true;
                trace(id+""+value);
            });
        return value;
    }

    public static function pullTrophy(?id:Int):Map<String,String>
    {
        var returnable:Map<String,String> = null;
        GJApi.fetchTrophy(id, function(data:Map<String,String>){
            trace(data);
            returnable = data;
        });
        return returnable;
    }

    /**
     * Add a score to a table!
     * @param score Score of the song. **Can only be an int value!**
     * @param tableID ID of the table you want to add the score to!
     * @param extraData (Optional) You could put accuracy or any other details here!
     */
    public static function addScore(score:Int, tableID:Int, ?extraData:String)
    {
        trace("Trying to add a score");
        var formData:String = extraData.split(" ").join("%20");
        GJApi.addScore(score+"%20Points", score, tableID, false, null, formData, function(data:Map<String, String>){
            trace("Score submitted with a result of: " + data.get("success"));
            //Main.gjToastManager.createToast(GameJoltInfo.imagePath, "Score submitted!", "Score: " + score + "\nExtra Data: "+extraData, true);
        });
    }

    /**
     * Return the highest score from a table!
     * 
     * Usable by pulling the data from the map by [function].get();
     * 
     * Values returned in the map: score, sort, user_id, user, extra_data, stored, guest, success
     * 
     * @param tableID The table you want to pull from
     * @return Map<String,String>
     */
    public static function pullHighScore(tableID:Int):Map<String,String>
    {
        var returnable:Map<String,String>;
        GJApi.fetchScore(tableID,1, function(data:Map<String,String>){
            trace(data);
            returnable = data;
        });
        return returnable;
    }

    /**
     * Inline function to start the session. Shouldn't be used out of GameJoltAPI
     * Starts the session
     */
    public static function startSession()
    {
        GJApi.openSession(function()
        {
            trace("Session started!");
            new FlxTimer().start(20, function(tmr:FlxTimer){pingSession();}, 0);
        });
    }

    /**
     * Tells GameJolt that you are still active!
     * Called every 20 seconds by a loop in startSession().
     */
    public static function pingSession()
    {
        GJApi.pingSession(true, function(){trace("Ping!");});
    }

    /**
     * Closes the session, used for signing out
     */
    public static function closeSession()
    {
        GJApi.closeSession(function(){trace('Closed out the session');});
    }
}
    
class GameJoltInfo extends FlxSubState
{    
    /**
     * Variable to change which state to go to by hitting ESCAPE or the CONTINUE buttons.
     */
    /**
    * Inline variable to change the font for the GameJolt API elements.
    * @param font You can change the font by doing **Paths.font([Name of your font file])** or by listing your file path.
    * If *null*, will default to the normal font.
    */
    public static var font:String = Util.font("comic-sans"); /* Example: Paths.font("vcr.ttf"); */
    /**
    * Inline variable to change the font for the notifications made by Firubii.
    * 
    * Don't make it a NULL variable. Worst mistake of my life.
    */
    public static var fontPath:String = "assets/fonts/comic-sans.ttf";
    /**
    * Image to show for notifications. Leave NULL for no image, it's all good :)
    * 
    * Example: Paths.getLibraryPath("images/stepmania-icon.png")
    */
    public static var imagePath:String = null; 

    /* Other things that shouldn't be messed with are below this line! */

    /**
    * GameJolt + FNF version.
    */
    public static var version:String = "1.1";
    /**
     * Random quotes I got from other people. Nothing more, nothing less. Just for funny.
     */
}
#end