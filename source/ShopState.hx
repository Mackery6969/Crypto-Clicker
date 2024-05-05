package;

import flixel.FlxState;

class ShopState extends FlxState
{
	override public function create()
	{
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		#if discord_rpc
		DiscordRPC.update('In the shop\nBuying stuff with $' + PlayState.money, 'ShopState');
		#end
	}
}
