package;

import ClientPrefs;
import PlayState;
import flixel.FlxState;

class SettingsState extends FlxState
{
	var backArrow:FlxSprite;
	var fpsMenu:Bool = false;
	var fpsBox:FlxSprite;
	var fpsMenuText:FlxText;

	var fps:Int = 60;
	var showFPS:Bool = false;
	var reloadRequired:Bool = false;

	override public function create()
	{
		fps = ClientPrefs.framerate;
		showFPS = ClientPrefs.showFPS;

		super.create();

		backArrow = new FlxSprite(0, 0, Util.image("Arrow_Back_L"));
		backArrow.scale.set(0.8, 0.8);
		add(backArrow);

		var title = new FlxText(0, 0, FlxG.width, "Settings");
		title.size = 24;
		title.alignment = "center";
		add(title);

		var changesDoneText = new FlxText(0, 0, FlxG.width, "Changes have been made!");

		var musicText = new FlxText(0, 0, FlxG.width, "Music: ON");
		musicText.size = 16;
		musicText.alignment = "center";
		musicText.y = FlxG.height / 2 - musicText.height / 2 - 250;
		musicText.x = FlxG.width / 2 - musicText.width / 2 - 400;
		if (!ClientPrefs.music)
		{
			musicText.text = "Music: OFF";
		}
		add(musicText);

		var musicButton = new FlxButton(0, 0, function()
		{
			ClientPrefs.music = !ClientPrefs.music;
			if (ClientPrefs.music)
			{
				musicText.text = "Music: ON";
			}
			else
			{
				musicText.text = "Music: OFF";
			}
		});
		musicButton.y = musicText.y + musicText.height + 10;
		musicButton.x = FlxG.width / 2 - musicButton.width / 2 - 400;
		add(musicButton);

		var soundText = new FlxText(0, 0, FlxG.width, "Sound: ON");
		soundText.size = 16;
		soundText.alignment = "center";
		soundText.y = FlxG.height / 2 - soundText.height / 2 - 250;
		soundText.x = FlxG.width / 2 - soundText.width / 2 - 200;
		if (!ClientPrefs.sound)
		{
			soundText.text = "Sound: OFF";
		}
		add(soundText);

		var soundButton = new FlxButton(0, 0, function()
		{
			ClientPrefs.sound = !ClientPrefs.sound;
			if (ClientPrefs.sound)
			{
				soundText.text = "Sound: ON";
			}
			else
			{
				soundText.text = "Sound: OFF";
			}
		});
		soundButton.y = soundText.y + soundText.height + 10;
		soundButton.x = FlxG.width / 2 - soundButton.width / 2 - 200;
		add(soundButton);

		var fullscreenText = new FlxText(0, 0, FlxG.width, "Fullscreen: FALSE");
		fullscreenText.size = 16;
		fullscreenText.alignment = "center";
		fullscreenText.y = FlxG.height / 2 - fullscreenText.height / 2 - 250;
		fullscreenText.x = FlxG.width / 2 - fullscreenText.width / 2;
		if (ClientPrefs.fullscreen)
		{
			fullscreenText.text = "Fullscreen: TRUE";
		}
		add(fullscreenText);

		var fullscreenButton = new FlxButton(0, 0, function()
		{
			ClientPrefs.fullscreen = !ClientPrefs.fullscreen;
			if (ClientPrefs.fullscreen)
			{
				fullscreenText.text = "Fullscreen: TRUE";
			}
			else
			{
				fullscreenText.text = "Fullscreen: FALSE";
			}
		});
		fullscreenButton.y = fullscreenText.y + fullscreenText.height + 10;
		fullscreenButton.x = FlxG.width / 2 - fullscreenButton.width / 2;
		add(fullscreenButton);

		var reducedMotionText = new FlxText(0, 0, FlxG.width, "Reduced Motion: FALSE");
		reducedMotionText.size = 16;
		reducedMotionText.alignment = "center";
		reducedMotionText.y = FlxG.height / 2 - reducedMotionText.height / 2 - 250;
		reducedMotionText.x = FlxG.width / 2 - reducedMotionText.width / 2 + 200;
		if (ClientPrefs.reducedMotion)
		{
			reducedMotionText.text = "Reduced Motion: TRUE";
		}
		add(reducedMotionText);

		var reducedMotionButton = new FlxButton(0, 0, function()
		{
			ClientPrefs.reducedMotion = !ClientPrefs.reducedMotion;
			if (ClientPrefs.reducedMotion)
			{
				reducedMotionText.text = "Reduced Motion: TRUE";
			}
			else
			{
				reducedMotionText.text = "Reduced Motion: FALSE";
			}
		});
		reducedMotionButton.y = reducedMotionText.y + reducedMotionText.height + 10;
		reducedMotionButton.x = FlxG.width / 2 - reducedMotionButton.width / 2 + 200;
		add(reducedMotionButton);

		var showFPSText = new FlxText(0, 0, FlxG.width, "Show FPS: FALSE");
		showFPSText.size = 16;
		showFPSText.alignment = "center";
		showFPSText.y = FlxG.height / 2 - showFPSText.height / 2 - 250;
		showFPSText.x = FlxG.width / 2 - showFPSText.width / 2 + 400;
		if (ClientPrefs.showFPS)
		{
			showFPSText.text = "Show FPS: TRUE";
		}
		add(showFPSText);

		var showFPSButton = new FlxButton(0, 0, function()
		{
			ClientPrefs.showFPS = !ClientPrefs.showFPS;
			if (ClientPrefs.showFPS)
			{
				showFPSText.text = "Show FPS: TRUE";
			}
			else
			{
				showFPSText.text = "Show FPS: FALSE";
			}
			// check if it has changed from its previous value
		});
		showFPSButton.y = showFPSText.y + showFPSText.height + 10;
		showFPSButton.x = FlxG.width / 2 - showFPSButton.width / 2 + 400;
		add(showFPSButton);

		var flashingText = new FlxText(0, 0, FlxG.width, "Flashing Lights: TRUE");
		flashingText.size = 16;
		flashingText.alignment = "center";
		flashingText.y = FlxG.height / 2 - flashingText.height / 2 - 150;
		flashingText.x = FlxG.width / 2 - flashingText.width / 2 - 400;
		if (!ClientPrefs.flashing)
		{
			flashingText.text = "Flashing Lights: FALSE";
		}
		add(flashingText);

		var flashingButton = new FlxButton(0, 0, function()
		{
			ClientPrefs.flashing = !ClientPrefs.flashing;
			if (ClientPrefs.flashing)
			{
				flashingText.text = "Flashing Lights: TRUE";
			}
			else
			{
				flashingText.text = "Flashing Lights: FALSE";
			}
		});
		flashingButton.y = flashingText.y + flashingText.height + 10;
		flashingButton.x = FlxG.width / 2 - flashingButton.width / 2 - 400;
		add(flashingButton);

		var framerateText = new FlxText(0, 0, FlxG.width, "Set Framerate");
		framerateText.size = 16;
		framerateText.alignment = "center";
		framerateText.y = FlxG.height / 2 - framerateText.height / 2 - 150;
		framerateText.x = FlxG.width / 2 - framerateText.width / 2 - 200;
		add(framerateText);

		var framerateButton = new FlxButton(0, 0, function()
		{
			displayFPSMenu();
		});
		framerateButton.y = framerateText.y + framerateText.height + 10;
		framerateButton.x = FlxG.width / 2 - framerateButton.width / 2 - 200;
		add(framerateButton);

		var antianaliasingText = new FlxText(0, 0, FlxG.width, "Antialiasing: TRUE");
		antianaliasingText.size = 16;
		antianaliasingText.alignment = "center";
		antianaliasingText.y = FlxG.height / 2 - antianaliasingText.height / 2 - 150;
		antianaliasingText.x = FlxG.width / 2 - antianaliasingText.width / 2;
		if (!ClientPrefs.antialiasing)
		{
			antianaliasingText.text = "Antialiasing: FALSE";
		}
		add(antianaliasingText);

		var antianaliasingButton = new FlxButton(0, 0, function()
		{
			ClientPrefs.antialiasing = !ClientPrefs.antialiasing;
			if (ClientPrefs.antialiasing)
			{
				antianaliasingText.text = "Antialiasing: TRUE";
			}
			else
			{
				antianaliasingText.text = "Antialiasing: FALSE";
			}
		});
		antianaliasingButton.y = antianaliasingText.y + antianaliasingText.height + 10;
		antianaliasingButton.x = FlxG.width / 2 - antianaliasingButton.width / 2;
		add(antianaliasingButton);

		var autoPauseText = new FlxText(0, 0, FlxG.width, "Auto Pause: TRUE");
		autoPauseText.size = 16;
		autoPauseText.alignment = "center";
		autoPauseText.y = FlxG.height / 2 - autoPauseText.height / 2 - 150;
		autoPauseText.x = FlxG.width / 2 - autoPauseText.width / 2 + 200;
		if (!ClientPrefs.autoPause)
		{
			autoPauseText.text = "Auto Pause: FALSE";
		}
		add(autoPauseText);

		var autoPauseButton = new FlxButton(0, 0, function()
		{
			ClientPrefs.autoPause = !ClientPrefs.autoPause;
			if (ClientPrefs.autoPause)
			{
				autoPauseText.text = "Auto Pause: TRUE";
			}
			else
			{
				autoPauseText.text = "Auto Pause: FALSE";
			}
		});
		autoPauseButton.y = autoPauseText.y + autoPauseText.height + 10;
		autoPauseButton.x = FlxG.width / 2 - autoPauseButton.width / 2 + 200;
		add(autoPauseButton);

		var resetSettingsText = new FlxText(0, 0, FlxG.width, "Reset Settings");
		resetSettingsText.size = 18;
		resetSettingsText.alignment = "center";
		// position at bottom right corner leaving space for the button + reset game save button
		resetSettingsText.y = FlxG.height / 2 - resetSettingsText.height / 2 + 300;
		resetSettingsText.x = FlxG.width / 2 - resetSettingsText.width / 2 + 320;
		add(resetSettingsText);

		var resetSettingsButton = new FlxButton(0, 0, function()
		{
			trace("Resetting Settings...");
			ClientPrefs.resetSettings("settings");
			FlxG.switchState(new SettingsState());
		});
		resetSettingsButton.y = resetSettingsText.y + resetSettingsText.height + 10;
		resetSettingsButton.x = FlxG.width / 2 - resetSettingsButton.width / 2 + 320;
		add(resetSettingsButton);

		var resetGameSaveText = new FlxText(0, 0, FlxG.width, "Reset Game Save");
		resetGameSaveText.size = 18;
		resetGameSaveText.alignment = "center";
		// position at bottom right corner leaving space for the button1
		resetGameSaveText.y = FlxG.height / 2 - resetGameSaveText.height / 2 + 300;
		resetGameSaveText.x = FlxG.width / 2 - resetSettingsText.width / 2 + 520;
		add(resetGameSaveText);

		var resetGameSaveButton = new FlxButton(0, 0, function()
		{
			trace("Resetting Game Data...");
			ClientPrefs.resetSettings("game");
			FlxG.switchState(new SettingsState());
		});
		resetGameSaveButton.y = resetGameSaveText.y + resetGameSaveText.height + 10;
		resetGameSaveButton.x = FlxG.width / 2 - resetGameSaveButton.width / 2 + 520;
		add(resetGameSaveButton);

		// for the fps menu
		// add grey box infront of the game
		fpsBox = new FlxSprite(0, 0);
		fpsBox.makeGraphic(FlxG.width, FlxG.height, 0x88000000);
		fpsBox.visible = false;
		fpsBox.alpha = 0.9;
		add(fpsBox);

		// add text
		fpsMenuText = new FlxText(0, 0, FlxG.width, "Set FPS (60-200): " + fps);
		fpsMenuText.setFormat(null, 16, 0xFFFFFFFF, "center");
		// position at center of box
		fpsMenuText.y = (FlxG.height - fpsMenuText.height) / 2;
		fpsMenuText.visible = false;
		add(fpsMenuText);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.justPressed || FlxG.keys.justPressed.ESCAPE)
		{
			if (FlxG.mouse.x >= backArrow.x
				&& FlxG.mouse.x <= backArrow.x + backArrow.width
				&& FlxG.mouse.y >= backArrow.y
				&& FlxG.mouse.y <= backArrow.y + backArrow.height)
			{
				ClientPrefs.saveSettings();
				trace("Settings Saved!");
				FlxG.switchState(new PlayState());
			}
		}

		if (fpsMenu)
		{
			if (FlxG.keys.justPressed.ENTER)
			{
				ClientPrefs.setFPS(fps);
				fpsMenu = false;
				closeFPSMenu();

				trace("FPS Set to: " + fps);
			}
			else if (FlxG.keys.justPressed.ESCAPE)
			{
				if (fpsMenu)
				{
					fpsMenu = false;
					closeFPSMenu();

					trace("FPS Unchanged");
					fps = ClientPrefs.framerate;
				}
				else
				{
					ClientPrefs.saveSettings();
					trace("Settings Saved!");
					FlxG.switchState(new PlayState());
				}
			}
			else if (FlxG.keys.justPressed.LEFT)
			{
				if (fps > 60)
					fps -= 10;
			}
			else if (FlxG.keys.justPressed.RIGHT)
			{
				if (fps < 200)
					fps += 10;
			}
		}
		fpsMenuText.text = "Set FPS (60-200): " + fps;
	}

	function displayFPSMenu()
	{
		trace("Displaying FPS Menu");
		fpsMenu = true;

		fpsBox.visible = true;
		fpsMenuText.visible = true;
	}

	function closeFPSMenu()
	{
		trace("Closing FPS Menu");
		fpsBox.visible = false;
		fpsMenuText.visible = false;
	}
}
