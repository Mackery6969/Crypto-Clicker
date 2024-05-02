package;

import ViewLandState;

class LandOptionsState extends FlxState
{
	// a menu the player can open after pressing SPACE in ViewLandState on land, the selected land is passed to this state
	private var land:Land;
	var bgGradient:FlxSprite;

	public function new(land:Land)
	{
		super();
		this.land = land;
	}

	override public function create()
	{
		ClientPrefs.loadSettings(); // just in case

		super.create();

		if (ClientPrefs.sound)
			FlxG.sound.play(Util.sound("click"), 0.5); // open sound

		// add background
		bgGradient = new FlxSprite(0, 0, Util.image("bgGradient"));
		// fit to the screen
		bgGradient.scale.set(FlxG.width / bgGradient.width * 2, FlxG.height / bgGradient.height * 4);
		// bgGradient.y = -bgGradient.height + FlxG.height;
		bgGradient.y = -400;
		bgGradient.antialiasing = ClientPrefs.antialiasing;
		add(bgGradient);

		var buyLandButton:FlxButton = new FlxButton(0, 0, "Buy", function()
		{
			#if debug
			if (!land.owned)
			{
				PlayState.money -= land.cost;
				ViewLandState.buyLand(land);
				if (ClientPrefs.sound)
					FlxG.sound.play(Util.sound("buy"), 0.5);
				trace("land x" + land.x + " y" + land.y + " bought");
				exitState();
			}
			#else
			if (!land.owned && PlayState.money >= land.cost)
			{
				PlayState.money -= land.cost;
				ViewLandState.buyLand(land);
				if (ClientPrefs.sound)
					FlxG.sound.play(Util.sound("buy"), 0.5);
				trace("land x" + land.x + " y" + land.y + " bought");
				exitState();
			}
			#end
		});
		if (!land.owned)
			add(buyLandButton);

		var sellLandButton:FlxButton = new FlxButton(0, 0, "Sell", function()
		{
			if (land.owned)
			{
				PlayState.money += land.cost;
				land.owned = false;
				FlxG.switchState(new ViewLandState());
			}
		});
		if (land.owned)
			add(sellLandButton);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.SPACE)
		{
			if (ClientPrefs.sound)
				FlxG.sound.play(Util.sound("buy"), 0.5);
			exitState();
		}
	}

	private function exitState()
	{
		ClientPrefs.saveSettings();
		ViewLandState.curSelectedLand = land;
		FlxG.switchState(new ViewLandState());
	}
}
