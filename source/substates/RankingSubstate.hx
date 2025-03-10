package substates;

import sys.FileSystem;
import sys.io.File;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import backend.Song;
import flixel.addons.transition.FlxTransitionableState;

class RankingSubstate extends MusicBeatSubstate
{
	var pauseMusic:FlxSound;

	var rank:FlxSprite = new FlxSprite(-200, 730);
	var combo:FlxSprite = new FlxSprite(-200, 730);
	var comboRank:String = "NA";
	var ranking:String = "NA";
	var rankingNum:Int = 15;
	var press:FlxText;
	var hint:FlxText;
	var comboRankLimit:Int = 0;
	public static var comboRankSetLimit:Int = 0;
	var accRankLimit:Int = 0;
	public static var accRankSetLimit:Int = 0;
	public function new()
	{
		super();
		// PlayState.songEndTriggered = false;
		Conductor.songPosition = 0;

		generateRanking();

		if (!PlayState.instance.cpuControlled)
			backend.Highscore.saveRank(PlayState.SONG.song, rankingNum, PlayState.storyDifficulty);
	}

	override function create()
	{
		pauseMusic = new FlxSound().loadEmbedded(Paths.formatToSongPath(ClientPrefs.data.pauseMusic), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		rank = new FlxSprite(-20, 40).loadGraphic(Paths.image('rankings/$ranking'));
		rank.scrollFactor.set();
		add(rank);
		rank.antialiasing = true;
		rank.setGraphicSize(0, 450);
		rank.updateHitbox();
		rank.screenCenter();

		combo = new FlxSprite(-20, 40).loadGraphic(Paths.image('rankings/$comboRank'));
		combo.scrollFactor.set();
		combo.screenCenter();
		combo.x = rank.x - combo.width / 2;
		combo.y = rank.y - combo.height / 2;
		add(combo);
		combo.antialiasing = true;
		combo.setGraphicSize(0, 130);

		press = new FlxText(20, 15, 0, "Press ANY to continue.", 32);
		press.scrollFactor.set();
		press.setFormat(Paths.font("vcr.ttf"), 32);
		press.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		press.updateHitbox();
		add(press);

		hint = new FlxText(20, 15, 0, "You passed. Try getting under 10 misses for SDCB", 32);
		hint.scrollFactor.set();
		hint.setFormat(Paths.font("vcr.ttf"), 32);
		hint.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		hint.updateHitbox();
		add(hint);

		switch (comboRank)
		{
			case 'MFC':
				hint.text = "Congrats! You're perfect!";
			case 'GFC':
				hint.text = "You're doing great! Try getting only sicks for MFC";
			case 'FC':
				hint.text = "Good job. Try getting goods at minimum for GFC.";
			case 'SDCB':
				hint.text = "Nice. Try not missing at all for FC.";
		}

		if (PlayState.instance.cpuControlled)
		{
			hint.y -= 35;
			hint.text = "If you wanna gather that rank, disable botplay.";
		}

		if (PlayState.deathCounter >= 30)
		{
			hint.text = "skill issue\nnoob";
		}

		hint.screenCenter(X);

		hint.alpha = press.alpha = 0;

		press.screenCenter();
		press.y = 670 - press.height;

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(press, {alpha: 1, y: 690 - press.height}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(hint, {alpha: 1, y: 645 - hint.height}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var inCutscene:Bool = false;
	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5 * 1 / 100 && !inCutscene)
			pauseMusic.volume += 0.01 * 1 / 100 * elapsed;

		super.update(elapsed);

		if ((FlxG.keys.justPressed.ANY || PlayState.instance.practiceMode) && !inCutscene)
		{
			PlayState.instance.paused = false;
			switch (PlayState.gameplayArea)
			{
				case "Story":
					if (PlayState.storyPlaylist.length <= 0)
					{
						Mods.loadTopMod();
						FlxG.sound.playMusic(Paths.music('odd_menu_music'));
						TransitionState.transitionState(states.StoryMenuState, {transitionType: "stickers"});
					}
					else
					{
						var difficulty:String = Difficulty.getFilePath();

						trace('LOADING NEXT SONG');
						trace(Paths.formatToSongPath(PlayState.storyPlaylist[0]) + difficulty);

						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;

						PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0] + difficulty, PlayState.storyPlaylist[0]);
						FlxG.sound.music.stop();
						TransitionState.transitionState(states.PlayState, {transitionType: "stickers"});
					}
				case "Freeplay":
					trace('WENT BACK TO FREEPLAY??');
					Mods.loadTopMod();
					FlxG.sound.playMusic(Paths.music('odd_menu_music'));
					TransitionState.transitionState(states.FreeplayState, {transitionType: "stickers"});	
					Mods.loadTopMod();
				case "Countdown":
					doCountScare();
			}
		}
	}

	function doCountScare()
	{
		inCutscene = true;
		FlxTween.tween(rank, {alpha: 0}, 2, {ease: FlxEase.quartInOut});
		FlxTween.tween(combo, {alpha: 0}, 2, {ease: FlxEase.quartInOut});
		FlxTween.tween(hint, {alpha: 0}, 2, {ease: FlxEase.quartInOut});
		FlxTween.tween(pauseMusic, {volume: 0}, 2, {ease: FlxEase.quartInOut});
		FlxTween.tween(press, {alpha: 0}, 5, {ease: FlxEase.expoInOut, onComplete: function(twn:FlxTween)
		{
			FlxG.sound.play(Paths.sound('40'));
			new FlxTimer().start(0.4, function(tmr:FlxTimer)
			{
				var counter:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('IMG_0764'));
				counter.screenCenter();
				counter.alpha = 0;
				add(counter);

				var f40:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('IMG_0766'));
				f40.screenCenter();
				f40.alpha = 0;
				add(f40);

				var f39:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('IMG_0765'));
				f39.screenCenter();
				f39.alpha = 0;
				add(f39);
				new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					counter.alpha = 1;
					new FlxTimer().start(3, function(tmr:FlxTimer)
					{
						FlxG.sound.play(Paths.sound('count'));
						counter.alpha = 0;
						f40.alpha = 1;
						new FlxTimer().start(3, function(tmr:FlxTimer)
						{
							FlxG.sound.play(Paths.sound('count'));
							f40.alpha = 0;
							f39.alpha = 1;
							new FlxTimer().start(3, function(tmr:FlxTimer)
							{
								FlxTween.tween(f39, {alpha: 0}, 5, {ease: FlxEase.expoInOut, onComplete: function(twn:FlxTween)
								{
									trace('WENT BACK TO FREEPLAY??');
									FlxG.save.data.complete2 = true;
									FlxG.save.flush();
									Mods.loadTopMod();
									FlxG.sound.playMusic(Paths.music('odd_menu_music'));
									TransitionState.transitionState(states.FreeplayState, {transitionType: "stickers"});
								}});
							});	
						});	
					});	
				});
			});
		}});
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function generateRanking():String
	{
		if (PlayState.instance.songMisses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods == 0 && PlayState.sicks == 0 && ClientPrefs.data.useMarvs) // Marvelous Full Combo
			{ comboRank = "MFC"; comboRankLimit = 1; }
		else if (PlayState.instance.songMisses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods == 0) // Sick Full Combo
			{ comboRank = "SFC"; comboRankLimit = 2; }
		else if (PlayState.instance.songMisses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
			{ comboRank = "GFC"; comboRankLimit = 3; }
		else if (PlayState.instance.songMisses == 0 && PlayState.bads >= 1 && PlayState.shits == 0 && PlayState.goods >= 0) // Alright Full Combo (Bads, Goods and Sicks)
			{ comboRank = "AFC"; comboRankLimit = 4; }
		else if (PlayState.instance.songMisses == 0) // Regular FC
			{ comboRank = "FC"; comboRankLimit = 5; }
		else if (PlayState.instance.songMisses < 10) // Single Digit Combo Breaks
			{ comboRank = "SDCB"; comboRankLimit = 6; }

		var acc = backend.Highscore.floorDecimal(PlayState.instance.ratingPercent * 100, 2);

		// WIFE TIME :)))) (based on Wife3)

		var wifeConditions:Array<Bool> = [
			acc >= 99.9935, // P
			acc >= 99.980, // X
			acc >= 99.950, // X-
			acc >= 99.90, // SS+
			acc >= 99.80, // SS
			acc >= 99.70, // SS-
			acc >= 99.50, // S+
			acc >= 99, // S
			acc >= 96.50, // S-
			acc >= 93, // A+
			acc >= 90, // A
			acc >= 85, // A-
			acc >= 80, // B
			acc >= 70, // C
			acc >= 60, // D
			acc < 60 // E
		];

		for (i in 0...wifeConditions.length)
		{
			var b = wifeConditions[i];
			if (b)
			{
				rankingNum = i;
				switch (i)
				{
					case 0:
						ranking = "P";
						accRankLimit = 1;
					case 1:
						ranking = "X";
						accRankLimit = 2;
					case 2:
						ranking = "X-";
						accRankLimit = 3;
					case 3:
						ranking = "SS+";
						accRankLimit = 4;
					case 4:
						ranking = "SS";
						accRankLimit = 5;
					case 5:
						ranking = "SS-";
						accRankLimit = 6;
					case 6:
						ranking = "S+";
						accRankLimit = 7;
					case 7:
						ranking = "S";
						accRankLimit = 8;
					case 8:
						ranking = "S-";
						accRankLimit = 9;
					case 9:
						ranking = "A+";
						accRankLimit = 10;
					case 10:
						ranking = "A";
						accRankLimit = 11;
					case 11:
						ranking = "A-";
						accRankLimit = 11;
					case 12:
						ranking = "B";
						accRankLimit = 12;
					case 13:
						ranking = "C";
						accRankLimit = 13;
					case 14:
						ranking = "D";
						accRankLimit = 14;
					case 15:
						ranking = "E";
						accRankLimit = 15;
				}

				if (PlayState.deathCounter >= 30 || acc == 0)
					ranking = "F";
				break;
			}
		}
		return ranking;
	}
}