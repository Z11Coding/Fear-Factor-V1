package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;
	var warnText:FlxText;
	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"A newer version of this mod is available.\nWould you like to update?\n(ENTER for yes, ESC for no.)",
			32);
		warnText.setFormat(Paths.font('comboFont.ttf'), 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			//leftState = true;
			#if windows FlxG.switchState(new UpdateState());
			#else
			CoolUtil.browserLoad("https://github.com/Z11Coding/Fear-Factor-V1/releases/");
			#end
		}
		else if(controls.BACK) {
			leftState = true;
		}

		if(leftState)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxTween.tween(warnText, {alpha: 0}, 1, {
				onComplete: function (twn:FlxTween) {
					MusicBeatState.switchState(new MainMenuState());
				}
			});
		}
		super.update(elapsed);
	}
}