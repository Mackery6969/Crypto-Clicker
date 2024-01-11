package;

import PlayState;
import Upgrade;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class ShopState extends FlxState
{
	var background:FlxSprite;
	var backButton:FlxButton;

	override public function create()
	{
		super.create();

		background = new FlxSprite(0, 0).loadGraphic(Util.image('ui/LuigiGrid'));
		background.scrollFactor.set(0, 0);
		background.scale.set(2, 2);
		add(background);

		// make the top title
		var title:FlxText = new FlxText(0, 20, FlxG.width, "Shop");
		title.setFormat(null, 16, 0xFFFFFFFF, "center");
		add(title);

		// make the back button
		backButton = new FlxButton(0, FlxG.height - 350, "Back", function()
		{
			FlxG.switchState(new PlayState());
		});
		add(backButton);

		// Add upgrades here
		addUpgrade('Half Dollar', {
			name: 'Half Dollar',
			description: '+0.25 money when quarter clicked',
			cost: 5.0
		});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		background.x += 0.5;
		background.y += 0.5;
		if (background.x >= FlxG.width)
			background.x = 0;
		if (background.y >= FlxG.height)
			background.y = 0;

		#if discord_rpc
		// update discord rpc
		DiscordHandler.changePresence('In the Shop');
		#end
	}

	public static function addUpgrade(name:String, data:Upgrade):Void
	{
		if (!isUpgradeAlreadyAdded(data))
		{
			// Declare upgrade outside the FlxButton constructor
			var upgrade:FlxButton;

			// Create an upgrade button
			// Check the condition before adding the upgrade
			if (checkCondition(data))
			{
				upgrade = new FlxButton(100, 0, name, function()
				{
					PlayState.cookies -= data.cost;
					FlxG.save.data.cookies -= data.cost;
					PlayState.upgrades.push(data);
					PlayState.saveUpgrades(); // Save upgrades after a purchase
					trace("Upgrade purchased:", data.name);
					PlayState.upgradeApply();
					FlxG.state.remove(upgrade); // Remove the upgrade from the state
				});

				// Calculate the y position based on the index and spacing
				var spacing:Float = 10.0; // Adjust the spacing as needed
				var yOffset:Float = FlxG.height / 2 - (PlayState.upgrades.length * (upgrade.height + spacing)) / 2;
				// Update the position of the upgrade button
				upgrade.y = yOffset;

				// remove the upgrade if its already bought
				FlxG.state.add(upgrade);
			}
		}
	}

	// Add a function to check the condition for an upgrade
	private static function checkCondition(data:Upgrade):Bool
	{
		// Add your condition here
		// For example, you might check if the player has a certain amount of cookies
		return data.cost > 0.0; // Adjust the condition based on your needs
	}

	private static function isUpgradeAlreadyAdded(data:Upgrade):Bool
	{
		// Check if the upgrade is already in the upgrades array
		for (upgrade in PlayState.upgrades)
		{
			if (upgrade.name == data.name)
			{
				return true; // Upgrade is already added
			}
		}
		return false; // Upgrade is not in the array
	}
}
