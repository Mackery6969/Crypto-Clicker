package;

/* undertale like fight, only option that works is Fight. */

import flixel.ui.FlxBar;

class KilidoorBossState extends FlxState
{

    var kilidoor:FlxSprite;
    var kilidoorHP:Int = 200;
    var kilidoorMaxHP:Int = 200;
    var kilidoorHPText:FlxText;
    var kilidoorHPBar:FlxBar;

    var playerHP:Int = 20;
    var playerMaxHP:Int = 20;
    var playerHPText:FlxText;
    var playerHPBar:FlxBar;
    var dialogueText:FlxText;

    var fightButton:FlxButton;
    var actButton:FlxButton;
    var itemButton:FlxButton;
    var mercyButton:FlxButton;

    var loopStatic:Bool = false;
    var noiseStatic:FlxSprite;
    var staticSound:FlxSound;
    var staticLoopSound:FlxSound;

    override public function create()
    {
        super.create();

        kilidoor = new FlxSprite(0, 0);
        kilidoor.frames = Util.sparrowAtlas('battle/kilidoor');
        // welcome to animation hell
        kilidoor.animation.addByPrefix('normal', "idler", 24, false);
        kilidoor.animation.addByPrefix('laugh', "XD", 24, false);
        kilidoor.animation.addByPrefix('smug', ">:3", 24, false);
        kilidoor.animation.addByPrefix('smile', ":)", 24, false);
        kilidoor.animation.addByPrefix('angry', "anger", 24, false);
        kilidoor.animation.addByPrefix('error', "error", 24, false);
        kilidoor.animation.addByPrefix('sad', "sad", 24, false);
        kilidoor.animation.addByPrefix(':P', ":P", 24, false);
        kilidoor.animation.play('normal');
        // animation hell is over... for now
        kilidoor.antialiasing = false;
        kilidoor.x = FlxG.width / 2 - kilidoor.width / 2;
        kilidoor.y = FlxG.height / 2 - kilidoor.height / 2;
        add(kilidoor);

        kilidoorHPBar = new FlxBar(0, 0, LEFT_TO_RIGHT, 100, 10, kilidoor, "health", 0, kilidoorMaxHP, true);
        kilidoorHPBar.createFilledBar(0xff00ff00, 0xffA9A9A9);
        kilidoorHPBar.x = FlxG.width / 2 - kilidoorHPBar.width / 2;
        // bar is 10 pixels above kilidoor
        kilidoorHPBar.y = kilidoor.y - 10 - kilidoorHPBar.height;
        add(kilidoorHPBar);

        kilidoorHPText = new FlxText(0, 0, 100, kilidoorHP + "/" + kilidoorMaxHP);
        kilidoorHPText.size = 16;
        kilidoorHPText.color = 0xffffffff;
        // text is inside the bar
        kilidoorHPText.x = kilidoorHPBar.x + kilidoorHPBar.width / 2 - kilidoorHPText.width / 2;
        kilidoorHPText.y = kilidoorHPBar.y + kilidoorHPBar.height / 2 - kilidoorHPText.height / 2;
        add(kilidoorHPText);

        fightButton = new FlxButton(0, 0, "Fight", function() { killKilidoor(); });
        fightButton.x = FlxG.width / 2 - fightButton.width / 2;
        fightButton.y = FlxG.height - 10 - fightButton.height;
        add(fightButton);

        actButton = new FlxButton(0, 0, "Act", function() { glitchedOptions(); });
        actButton.x = FlxG.width / 2 - actButton.width / 2;
        actButton.y = fightButton.y - 10 - actButton.height;
        add(actButton);

        itemButton = new FlxButton(0, 0, "Item", function() { glitchedOptions(); });
        itemButton.x = FlxG.width / 2 - itemButton.width / 2;
        itemButton.y = actButton.y - 10 - itemButton.height;
        add(itemButton);

        mercyButton = new FlxButton(0, 0, "Mercy", function() { glitchedOptions(); });
        mercyButton.x = FlxG.width / 2 - mercyButton.width / 2;
        mercyButton.y = itemButton.y - 10 - mercyButton.height;
        add(mercyButton);

        playerHPBar = new FlxBar(0, 0, LEFT_TO_RIGHT, 100, 10, this, "playerHP", 0, playerMaxHP, true);
        playerHPBar.createFilledBar(0xff00ff00, 0xffA9A9A9);
        playerHPBar.x = FlxG.width / 2 - playerHPBar.width / 2;
        playerHPBar.y = mercyButton.y - 15 - playerHPBar.height;
        add(playerHPBar);

        playerHPText = new FlxText(0, 0, 100, playerHP + "/" + playerMaxHP);
        playerHPText.size = 16;
        playerHPText.color = 0xffffffff;
        playerHPText.x = playerHPBar.x + playerHPBar.width / 2 - playerHPText.width / 2;
        playerHPText.y = playerHPBar.y + playerHPBar.height / 2 - playerHPText.height / 2;
        add(playerHPText);

        dialogueText = new FlxText(0, 0, FlxG.width, "Kilidoor: Hello, I am Kilidoor.");
        dialogueText.size = 16;
        dialogueText.color = 0xffffffff;
        dialogueText.alignment = CENTER;
        dialogueText.y = playerHPBar.y - 50 - dialogueText.height;
        add(dialogueText);

        // flxtimer to make the dialogue text disappear after 5 seconds
        (new FlxTimer()).start(5, function(timer:FlxTimer) { dialogueText.visible = false; });

        noiseStatic = new FlxSprite(0, 0);
        noiseStatic.frames = Util.sparrowAtlas('static');
        noiseStatic.animation.addByPrefix('static', "static", 24, true);
        noiseStatic.animation.play('static');
        noiseStatic.antialiasing = false;
        noiseStatic.scale.set(5, 5);
        noiseStatic.alpha = 0.2;
        add(noiseStatic);

        staticSound = new FlxSound();
        staticSound.loadEmbedded(Util.sound("static"), false);

        staticLoopSound = new FlxSound();
        staticLoopSound.loadEmbedded(Util.sound("staticloop"), true);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (kilidoorHP <= 0)
        {
            kilidoor.kill();
            kilidoorHPBar.kill();
            kilidoorHPText.kill();
            // kilidoor is dead, player wins

            // make the dialogue text say something else
            dialogueText.text = "YOU WON!\nyou got 0 exp and 1 gold.";
            dialogueText.visible = true;

            // flxtimer to make the dialogue text disappear after 5 seconds
            PlayState.kilidoorDefeated = true;
            PlayState.money += 1;
            ClientPrefs.saveSettings();
            (new FlxTimer()).start(5, function(timer:FlxTimer) {
                noiseStatic.alpha = 1;
                loopStatic = true;
                (new FlxTimer()).start(1, function(timer:FlxTimer) {
                    loopStatic = false;
                    FlxG.switchState(new PlayState());
                });
            });
        }

        if (loopStatic) {
            // play static sound and when its done play staticloop
            staticSound.play();
            if (!staticSound.playing && !staticLoopSound.playing) {
                staticLoopSound.play();
            }
        } else {
            staticSound.stop();
            staticLoopSound.stop();
        }
    }

    function glitchedOptions()
    {
        if (!loopStatic) {
            noiseStatic.alpha = 1;
            loopStatic = true;
            #if desktop
            Util.error("ERROR\nPLEASE TRY AGAIN LATER.", "...");
            #else
            trace("no");
            #end
            (new FlxTimer()).start(5, function(timer:FlxTimer) {
                loopStatic = false;
                noiseStatic.alpha = 0.2;
            });
        }
    }

    function killKilidoor()
    {
        if (!loopStatic)
            kilidoorHP = 0;
    }
}