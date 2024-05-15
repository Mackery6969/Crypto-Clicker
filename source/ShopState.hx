package;

import flixel.FlxState;
import Background;

class ShopState extends FlxState
{

	var background:Background;
	override public function create()
	{
		super.create();

		background = new Background();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		#if discord_rpc
		DiscordHandler.changePresence('In the shop\nBuying stuff with $' + PlayState.money, 'ShopState');
		#end
	}
}
