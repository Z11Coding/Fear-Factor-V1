package;

import yutautil.save.FuncEmbed;
import backend.modules.SyncUtils;
import states.editors.content.Prompt;
import flixel.graphics.FlxGraphic;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import lime.app.Application;
import states.FirstCheckState;
import backend.AudioSwitchFix;
import backend.FunkinRatioScaleMode;
import backend.MemoryCounter;
import haxe.ui.Toolkit;
// import backend.ImageCache;
import backend.JSONCache;
import openfl.events.NativeProcessExitEvent;
import psychlua.*;
import StateMap; #if linux import lime.graphics.Image; #end
// crash handler stuff
#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end
// Gamejolt
import backend.gamejolt.GameJolt;
import backend.gamejolt.GameJolt.GJToastManager;
import backend.debug.FPSCounter;
import backend.window.WindowUtils;

#if desktop
import backend.ALSoftConfig; // Just to make sure DCE doesn't remove this, since it's not directly referenced anywhere else.
#end

// @:headerCode('#include <windows.h>')

#if linux
@:cppInclude('./external/gamemode_client.h')
@:cppFileCode('
	#define GAMEMODE_AUTO
')
#end
class Main extends Sprite
{
	public static var demoMode:Bool = false;
	var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: #if UNDERTALE undertale.BATTLEFIELD #else /*backend.TestState*/ states.FirstCheckState #end, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};

	public static var cmdArgs:Array<String> = Sys.args();
	public static var noTerminalColor:Bool = false;
	public static var playTest:Bool = false;
	public static var forceGPUOnlyBitmapsOff:Bool = #if windows false #else true #end;
	public static var closing:Bool = false;
	public static var eDate:ExtendedDate;

	// public var initStuff = game;
	public static var fpsVar:FPSCounter;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		var a = yutautil.MetaData;
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();
		trace(game);
		// Credits to MAJigsaw77 (he's the og author for this code)
		#if android
		Sys.setCwd(Path.addTrailingSlash(Context.getExternalFilesDir()));
		#elseif ios
		Sys.setCwd(lime.system.System.applicationStorageDirectory);
		#end
		if (stage != null)
		{
			backend.Threader.runInThread(init(), 'init');
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		#if VIDEOS_ALLOWED
		hxvlc.util.Handle.init();
		#end
	}

	@:dox(hide)
	public static var audioDisconnected:Bool = false;
	public static var changeID:Int = 0;
	public static var scaleMode:FunkinRatioScaleMode;
	public static var skipNextDump:Bool = false;

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		// var testThing:FCTInput<Int> = 3;
		// trace("Test thing: " + testThing);

		// archipelago.APEntryState.installAPWorld();
		trace(FuncEmbed.functionToString(function() { return "Hello, world!"; }));
		trace(FuncEmbed.runFunctionFromString(FuncEmbed.functionToString(function() { return "Hello, world!"; }), this));
		trace(FuncEmbed.functionToString(Main.dummy, true));
		trace(FuncEmbed.runFunctionFromString(FuncEmbed.functionToString(function() {
			trace("This is a test function.");
		}), this, true));
		setupGame();
	}



	public static function dumpObject(graphic:FlxGraphic)
	{
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null)
			{
				if (obj == graphic)
				{
					Assets.cache.removeBitmapData(key);
					FlxG.bitmap._cache.remove(key);
					obj.destroy();
					break;
				}
			}
		}
	}

	// Gamejolt
	public static var gjToastManager:GJToastManager;

	// taken from forever engine, cuz optimization very pog.
	// thank you shubs :)
	public static function dumpCache()
	{
		///* SPECIAL THANKS TO HAYA
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null)
			{
				Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
		}
		Assets.cache.clear("songs");
		// */
	}

	private function setupGame():Void
	{
		// trace(StateCollector.collectStates());
		// trace(StateCollector.collectFlxStates());
		if (cmdArgs.indexOf('check') != -1)
		{
			// kill any running instances of the game
			Sys.command("taskkill /f /im MixEngine.exe");
		}
		backend.window.CppAPI._setWindowLayered();
		backend.window.CppAPI.darkMode();
		backend.window.CppAPI.allowHighDPI();
		backend.window.CppAPI.setOld();
		Paths.crawlDirectory("assets/data", "json", GlobalResources.jsonFilePaths);
		// trace(ChanceSelector.selectMultiple([1, 2, 3, {key: "value"}, [()=>4, ()=>5, ()=>6].map(f -> f()), new Map<String, Int>().set("a", 7)], 3, true).map(v -> switch v { case Array(f): f(); case Map(k, v): k + Std.string(v); case {key: k}: k; case _: Std.string(v); }));
		var mathSolver:MathSolver2 = new MathSolver2();
		var expression:String = Std.string(Std.random(10000)) + " + " + Std.string(Std.random(10000)) + " - " + Std.string(Std.random(10000)) + " * "
			+ Std.string(Std.random(10000)) + " / " + Std.string(Std.random(10000)) + " & " + Std.string(Std.random(10000)) + " + (8 + 8)";
		trace("Expression: " + expression);
		trace("Evaluated Result: " + mathSolver.evaluate(expression));
		// trace(Paths.url("https://cdn.discordapp.com/attachments/631085887467421716/1260066510269845534/loading.xml?ex=668df7e2&is=668ca662&hm=7ff6c46036177698e1b10924bd42724f8636a6e24622a89fb054b00d84038649&"));
		// trace(HoldableVariable.createVariable(FlxG.state).evaluate());
		Toolkit.init();
		Toolkit.theme = 'dark'; // don't be cringe
		backend.Cursor.registerHaxeUICursors();

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}

		#if LUA_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		FlxG.save.bind('FearFactor', CoolUtil.getSavePath());
		yutautil.save.MixSaveWrapper.saveObjectToFile(FlxG.save.data, "save/mixsave.json", true);
		yutautil.save.MixSaveWrapper.saveObjectToFile(init, "save/test.json", true);
		// trace(new yutautil.save.MixSaveWrapper(new yutautil.save.MixSave(), "cache.json").mixSave.content.toArray().length);


		Highscore.load();

		MemoryUtil.init();
		WindowUtils.init();
		var commandPrompt = new CommandPrompt();
		backend.Threader.runInThread(commandPrompt.start());
		#if LUA_ALLOWED Lua.set_callbacks_function(cpp.Callable.fromStaticFunction(psychlua.CallbackHandler.call)); #end
		Controls.instance = new Controls();
		ClientPrefs.loadDefaultKeys();
		#if ACHIEVEMENTS_ALLOWED Achievements.load(); #end
		try
		{
			addChild(new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate,
				game.skipSplash, game.startFullscreen));
		}
		catch (e:haxe.Exception)
		{
			addChild(new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate,
				game.skipSplash, game.startFullscreen));
		}

		ClientPrefs.loadPrefs();
		AudioSwitchFix.init();
		WindowUtils.onClosing = function()
		{
			// if (commandPrompt != null)
			// 	commandPrompt.active = false;
			// commandPrompt = null;
			handleStateBasedClosing();
		}
		FlxGraphic.defaultPersist = false;
		#if !mobile
		fpsVar = new FPSCounter(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		// memoryCounter = new MemoryCounter(10, 3, 0xffffff);
		// addChild(memoryCounter);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		if (fpsVar != null)
		{
			fpsVar.visible = ClientPrefs.data.showFPS;
		}
		#end

		#if linux
		var icon = Image.fromFile("icon.png");
		Lib.current.stage.window.setIcon(icon);
		#end

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end

		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end

		#if DISCORD_ALLOWED
		DiscordClient.prepare();
		#end

		Lib.current.loaderInfo.addEventListener(NativeProcessExitEvent.EXIT, onClosing); // help-
		stage.window.onDropFile.add(function(path:String)
		{
			trace("user dropped file with path: " + path);
			if (currentState() == "ChartingStateOG")
			{
				try{
				backend.Song.loadFromJson(path, '');
				FlxG.resetState();}
				catch(e:haxe.Exception)
				{
					trace("Error loading song: " + e);
				}
			}
		});

		FlxG.signals.gameResized.add(onResize);
		FlxG.signals.preStateSwitch.add(() -> { 
			scaleMode.resetSize();

			if (!Main.skipNextDump) {
				Paths.clearStoredMemory(true);
				FlxG.bitmap.dumpCache();
			}
			MemoryUtil.clearMajor();
		});
		FlxG.signals.postStateSwitch.add(function () {
			Paths.clearUnusedMemory();
			MemoryUtil.clearMajor();
			Main.skipNextDump = false;
		});
		FlxG.scaleMode = scaleMode = new FunkinRatioScaleMode();

		// shader coords fix
		FlxG.signals.gameResized.add(function(w, h)
		{
			if (FlxG.cameras != null)
			{
				for (cam in FlxG.cameras.list)
				{
					if (cam != null && cam.filters != null)
						resetSpriteCache(cam.flashSprite);
				}
			}

			if (FlxG.game != null)
				resetSpriteCache(FlxG.game);
		});

		#if android
		FlxG.android.preventDefaultKeys = [flixel.input.android.FlxAndroidKey.BACK];
		#end

		gjToastManager = new GJToastManager();
		addChild(gjToastManager);
		backend.modules.EvacuateDebugPlugin.initialize();
		backend.modules.ForceCrashPlugin.initialize();
		backend.modules.MemoryGCPlugin.initialize();
		var dummyDate = Date.now();
		eDate = ExtendedDate.fromDate(dummyDate);
		trace("Extended Date: " + eDate);
		trace("Extended Date: " + eDate.asString());
		var test = new HTable<String>(4, 4);
		var test2:Array<HTable<String>> = [];
		test2.push(test);
		trace("Table: " + test2);
		var test3:Map<String, HTable<String>> = new Map<String, HTable<String>>();
		test3.set("test", test);
	}

	public static function dummy():Void
	{
	}

	static function resetSpriteCache(sprite:Sprite):Void
	{
		@:privateAccess {
			sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
		}
	}

	static function onResize(w:Int, h:Int)
	{
		final scale:Float = Math.max(1, Math.min(w / FlxG.width, h / FlxG.height));
		if (fpsVar != null)
		{
			fpsVar.scaleX = fpsVar.scaleY = scale;
		}
		@:privateAccess if (FlxG.cameras != null) for (i in FlxG.cameras.list)
			if (i != null && i.filters != null) resetSpriteCache(i.flashSprite);
		if (FlxG.game != null){
			resetSpriteCache(FlxG.game);
			fixShaderSize(FlxG.game);
		} 

		if (FlxG.cameras == null) return;
		for (cam in FlxG.cameras.list) {
			@:privateAccess
			if (cam != null && (cam._filters != null || cam._filters != []))
				fixShaderSize(cam.flashSprite);
		}	
	}

	static function fixShaderSize(sprite:Sprite) // Shout out to Ne_Eo for bringing this to my attention
	{
		@:privateAccess {
			if (sprite != null)
			{
				sprite.__cacheBitmap = null;
				sprite.__cacheBitmapData = null;
				sprite.__cacheBitmapData2 = null;
				sprite.__cacheBitmapData3 = null;
				sprite.__cacheBitmapColorTransform = null;
			}
		}
	}

	private static function onStateSwitch()
	{
		scaleMode.resetSize();
	}

	public function getFPS():Float
	{
		return fpsCounter.currentFPS;
	}

	public static var memoryCounter:MemoryCounter;

	public static function toggleMem(memEnabled:Bool):Void
	{
		memoryCounter.visible = memEnabled;
	}

	public static var fpsCounter:FPS;

	public static function onClosing(e:Event):Void
	{
		e.preventDefault();
		trace("Closing...");
	}

	public static inline function closeGame():Void
	{
		// if (Main.commandPrompt != null)
		// 	commandPrompt.remove();
		if (!closing) {
		trace("Closing game...");
		closing = true;
		pressedOnce = true;
		trace("Disabling command prompt hook...");
		}
		WindowUtils.preventClosing = false; 

		Lib.application.window.close();

		closeGame();
	}

	public static var pressedOnce:Bool = false;

	public static function currentState(?asStateClass:Bool):Dynamic {
		return asStateClass == true ? Type.getClass(FlxG.state) : Type.getClassName(Type.getClass(FlxG.state)).split(".")[Lambda.count(Type.getClassName(Type.getClass(FlxG.state)).split(".")) - 1];
	}

	public static inline function handleStateBasedClosing() {
		if (!pressedOnce) {
			SyncUtils.wait(() -> TransitionState.currenttransition == null);
			if (WindowUtils.__triedClosing) {
				WindowUtils.preventClosing = true;
				pressedOnce = true;


	
				switch (Type.getClassName(Type.getClass(FlxG.state)).split(".")[Lambda.count(Type.getClassName(Type.getClass(FlxG.state)).split(".")) - 1]) {
					case "ChartingStateOG", "ChartingStatePsych":
						if (currentState() == "ChartingStateOG") {
							FlxG.state.openSubState(new substates.Prompt("Are you sure you want to exit? Your progress will not be saved.", function() {
								new FlxTimer().start(10, function(timer:FlxTimer) {
									if (pressedOnce) {
										MusicBeatState.switchState(new ExitState());
									}
								});
								TransitionState.transitionState(ExitState, {transitionType: "fallRandom", onComplete: function() {}});
							}, function() {
								pressedOnce = false;
							}));
						}
						if (currentState() == "ChartingStatePsych") {
							FlxG.state.openSubState(new states.editors.content.Prompt("Are you sure you want to exit? Your progress will not be saved.", function() {
								new FlxTimer().start(10, function(timer:FlxTimer) {
									if (pressedOnce) {
										MusicBeatState.switchState(new ExitState());
									}
								});
								TransitionState.transitionState(ExitState, {transitionType: "fallRandom", onComplete: function() {}});
							}, function() {
								pressedOnce = false;
							}));
						}
					case "PlayState":
						TransitionState.transitionState(ExitState, {transitionType: "fallRandom", onComplete: function() {}});
						new FlxTimer().start(10, function(timer:FlxTimer) {
							if (pressedOnce) {
								MusicBeatState.switchState(new ExitState());
							}
						});
					default:
						// Default behavior: close the window
						FlxG.autoPause = false;
						TransitionState.transitionState(ExitState, {transitionType: "transparent close"});
						new FlxTimer().start(10, function(timer:FlxTimer) {
							if (pressedOnce) {
								MusicBeatState.switchState(new ExitState());
							}
						});
				}
			}
			// Main.closeGame();
		} //Respectfully, PLEASE DON'T REMOVE MY IMPATIENCE TOGGLE (Otherwise known as this else statement)
		else if (ClientPrefs.data.allowForcedExit) Main.closeGame(); //Trying to be safe here. :3
		//WindowUtils.__triedClosing = false;
		//WindowUtils.preventClosing = true;
		//pressedOnce = false;
	}
	

	// Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
	// very cool person for real they don't get enough credit for their work
	#if CRASH_HANDLER
	public static function onCrash(e:UncaughtErrorEvent):Void
	{
		// Prevent further propagation of the error to avoid crashing the application
		e.preventDefault();
		var errMsg:String = "";
		var errType:String = e.error;
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();
		var crashState:String = Std.string(FlxG.state);

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "./crash/" + "MixtapeEngine_" + dateNow + ".txt";

		if (ClientPrefs.data.ignoreTweenErrors)
			{
				for (stackItem in callStack)
					{
						switch (stackItem)
						{
							case FilePos(s, file, line, column):
								if (file.contains("FlxTween.hx"))
								{
									FlxTween.globalManager.clear();
									// trace(FlxTween.globalManager._tweens);
									trace("Tween Error occurred. Clearing all tweens.");
									return;
								}
			
							default:
								dummy();
						}
					}
			}

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\nUncaught Error: " + e.error;
		errMsg += "\nPlease report this error to the GitHub page: https://github.com/Z11Coding/Mixtape-Engine\n\n> Crash Handler written by: sqirra-rng\n> Crash prevented!";

		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		if (ClientPrefs.data.showCrash)
		{
			Application.current.window.alert(errMsg, "Error!");
		}
		trace("Crash caused in: " + Type.getClassName(Type.getClass(FlxG.state)));

		// Handle different states
		var stateClassName = Type.getClassName(Type.getClass(FlxG.state)).split(".")[Lambda.count(Type.getClassName(Type.getClass(FlxG.state)).split(".")) - 1];
		var stateClass:Class<Dynamic> = Type.getClass(FlxG.state);
		var handled = false;

		while (stateClass != null && !handled) {
			switch (stateClassName) {
				case "PlayState":
					PlayState.Crashed = true;
					if (errType.contains("Null Object Reference")) {
						FlxG.sound.music != null ? FlxG.sound.music.stop() : null;
						FlxG.sound.play(Paths.sound("metal_pipe"));
						if (PlayState.isStoryMode) {
							FlxG.switchState(new states.StoryMenuState());
						} else if (PlayState.CacheMode) {
							FlxG.resetState();
						} else {
							FlxG.switchState(new states.FreeplayState());
						}
						PlayState.Crashed = false;
					}
					handled = true;

				case "ChartingState":
					if (e.error.toLowerCase().contains("null object reference")) {
						Application.current.window.alert("You tried to load a Chart that doesn't exist!", "Chart Error");
					}
					handled = true;

				case "FreeplayState", "StoryModeState":
					FlxG.switchState(new states.CategoryState());
					handled = true;

				case "MainMenuState":
					FlxG.switchState(new states.TitleState());
					handled = true;

				case "TitleState":
					Application.current.window.alert("Something went extremely wrong... You may want to check some things in the files!\nFailed to load TitleState!",
						"Fatal Error");
					trace("Unable to recover...");
					FlxG.switchState(new ExitState());
					handled = true;

				case "CacheState":
					Application.current.window.alert("Major Error occurred while caching data.\nSkipping Cache Operation.", "Fatal Error");
					FlxG.switchState(new states.What());
					handled = true;

				case "What":
					trace("Restarting Game...");
					FlxG.switchState(new states.TitleState());
					handled = true;

				case "OptionsState", "GameJoltState":
					if (Sys.args().indexOf("-livereload") != -1) {
						Sys.println("Cannot restart from compiled build.");
						Application.current.window.alert("The game encountered a critical error.", "Game Bricked");
						Application.current.window.alert("Unable to restart due to running a Compiled build.", "Error");
					} else {
						Application.current.window.alert("The game encountered a critical error and will now restart.", "Game Bricked");
						trace("The game was bricked. Restarting...");
						var mainInstance = new Main();
						var mainGame = mainInstance.game;
						var initialState = Type.getClass(mainGame.initialState);
						var restartProcess = new Process("MixEngine.exe", ["GameJoltBug", "restart"]);
						FlxG.switchState(new ExitState());
					}
					trace("Recommended to recompile the game to fix the issue.");
					handled = true;

				case "ExitState":
					Application.current.window.alert("Somehow, a crash occurred during the exiting process. Forcing exit.", "???");
					trace("Performing Emergency Exit.");
					Main.closeGame();
					handled = true;

				default:
					stateClass = Type.getSuperClass(stateClass);
					stateClassName = stateClass != null ? Type.getClassName(stateClass).split(".")[Lambda.count(Type.getClassName(stateClass).split(".")) - 1] : null;
			}
		}

		if (!handled) {
			var mainInstance = new Main();
			var mainGame = mainInstance.game;
			FlxG.switchState(Type.createInstance(states.TitleState, []));
			trace("Unhandled state: " + (Type.getClassName(Type.getClass(FlxG.state))));
			trace("Restarting Game...");
		}

		// Additional error handling or recovery mechanisms can be added here

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					if (file.contains("FlxTween.hx"))
					{
						FlxTween.globalManager.clear();
						// trace(FlxTween.globalManager._tweens);
						trace("Tween Error occurred. Clearing all tweens.");
					}

				default:
					dummy();
			}
		}
	}
	#end

	public static function simulateMemoryLeak():Void
	{
		var list:Array<Dynamic> = [];
		var cycleCount:Int = 0;
		while (cycleCount < 100)
		{
			// Continuously add large objects to the list without ever clearing it
			var array:Array<Int> = [];
			for (i in 0...1000000)
			{
				array.push(i);
			}
			list.push({data: array});
			cycleCount++;
		}
	}

	public static function simulateCrash():Void
	{
		// Simulate a crash by dividing by zero
		var zero:Int = 0;
		var result:Float = 10 / zero;
	}

	public static function simulateSlowdown():Void
	{
		var cycleCount:Int = 0;
		while (cycleCount < 100)
		{
			// Perform a large number of unnecessary calculations in a tight loop
			for (i in 0...1000000)
			{
				Math.sin(Math.random());
			}
			cycleCount++;
		}
	}

	public static function simulateFrequentCalls():Void
	{
		var itemChancesMap:Map<Dynamic, Float> = new Map<Dynamic, Float>();
		itemChancesMap.set("Option1", 0.5);
		itemChancesMap.set("Option2", 0.5);

		for (i in 0...10000)
		{ // Frequent calls
			var selectedOption = ChanceSelector.selectFromMap(itemChancesMap);
		}
		trace("Completed frequent calls to selectFromMap");
	}

	public static function simulateIntenseMaps():Void
	{
		var numMaps:Int = Std.int(Math.random() * 10 + 1); // Random number of maps between 1 and 10
		var maps:Array<Chance> = [];

		for (i in 0...numMaps)
		{
			var chance:Float = Math.random() * 99999999; // Random chance value between 0 and 99999999
			maps.push({item: "Map" + i, chance: chance});
		}

		var selectedMap = ChanceSelector.selectFromOptions(maps);
		trace("Selected map from random maps:", selectedMap);
	}

	public static function simulateLargeOptions():Void
	{
		var largeOptions:Array<Chance> = [];
		for (i in 0...100000)
		{ // Large number of options
			largeOptions.push({item: "Option" + i, chance: Math.random()});
		}
		var selectedOption = ChanceSelector.selectFromOptions(largeOptions);
		trace("Selected option from large options:", selectedOption);
	}

	public static function simulateLargeJSONCache():Void
	{
		var largeJSONCache = new haxe.ds.StringMap<Dynamic>();
		for (i in 0...100000)
		{ // Large number of JSON files
			largeJSONCache.set("file" + i, {data: "Some data for file " + i});
		}
		for (key in largeJSONCache.keys())
		{
			JSONCache.addToCache(largeJSONCache.get(key));
		}
	}
}

class GlobalResources
{
	public static var jsonFilePaths:Array<String> = [];
}

typedef Boolean = Bool;

class CommandPrompt
{
	private var state:String;
	private var variables:Map<String, Dynamic>;
	public var imports:Map<String, Dynamic> = new Map();
	public var objects:Map<String, Dynamic> = new Map();

	public var active:Boolean = true; // I thought it'd be funny to add this.

	public function new()
	{
		this.state = "default";
		this.variables = new Map();
		// yutautil.VariableForCommands.generateVariableMap(true);
	}

	public function start():Void
	{
		print("Commands activated.");
		print("Warning: Will not accept commands from regular PowerShell. Use Command Prompt, Terminal Command Prompt, or the VSCode terminal.");

		while (true)
		{
			// print("\nInput enabled.");
			if (!active)
			{
				print("Commands disabled.\nTO re-enable, restart the game.");
				break;
			}
			var input:String;
			try {
				input = Sys.stdin().readLine();
			} catch (e:haxe.Exception) {
				print("What? Something weird has happened here...");
				continue;
			}

			if (input == "$exit")
			{
				print("Exiting...");
				Main.closeGame();
				print("Killing CommandHook...");
				break;
			}

			if (input == "$reset")
			{
				print("Resetting game...");
				var processChecker = new Process("MixEngine.exe", ["check"]);
			}
			try {
				this.executeCommand(input);
			} catch (e:haxe.Exception) {
				print("Error executing command: " + e.toString());
			}
		}
	}

	// public function remove()
	// {this = null;}

	private function executeCommand(input:String):Void
	{
		var parts = input.split(" ");
		var command = parts[0];
		var args = parts.slice(1);

		var combinedArgs:Array<String> = [];
		var combinedArgsMap:Array<{position:Int, value:String}> = [];
		var i = 0;

		while (i < args.length)
		{
			var arg = args[i];
			if (arg.startsWith("'") || arg.startsWith('"'))
			{
				var combinedArg:String = arg;
				var quote:String = arg.charAt(0);
				var startPos:Int = i;
				i++;
				while (i < args.length && !args[i].endsWith(quote))
				{
					combinedArg += " " + args[i];
					i++;
				}
				if (i < args.length)
				{
					combinedArg += " " + args[i];
				}
				else
				{
					print("Error: Unterminated quotes.");
					return;
				}
				combinedArgsMap.push({position: startPos, value: combinedArg});
			}
			else
			{
				combinedArgs.push(arg);
			}
			i++;
		}

		// Reconstruct the args array using the combinedArgsMap
		var finalArgs:Array<String> = [];
		var mapIndex = 0;
		var doubleQuote = '"';
		var singleQuote = "'";

		for (i in 0...args.length)
		{
			if (mapIndex < combinedArgsMap.length && combinedArgsMap[mapIndex].position == i)
			{
				finalArgs.push(combinedArgsMap[mapIndex].value);
				mapIndex++;
				// Skip the indices that were part of the combined argument
				while (i < args.length && (!args[i].endsWith(singleQuote) && !args[i].endsWith(doubleQuote)))
				{
				}
			}
			else
			{
				finalArgs.push(args[i]);
			}
		}

		function containsTrue(array:Array<Bool>)
		{
			for (i in 0...array.length)
			{
				if (array[i] == true)
				{
					return true;
				}
			}
			return false;
		}

		// Now finalArgs contains the correctly combined arguments
		// You can proceed with using finalArgs as needed

		switch (command)
		{
			case "switchState":
				if (args.length == 1)
				{
					this.switchState(args[0]);
				}
				else
				{
					print("Error: switchState requires exactly one argument.");
				}
			case "varChange":
				if (args.length == 2)
				{
					this.varChange(args[0], args[1]);
				}
				else
				{
					print("Error: varChange requires exactly two arguments.");
				}
			case "secretCode":
				if (args.length == 1)
				{
					this.secretCode(args[0]);
				}
				else
				{
					print("Error: secretCode requires exactly one argument.");
				}
			case "exit":
				this.active = false;
				print("Exiting game...");
				if (args.length == 0)
				{
					this.switchState("ExitState");
				}
				else if (args.length == 1 && args[1] == "forced")
				{
					print("Forcing game to close...");
					Main.closeGame();
					print("Game closed.");
				}
				else
				{
					print("Warning: exit command only accepts 'forced' as an argument. Closing game...");
					this.switchState("ExitState");
				}

			case "stopTransition":
				if (args.length == 0)
				{
					if (TransitionState.currenttransition != null)
					FlxG.switchState(TransitionState.currenttransition.targetState);
					TransitionState.currenttransition = null;
					while (TransitionState.currenttransition != null)
					{
						print("Forcing transition to stop...");
						TransitionState.currenttransition = null;
					}

				}
				else
				{
					print("Error: stopTransition does not accept any arguments.");
				}
			case "resetState":
				if (args.length == 0)
				{
					FlxG.resetState();
				}
				else
				{
					print("Error: resetState does not accept any arguments.");
				}
			case "debugMenu":
				if (args.length == 0)
				{
					this.switchState("backend.TestState");
				}
				else
				{
					print("Error: debugMenu does not accept any arguments.");
				}
			case "forceSecret":
				if (args.length == 1)
				{
					states.MainMenuState.secretOverride = args[0];
					this.switchState("states.MainMenuState");
				}
				else
				{
					print("Error: forceSecret requires exactly one argument.");
				}
			// case "stopThread":
			// 	if (args.length == 1) {
			// 		Threader.stopThread(args[0]);
			// 	} else {
			// 		print("Error: stopThread requires exactly one argument.");
			// 	}
			// case "listThreads":
			// 	var threads:Array<String> = Threader.listThreads();f
			// 	for (thread in threads) {
			// 		print("Thread: " + thread);
			// 	}

				case "import":
					if (args.length == 1)
					{
						try {
							var className = args[0];
							var alias = className;
							var importedClass = Type.resolveClass(className);
							if (importedClass != null) {
								if (args.length == 2) {alias = args[1];}
								this.imports.set(className, importedClass);
								print("Class " + className + " as" + alias + " imported successfully.");
							} else {
								print("Error: Class " + className + " not found.");
							}
						} catch (e:haxe.Exception) {
							print("Error importing class: " + e.toString());
						}
					}
					else
					{
						print("Error: import requires exactly one argument.");
					}

			case "createInstance": 
				if (args.length >= 1)
				{
					try {
						var className = args[0];
						var alias = className;
						var instanceArgs = [];
						
						if (args.length > 1) {
							if (args[1] != "=") {
								alias = args[1];
								instanceArgs = args.slice(2);
							} else {
								instanceArgs = args.slice(1);
							}
						}

						var importedClass = Type.resolveClass(className);
						if (importedClass != null) {
							this.objects.set(alias, Type.createInstance(importedClass, instanceArgs));
							print("Instance of " + className + " created successfully with alias " + alias + ".");
						} else {
							print("Error: Class " + className + " not found.");
						}
					} catch (e:haxe.Exception) {
						print("Error creating instance: " + e.toString());
					}
				}
				else
				{
					print("Error: createInstance requires at least one argument.");
				}

			case "callMethod":
				if (args.length >= 2)
				{
					try {
						var objectName = args[0];
						var methodName = args[1];
						var methodArgs = args.slice(2);
						var object = this.objects.get(objectName);
						if (object != null) {
							var method = Reflect.field(object, methodName);
							if (method != null) {
								var result = Reflect.callMethod(object, method, methodArgs);
								print("Method " + methodName + " called successfully on object " + objectName + ".");
								print("Result: " + result);
							} else {
								print("Error: Method " + methodName + " not found on object " + objectName + ".");
							}
						} else {
							print("Error: Object " + objectName + " not found.");
						}
					} catch (e:haxe.Exception) {
						print("Error calling method: " + e.toString());
					}
				}
				else
				{
					print("Error: callMethod requires at least two arguments.");
				}

				case "callClassMethod":
					if (args.length >= 2)
					{
						try {
							var className = args[0];
							var methodName = args[1];
							var methodArgs = args.slice(2);
							var importedClass = this.imports.get(className);
							if (importedClass != null) {
								var method = Reflect.field(importedClass, methodName);
								if (method != null) {
									var result = Reflect.callMethod(importedClass, method, methodArgs);
									print("Method " + methodName + " called successfully on class " + className + ".");
									print("Result: " + result);
								} else {
									print("Error: Method " + methodName + " not found on class " + className + ".");
								}
							} else {
								print("Error: Class " + className + " not found.");
							}
						} catch (e:haxe.Exception) {
							print("Error calling class method: " + e.toString());
						}
					}
					else
					{
						print("Error: callClassMethod requires at least two arguments.");
					}

			case "listObjects":
				for (object in this.objects.keys())
				{
					print("Object: " + object + " (" + Type.getClassName(Type.resolveClass(this.objects.get(object))));
				}

			case "listImports":
				for (importedClass in this.imports.keys())
				{
					print("Imported Class: " + importedClass + " (" + Type.getClassName(Type.resolveClass(this.imports.get(importedClass))));
				}

			case "playSong":
				var songName = args[0];
				var song = Paths.formatToSongPath(songName);
				var songChoices:Array<String> = [args[0]];
				var listChoices:Array<String> = [args[0]];
				var difficulties = backend.Paths.crawlMulti([
					'assets/data/$songName',
					'assets/shared/data/$songName',
					'mods/data/$songName'
				].concat(Mods.getModDirectories().map(dir -> '$dir/data/$songName')), 'json', []);
				var filteredDifficulties = [];
				var foundSong:Bool = false;
				var dashCount = songName.split("-").length - 1; // Count dashes in the song name
				for (difficulty in difficulties)
				{
					var fileName = Path.withoutDirectory(difficulty);
					if (fileName.startsWith(songName))
					{
						foundSong = true;
						var parts = fileName.split("-");
						if (parts.length > dashCount + 1)
						{
							filteredDifficulties.push(fileName.replace(".json", ""));
						}
						else if (fileName == songName + ".json")
						{
							filteredDifficulties.push(fileName.replace(".json", ""));
						}
					}
				}
				if (!foundSong)
				{
					GlobalException.throwGlobally("Song not found.", null, true);
				}
				difficulties = filteredDifficulties;
				var temp = [];
				for (difficulty in difficulties)
				{
					difficulty = difficulty.replace(songName, "");
					if (difficulty.startsWith("-"))
					{
						difficulty = difficulty.substr(1);
					}

					if (difficulty == "")
					{
						difficulty = "normal";
					}
					print(difficulty);
					temp.push(difficulty);
				}
				difficulties = temp;
				if (song != null)
				{
					substates.DiffSubState.songChoices = songChoices;
					substates.DiffSubState.listChoices = listChoices;
					backend.Difficulty.list = difficulties;

					// Check if the camera is in the default position
					var defaultCameraPosition = {x: 0, y: 0};
					if (FlxG.camera.scroll.x != defaultCameraPosition.x || FlxG.camera.scroll.y != defaultCameraPosition.y)
					{
						// Tween quickly to the default position
						FlxTween.tween(FlxG.camera.scroll, {x: defaultCameraPosition.x, y: defaultCameraPosition.y}, 0.5, {ease: FlxEase.quadOut});
					}

					FlxG.state.openSubState(new substates.DiffSubState());
				}

			// case "playSongLoose":
			// 	var songName = args[0];
			// 	var song = Paths.formatToSongPath(songName);
			// 	var songChoices:Array<String> = [];
			// 	var listChoices:Array<String> = [];
			// 	var difficulties = backend.Paths.crawlMulti([
			// 		'assets/data/$songName',
			// 		'assets/shared/data/$songName',
			// 		'mods/data/$songName'
			// 	].concat(Mods.getModDirectories().map(dir -> '$dir/data/$songName')), 'json', []);
			// 	var foundSongs:Map<String, Array<String>> = new Map();
			// 	for (difficulty in difficulties)
			// 	{
			// 		var fileName = Path.withoutDirectory(difficulty);
			// 		var baseName = fileName.split("-")[0];
			// 		if (!foundSongs.exists(baseName))
			// 		{
			// 			foundSongs.set(baseName, []);
			// 		}
			// 		foundSongs.get(baseName).push(fileName.replace(".json", ""));
			// 	}
			// 	if (foundSongs.keys().length == 0)
			// 	{
			// 		GlobalException.throwGlobally("No songs found.", null, true);
			// 	}
			// 	for (song in foundSongs.keys())
			// 	{
			// 		songChoices.push(song);
			// 		listChoices.push(song);
			// 		print("Song: " + song);
			// 		for (difficulty in foundSongs.get(song))
			// 		{
			// 			print("  Difficulty: " + difficulty);
			// 		}
			// 	}
			// 	if (song != null)
			// 	{
			// 		substates.DiffSubState.songChoices = songChoices;
			// 		substates.DiffSubState.listChoices = listChoices;
			// 		backend.Difficulty.list = foundSongs.get(songName);

			// 		// Check if the camera is in the default position
			// 		var defaultCameraPosition = {x: 0, y: 0};
			// 		if (FlxG.camera.scroll.x != defaultCameraPosition.x || FlxG.camera.scroll.y != defaultCameraPosition.y)
			// 		{
			// 			// Tween quickly to the default position
			// 			FlxTween.tween(FlxG.camera.scroll, {x: defaultCameraPosition.x, y: defaultCameraPosition.y}, 0.5, {ease: FlxEase.quadOut});
			// 		}

			// 		FlxG.state.openSubState(new substates.DiffSubState());
			// 	}
				// case "do":
				// 	if (args.length >= 2) {
				// 		var subCommand = args[0];
				// 		var code = args.slice(1).join(" ");
						
				// 		switch (subCommand) {
				// 			case "hx", "haxe", "code":
				// 				try {
				// 					haxe.macro.Context.eval(code);
				// 					print("Executed code: " + code);
				// 				} catch (e:haxe.Exception) {
				// 					print("Error executing code: " + e.toString());
				// 				}
								
					// 		case "func":
					// 			var funcName = args[1];
					// 			var funcArgs = args.slice(2);
								
					// 			// Check for different function call formats
					// 			if (funcArgs.length == 1 && funcArgs[0].startsWith("(") && funcArgs[0].endsWith(")")) {
					// 				// Format: func(arg, arg)
					// 				try {
					// 					var func = Reflect.field(this, funcName);
					// 					if (func != null && Reflect.isFunction(func)) {
					// 						var callArgs = funcArgs[0].substring(1, funcArgs[0].length - 1).split(",");
					// 						Reflect.callMethod(this, func, callArgs);
					// 						print("Executed function: " + funcName + " with arguments: " + callArgs.join(", "));
					// 					} else {
					// 						print("Error: Function " + funcName + " not found.");
					// 					}
					// 				} catch (e:haxe.Exception) {
					// 					print("Error executing function: " + e.toString());
					// 				}
					// 			} else if (funcArgs.length > 0 && funcArgs[0] == "()") {
					// 				// Format: func() arg arg
					// 				try {
					// 					var func = Reflect.field(this, funcName);
					// 					if (func != null && Reflect.isFunction(func)) {
					// 						Reflect.callMethod(this, func, funcArgs.slice(1));
					// 						print("Executed function: " + funcName + " with arguments: " + funcArgs.slice(1).join(", "));
					// 					} else {
					// 						print("Error: Function " + funcName + " not found.");
					// 					}
					// 				} catch (e:haxe.Exception) {
					// 					print("Error executing function: " + e.toString());
					// 				}
					// 			} else if (funcArgs.length > 0) {
					// 				// Format: func arg arg
					// 				try {
					// 					var func = Reflect.field(this, funcName);
					// 					if (func != null && Reflect.isFunction(func)) {
					// 						Reflect.callMethod(this, func, funcArgs);
					// 						print("Executed function: " + funcName + " with arguments: " + funcArgs.join(", "));
					// 					} else {
					// 						print("Error: Function " + funcName + " not found.");
					// 					}
					// 				} catch (e:haxe.Exception) {
					// 					print("Error executing function: " + e.toString());
					// 				}
					// 			} else {
					// 				print("Error: Invalid function call format.");
					// 			}
								
					// 		default:
					// 			print("Error: Unknown sub-command for 'do'.");
					// 	}
					// } else {
					// 	print("Error: 'do' requires at least two arguments.");
					// }
					
			default:
				if (args.length == 2 && args[1] == '=')
				{
					varChange(args[0], args[2]);
				}
				else
					print("Error: Unknown command.");
		}
	}

	private function switchState(newState:String):Void
	{
		var stateType:Class<Dynamic> = Type.resolveClass(newState);
		if (stateType != null)
		{
			FlxG.switchState(Type.createInstance(stateType, []));
			print("State switched to: " + newState);
		}
		else
		{
			print("Error: Invalid state name.");
		}
	}

	private function varChange(varName:String, newValue:String):Void
	{
		var split:Array<String> = varName.split('.');
		if (split.length == 0)
		{
			print("Error: Invalid variable name.");
			return;
		}

		var context:String = split[0];
		var remaining:Array<String> = split.slice(1);

		switch (context)
		{
			case "class":
				if (remaining.length >= 2)
				{
					var className:String = remaining[0];
					var variable:String = remaining.slice(1).join('.');
					this.setPropertyFromClass(className, variable, newValue);
				}
				else
				{
					print("Error: Invalid class variable name.");
				}
			case "group":
				if (remaining.length >= 3)
				{
					var groupName:String = remaining[0];
					var index:Int = Std.parseInt(remaining[1]);
					var variable:String = remaining.slice(2).join('.');
					this.setPropertyFromGroup(groupName, index, variable, newValue);
				}
				else
				{
					print("Error: Invalid group variable name.");
				}
			case "state":
				if (remaining.length >= 1)
				{
					var variable:String = remaining.join('.');
					this.setPropertyFromState(variable, newValue);
				}
				else
				{
					print("Error: Invalid state variable name.");
				}
			default:
				print("Error: Unknown context.");
		}
	}

	private function setPropertyFromClass(className:String, variable:String, value:Dynamic):Void
	{
		var myClass:Dynamic = Type.resolveClass(className);
		if (myClass == null)
		{
			print("Error: Class " + className + " not found.");
			return;
		}

		var split:Array<String> = variable.split('.');
		if (split.length > 1)
		{
			var obj:Dynamic = Reflect.field(myClass, split[0]);
			for (i in 1...split.length - 1)
				obj = Reflect.field(obj, split[i]);

			Reflect.setProperty(obj, split[split.length - 1], value);
		}
		else
		{
			Reflect.setProperty(myClass, variable, value);
		}
		print("Variable " + variable + " in class " + className + " changed to: " + value);
	}

	private function setPropertyFromGroup(groupName:String, index:Int, variable:String, value:Dynamic):Void
	{
		var realObject:Dynamic = Reflect.field(LuaUtils.getTargetInstance(), groupName);

		if (Std.isOfType(realObject, FlxTypedGroup))
		{
			LuaUtils.setGroupStuff(realObject.members[index], variable, value);
			print("Variable " + variable + " in group " + groupName + " at index " + index + " changed to: " + value);
		}
		else
		{
			var leArray:Dynamic = realObject[index];
			if (leArray != null)
			{
				if (Type.typeof(variable) == Type.ValueType.TInt)
				{
					leArray = value;
				}
				else
				{
					LuaUtils.setGroupStuff(leArray, variable, value);
				}
				print("Variable " + variable + " in group " + groupName + " at index " + index + " changed to: " + value);
			}
			else
			{
				print("Error: Object #" + index + " from group " + groupName + " doesn't exist!");
			}
		}
	}

	private function setPropertyFromState(variable:String, value:Dynamic):Void
	{
		var currentState = FlxG.state;
		if (currentState != null)
		{
			var split:Array<String> = variable.split('.');
			if (split.length > 1)
			{
				var obj:Dynamic = Reflect.field(currentState, split[0]);
				for (i in 1...split.length - 1)
					obj = Reflect.field(obj, split[i]);

				Reflect.setProperty(obj, split[split.length - 1], value);
			}
			else
			{
				Reflect.setProperty(currentState, variable, value);
			}
			print("Variable " + variable + " in state changed to: " + value);
		}
		else
		{
			print("Error: No active state.");
		}
	}

	private function secretCode(code:String):Void
	{
		print("Secret code entered: " + code);
		print("Not yet implemented.");
	}

	private function print(message:String):Void
	{
		Sys.stdout().writeString(message + "\n");
	}
}

class GlobalException extends haxe.Exception
{
	public function new(message:String, ?previous:haxe.Exception)
	{
		super(message, previous);
	}

	public static function throwGlobally(message:String, ?previous:haxe.Exception, ?allowHandle):Void
	{
		WindowUtils.preventClosing = false;
		var exception = new GlobalException(message, previous);
		// Use a mechanism to throw the exception globally
		haxe.Timer.delay(function()
		{
			if (allowHandle)
			{
				// Handle the exception
				Main.onCrash(new UncaughtErrorEvent(UncaughtErrorEvent.UNCAUGHT_ERROR, exception));
			}
			else
			{
				throw exception;
			}
		}, 0);
	}
}
