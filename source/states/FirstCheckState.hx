package states;
import backend.Highscore;
import backend.Achievements;
import backend.util.WindowUtil;
import flixel.input.keyboard.FlxKey;
import states.UpdateState;
import flixel.ui.FlxBar;
import openfl.system.System;
import lime.app.Application;
import openfl.filters.BitmapFilter;
class FirstCheckState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];
	public static var filters:Array<BitmapFilter> = [];
	public static var updateVersion:String = '';

	var updateAlphabet:Alphabet;
	var updateIcon:FlxSprite;
	var updateRibbon:FlxSprite;

	override public function create()
	{
		FlxG.mouse.visible = false;

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		WindowUtil.initWindowEvents();
		WindowUtil.disableCrashHandler();
		FlxSprite.defaultAntialiasing = true;

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		ClientPrefs.loadPrefs();
		ClientPrefs.reloadVolumeKeys();

		Language.reloadPhrases();

		if(ClientPrefs.data.shaders){
			filters.push(shaders.ShadersHandler.greyscale);
		}

		Cursor.cursorMode = Default;
		Cursor.show();

		super.create();

		updateRibbon = new FlxSprite(0, FlxG.height - 75).makeGraphic(FlxG.width, 75, 0x88FFFFFF, true);
		updateRibbon.visible = false;
		updateRibbon.alpha = 0;
		add(updateRibbon);

		updateIcon = new FlxSprite(FlxG.width - 75, FlxG.height - 75);
		updateIcon.frames = Paths.getSparrowAtlas("pauseAlt/bfLol", "shared");
		updateIcon.animation.addByPrefix("dance", "funnyThing instance 1", 20, true);
		updateIcon.animation.play("dance");
		updateIcon.setGraphicSize(65);
		updateIcon.updateHitbox();
		updateIcon.antialiasing = true;
		updateIcon.visible = false;
		add(updateIcon);

		updateAlphabet = new ColoredAlphabet(0, 0, "Checking Your Vibe...", true, FlxColor.WHITE);
		for(c in updateAlphabet.members) {
			c.scale.x /= 2;
			c.scale.y /= 2;
			c.updateHitbox();
			c.x /= 2;
			c.y /= 2;
		}
		updateAlphabet.visible = false;
		updateAlphabet.x = updateIcon.x - updateAlphabet.width - 10;
		updateAlphabet.y = updateIcon.y;
		add(updateAlphabet);
		updateIcon.y += 15;

		var tmr = new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			trace('checking for update');
			var http = new haxe.Http("https://raw.githubusercontent.com/Z11Coding/Vs.-Z11-Mixtape-Madness/refs/heads/main/gitVersion.txt");

			http.onData = function(data:String)
			{
				updateVersion = data.split('\n')[0].trim();
				var curVersion:String = MainMenuState.mixtapeEngineVersion.trim();
				trace('version online: ' + updateVersion + ', your version: ' + curVersion);
				if (updateVersion != curVersion)
				{
					trace('versions arent matching!');
					MusicBeatState.switchState(new states.OutdatedState());
				}
				else
				{
					openSubState(new substates.PromptPsych("Enable Modcharts?\n(This can be changed in the settings menu later.)", 
						function() {
							ClientPrefs.data.modcharts = true;
							FlxG.switchState(new states.CacheState());
						},
						function() {
							ClientPrefs.data.modcharts = false;
							FlxG.switchState(new states.CacheState());
						},
						"Yes",
						"No"
					));
				}
			}

			http.onError = function(error)
			{
				trace('error: $error');
				updateAlphabet.text = 'Failed the vibe check!';
				updateAlphabet.color = FlxColor.RED;
				updateIcon.visible = false;
				FlxTween.tween(updateAlphabet, {alpha: 0}, 2, {ease:FlxEase.sineOut});
				FlxTween.tween(updateIcon, {alpha: 0}, 2, {ease:FlxEase.sineOut});
				new FlxTimer().start(2, function(tmr:FlxTimer)
				{
					openSubState(new substates.PromptPsych("Enable Modcharts?\n(This can be changed in the settings menu later.)", 
						function() {
							ClientPrefs.data.modcharts = true;
							FlxG.switchState(new states.CacheState());
						},
						function() {
							ClientPrefs.data.modcharts = false;
							FlxG.switchState(new states.CacheState());
						},
						"Yes",
						"No"
					));
				});
			}

			http.request();
			updateIcon.visible = true;
			updateAlphabet.visible = true;
			updateRibbon.visible = true;
			updateRibbon.alpha = 1;
		});
	}
}