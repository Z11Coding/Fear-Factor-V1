package objects;

import math.Vector3;
import flixel.math.FlxPoint;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flash.display.BitmapData;
import editors.ChartingState;
import openfl.utils.AssetType;
import openfl.utils.Assets;
#if sys
import sys.io.File;
import sys.FileSystem;
#end
using StringTools;

typedef EventNote = {
	strumTime:Float,
	event:String,
	value1:String,
	value2:String
}

class Note extends NoteObject
{
	public var vec3Cache:Vector3 = new Vector3(); // for vector3 operations in modchart code	

	override function destroy()
	{
		defScale.put();
		super.destroy();
	}	
	
	public var zIndex:Float = 0;
	public var desiredZIndex:Float = 0;
	public var z:Float = 0;
	public var garbage:Bool = false; // if this is true, the note will be removed in the next update cycle
	public var alphaMod:Float = 1;
	public var alphaMod2:Float = 1; // TODO: unhardcode this shit lmao

	public var mAngle:Float = 0;
	public var bAngle:Float = 0;
	
	public static var gfxLetter:Array<String> = [
		'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I',
		'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R'
	];

	public static var scales:Array<Float> = [0.9, 0.85, 0.8, 0.7, 0.66, 0.6, 0.55, 0.50, 0.46, 0.39, 0.3, 0.37, 0.30, 0.25];
	public static var lessX:Array<Int> = [0, 0, 0, 0, 0, 8, 7, 8, 8, 7, 6, 8, 8, 9];
	public static var separator:Array<Int> = [0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 5, 7];
	public static var xtra:Array<Int> = [150, 89, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
	public static var posRest:Array<Int> = [0, 0, 0, 0, 25, 32, 46, 52, 60, 40, 30, 40, 40, 40];
	public static var gridSizes:Array<Int> = [40, 40, 40, 40, 40, 40, 40, 40, 40, 35, 30, 25, 25, 20];
	public static var offsets:Array<Dynamic> = [
		[20, 10], [10, 10], [10, 10], [10, 10], [10, 10], [10, 10], [10, 10], [10, 10], [10, 10], [10, 20], [10, 10], [10, 10], [10, 10], [20, 20]];
	public static var noteSplashScales:Array<Float> = [
        1.3, //1k
        1.2, //2k
        1.1, //3k
        1, //4k
        1, //5k
        0.9, //6k
        0.8,//7k
        0.7, //8k
        0.6, //9k
        0.5, //10k
        0.4, //11k
        0.3, //12k
        0.3, //13k
        0.3, //14k
        0.2, //15k
        0.18, //16k
        0.18, //17k
        0.15 //18k
    ];
	public static var noteSplashOffsets:Map<Int, Array<Int>> = [
		0 => [20, 10],
		9 => [10, 20]
	];

	public static var minMania:Int = 0;
	public static var maxMania:Int = 13;
	public static var defaultMania:Int = 3;
	public var downscrollNote:Bool = ClientPrefs.downScroll;
	public var baseAlpha:Float = 1;
	public var autoGenerated:Bool = false;
	public static var pixelNotesDivisionValue:Int = 18;

	public static var minManiaUI_integer:Int = minMania + 1;
	public static var maxManiaUI_integer:Int = maxMania + 1;

	public static var xmlMax:Int = 17; // This specifies the max of the splashes can go

	public static var keysShit:Map<Int, Map<String, Dynamic>> = [
		0 => [
			"letters" => ["E"],
			"anims" => ["UP"],
			"strumAnims" => ["SPACE"],
			"pixelAnimIndex" => [4]
		],
		1 => [
			"letters" => ["A", "D"],
			"anims" => ["LEFT", "RIGHT"],
			"strumAnims" => ["LEFT", "RIGHT"],
			"pixelAnimIndex" => [0, 3]
		],
		2 => [
			"letters" => ["A", "E", "D"],
			"anims" => ["LEFT", "UP", "RIGHT"],
			"strumAnims" => ["LEFT", "SPACE", "RIGHT"],
			"pixelAnimIndex" => [0, 4, 3]
		],
		3 => [
			"letters" => ["A", "B", "C", "D"],
			"anims" => ["LEFT", "DOWN", "UP", "RIGHT"],
			"strumAnims" => ["LEFT", "DOWN", "UP", "RIGHT"],
			"pixelAnimIndex" => [0, 1, 2, 3]
		],
		4 => [
			                  "letters" => ["A", "B", "E", "C", "D"], "anims" => ["LEFT", "DOWN", "UP", "UP", "RIGHT"],
			"strumAnims" => ["LEFT", "DOWN", "SPACE", "UP", "RIGHT"],              "pixelAnimIndex" => [0, 1, 4, 2, 3]
		],
		5 => [
			                     "letters" => ["A", "C", "D", "F", "B", "I"], "anims" => ["LEFT", "UP", "RIGHT", "LEFT", "DOWN", "RIGHT"],
			"strumAnims" => ["LEFT", "UP", "RIGHT", "LEFT", "DOWN", "RIGHT"],                      "pixelAnimIndex" => [0, 2, 3, 5, 1, 8]
		],
		6 => [
			                         "letters" => ["A", "C", "D", "E", "F", "B", "I"], "anims" => ["LEFT", "UP", "RIGHT", "UP", "LEFT", "DOWN", "RIGHT"],
			"strumAnims" => ["LEFT", "UP", "RIGHT", "SPACE", "LEFT", "DOWN", "RIGHT"],                         "pixelAnimIndex" => [0, 2, 3, 4, 5, 1, 8]
		],
		7 => [
			                         "letters" => ["A", "B", "C", "D", "F", "G", "H", "I"], "anims" =>
			["LEFT", "DOWN", "UP", "RIGHT", "LEFT", "DOWN", "UP", "RIGHT"],
			"strumAnims" => ["LEFT", "DOWN", "UP", "RIGHT", "LEFT", "DOWN", "UP", "RIGHT"],                              "pixelAnimIndex" =>
			[0, 1, 2, 3, 5, 6, 7, 8]
		],
		8 => [
			                             "letters" => ["A", "B", "C", "D", "E", "F", "G", "H", "I"], "anims" =>
			["LEFT", "DOWN", "UP", "RIGHT", "UP", "LEFT", "DOWN", "UP", "RIGHT"],
			"strumAnims" => ["LEFT", "DOWN", "UP", "RIGHT", "SPACE", "LEFT", "DOWN", "UP", "RIGHT"],                                 "pixelAnimIndex" =>
			[0, 1, 2, 3, 4, 5, 6, 7, 8]
		],
		9 => [
			"letters" => ["A", "B", "C", "D", "E", "N", "F", "G", "H", "I"],
			"anims" => ["LEFT", "DOWN", "UP", "RIGHT", "UP", "UP", "LEFT", "DOWN", "UP", "RIGHT"],
			"strumAnims" => ["LEFT", "DOWN", "UP", "RIGHT", "SPACE", "CIRCLE", "LEFT", "DOWN", "UP", "RIGHT"],
			"pixelAnimIndex" => [0, 1, 2, 3, 4, 13, 5, 6, 7, 8]
		],
		10 => [
			"letters" => ["A", "B", "C", "D", "J", "N", "M", "F", "G", "H", "I"],
			"anims" => [
				"LEFT", "DOWN", "UP", "RIGHT", "LEFT", "UP", "RIGHT", "LEFT", "DOWN", "UP", "RIGHT"
			],
			"strumAnims" => [
				"LEFT", "DOWN", "UP", "RIGHT", "CIRCLE", "CIRCLE", "CIRCLE", "LEFT", "DOWN", "UP", "RIGHT"
			],
			"pixelAnimIndex" => [0, 1, 2, 3, 9, 13, 12, 5, 6, 7, 8]
		],
		11 => [
			"letters" => ["A", "B", "C", "D", "J", "K", "L", "M", "F", "G", "H", "I"],
			"anims" => [
				"LEFT", "DOWN", "UP", "RIGHT", "LEFT", "DOWN", "UP", "RIGHT","LEFT", "DOWN", "UP", "RIGHT"
			],
			"strumAnims" => [
				"LEFT", "DOWN", "UP", "RIGHT", "CIRCLE", "CIRCLE", "CIRCLE", "CIRCLE", "LEFT", "DOWN", "UP", "RIGHT"
			],
			"pixelAnimIndex" => [0, 1, 2, 3, 9, 13, 12, 5, 6, 7, 8]
		],
		12 => [
			"letters" => ["A", "B", "C", "D", "E", "J", "K", "L", "M", "N", "F", "G", "H", "I"],
			"anims" => [
				"LEFT", "DOWN", "UP", "RIGHT", "UP", "LEFT", "DOWN", "UP", "RIGHT", "UP", "LEFT", "DOWN", "UP", "RIGHT"
			],
			"strumAnims" => [
				"LEFT", "DOWN", "UP", "RIGHT", "SPACE", "CIRCLE", "CIRCLE", "CIRCLE", "CIRCLE", "CIRCLE", "LEFT", "DOWN", "UP", "RIGHT"
			],
			"pixelAnimIndex" => [0, 1, 2, 3, 9, 13, 12, 5, 6, 7, 8]
		],
		13 => [
			"letters" => ["A", "B", "C", "D", "F", "G", "H", "I", "E", "N", "J", "K", "L", "M", "P", "Q", "R", "S"],
			"anims" => [
				"LEFT", "DOWN", "UP", "RIGHT", "LEFT", "DOWN", "UP", "RIGHT", "UP", "UP", "LEFT", "DOWN", "UP", "RIGHT", "LEFT", "DOWN", "UP", "RIGHT"
			],
			"strumAnims" => [
				"LEFT", "DOWN", "UP", "RIGHT", "LEFT", "DOWN", "UP", "RIGHT", "SPACE", "CIRCLE","CIRCLE", "CIRCLE", "CIRCLE", "CIRCLE", "CIRCLE", "CIRCLE", "CIRCLE", "CIRCLE"
			],
			"pixelAnimIndex" => [0, 1, 2, 3, 9, 13, 12, 5, 6, 7, 8]
		]
	];

	public static var ammo:Array<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 18];

	public static var pixelScales:Array<Float> = [1.2, 1.15, 1.1, 1, 0.9, 0.83, 0.8, 0.74, 0.7, 0.6, 0.55];

	// End of extra keys stuff
	//////////////////////////////////////////////////

	public var extraData:Map<String,Dynamic> = [];
	public var strumTime:Float = 0;
	public var visualTime:Float = 0;

	public var characters:Array<Character> = []; // which characters sing this note, leave blank for the playfield's characters
	public var fieldIndex:Int = -1; // Used to denote which PlayField to be placed into
	public var field:PlayField; // same as fieldIndex but lets you set the field directly incase you wanna do that i  guess

	public var mustPress:Bool = false;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var ignoreNote:Bool = false;
	public var hitByOpponent:Bool = false;
	public var noteWasHit:Bool = false;
	public var prevNote:Note;
	public var nextNote:Note;

	public var noteScript:FunkinScript;

	public var spawned:Bool = false;

	public var blockHit:Bool = false; // only works for player

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var holdingTime:Float = 0;
	public var tripTimer:Float = 0;
	public var noteType(default, set):String = null;
	public var causedMiss:Bool = false;

	public var eventName:String = '';
	public var eventLength:Int = 0;
	public var eventVal1:String = '';
	public var eventVal2:String = '';

	public var colorSwap:ColorSwap;
	public var inEditor:Bool = false;
	public var gfNote:Bool = false;
	public var exNote:Bool = false;
	public var ghostNote:Bool = false;

	public var earlyHitMult:Float = 0.5;
	public var formerPress:Bool = false;
	public var scrollSpeed(default, set):Float = 0;

	public var baseScaleX:Float = 1;
	public var baseScaleY:Float = 1;
	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	// Lua shit
	public var noteSplashDisabled:Bool = false;
	public var noteSplashTexture:String = null;
	public var noteSplashHue:Float = 0;
	public var noteSplashSat:Float = 0;
	public var noteSplashBrt:Float = 0;

	public var offsetAngle:Float = 0;
	public var multAlpha:Float = 1;
	public var multSpeed(default, set):Float = 1;

	public var copyX:Bool = true;
	public var copyY:Bool = true;
	public var copyAngle:Bool = true;
	public var copyAlpha:Bool = true;

	public var hitHealth:Float = 0.023;
	public var missHealth:Float = 0.0475;
	public var ratingMod:Float = 0; //9 = unknown, 0.25 = shit, 0.5 = bad, 0.75 = good, 1 = sick
	public var ratingDisabled:Bool = false;
	public var hitsoundDisabled:Bool = false;

	public var changeAnim:Bool = true;
	public var changeColSwap:Bool = true;

	public var rating:String = 'unknown';

	public var texture(default, set):String = null;

	public var noAnimation:Bool = false;
	public var noMissAnimation:Bool = false;
	public var hitCausesMiss:Bool = false;
	public var distance:Float = 2000; // plan on doing scroll directions soon -bb
	public var centerNote:Bool = false;

	public var mania:Int = 3;

	//public var downscrollNote = ClientPrefs.downScroll; 

	var chara:String = 'normal';//Megalo Strike Back

	var ogW:Float;
	var ogH:Float;

	public static var defaultWidth:Float = 0;
	public static var defaultHeight:Float = 0;

	public var isParent:Bool; // ke input shits
	public var tail:Array<Note> = [];
	public var childs:Array<Note> = [];
	public var unhitTail:Array<Note> = [];
	public var parent:Note;
	public var susActive:Bool = true;
	public var spotInLine:Int = 0;
	public var hitboxMultiplier:Float = 1;
	public static var randomgodnote:Bool = false;
	public var lowPriority:Bool = false;


	//Note Skins
	var hasNoteType:Bool = false;
	var antialias:Bool = true;
	var skin:String;

	//Hypno Input Am I Right
	public var parentNote:Note; 
	public var childrenNotes:Array<Note> = [];

	public var typeOffsetX:Float = 0; // used to offset notes, mainly for note types. use in place of offset.x and offset.y when offsetting notetypes
	public var typeOffsetY:Float = 0;

	private function set_multSpeed(value:Float):Float {
		resizeByRatio(value / multSpeed);
		multSpeed = value;
		//trace('fuck cock');
		return value;
	}

	public function resizeByRatio(ratio:Float) //haha funny twitter shit
	{
		if(isSustainNote && !animation.curAnim.name.endsWith('end'))
		{
			scale.y *= ratio;
			updateHitbox();
			defScale.copyFrom(scale);
		}
	}

	public function set_texture(value:String):String
	{
		if (texture != value)
		{
			reloadNote('', value);
		}
		texture = value;
		return value;
		hasNoteType = true;
	}

	private function set_noteType(value:String):String
	{
		noteSplashTexture = PlayState.SONG.splashSkin;
		if (noteData > -1 && noteData < ClientPrefs.arrowHSV.length && Note.ammo[PlayState.mania] < 4)
		{
			colorSwap.hue = ClientPrefs.arrowHSV[Std.int(Note.keysShit.get(mania).get('pixelAnimIndex')[noteData] % Note.ammo[mania])][0] / 360;
			colorSwap.saturation = ClientPrefs.arrowHSV[Std.int(Note.keysShit.get(mania).get('pixelAnimIndex')[noteData] % Note.ammo[mania])][1] / 100;
			colorSwap.brightness = ClientPrefs.arrowHSV[Std.int(Note.keysShit.get(mania).get('pixelAnimIndex')[noteData] % Note.ammo[mania])][2] / 100;
		}

		if (noteData > -1 && noteType != value)
		{
			noteScript = null;
			switch (value)
			{
				case 'Hurt Note':
					ignoreNote = mustPress;
					reloadNote('HURT');
					noteSplashTexture = 'HURTnoteSplashes';
					colorSwap.hue = 0;
					colorSwap.saturation = 0;
					colorSwap.brightness = 0;
					if (isSustainNote)
					{
						missHealth = 0.1;
					}
					else
					{
						missHealth = 0.3;
					}
					hitCausesMiss = true;
					hasNoteType = true;
					lowPriority = true;
				case 'No Animation':
					noAnimation = true;
				case 'GF Sing':
					gfNote = true;
				case 'Parry Note':
					ignoreNote = false;
					mustPress = true;
					reloadNote('PARRY');
					colorSwap.hue = 0;
					colorSwap.saturation = 0;
					colorSwap.brightness = 0;
					if (isSustainNote)
					{
						missHealth = 0.2;
					}
					else
					{
						missHealth = 0.4;
					}
					hitCausesMiss = false;
					hasNoteType = true;
					lowPriority = false;
				case 'Ghost Note':
					ghostNote = true;
				case 'EX Note':
					exNote = true;
				default:
					hasNoteType = false;
			}
			noteType = value;
		}
		if (noteType != null)
		{
			noteType = '';
		}
		if (value != null)
		{
			value = '';
		}
		noteSplashHue = colorSwap.hue;
		noteSplashSat = colorSwap.saturation;
		noteSplashBrt = colorSwap.brightness;
		return value;
	}

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?inEditor:Bool = false, char:String)
	{
		super();

		mania = PlayState.mania;

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;
		this.inEditor = inEditor;
		this.chara = char;
		if (char != null && !this.exNote) skin = char;
		else if (this.exNote) skin = PlayState.dad2.strumSkin;
		else 'noteskins/normal';
		if (inEditor)
		{
			skin = 'noteskins/normal'; 
		}
		//saving it :)
		x += (ClientPrefs.middleScroll ? PlayState.STRUM_X_MIDDLESCROLL : PlayState.STRUM_X) + 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;
		if (!inEditor)
			this.strumTime += ClientPrefs.noteOffset;
		if(!inEditor)visualTime = PlayState.instance.getNoteInitialTime(this.strumTime);

		if (isSustainNote && prevNote != null) {
			parentNote = prevNote;
			while (parentNote.parentNote != null)
				parentNote = parentNote.parentNote;
			parentNote.childrenNotes.push(this);
		} else if (!isSustainNote)
			parentNote = null;

		antialias = ClientPrefs.globalAntialiasing;

		this.noteData = noteData;

		if(noteData > -1) {
			texture = '';
			colorSwap = new ColorSwap();
			shader = colorSwap.shader;

			x += swagWidth * (noteData % Note.ammo[mania]);
			if(!isSustainNote && noteData > -1 && noteData < Note.maxManiaUI_integer) { //Doing this 'if' check to fix the warnings on Senpai songs
				var animToPlay:String = '';
				animToPlay = Note.keysShit.get(mania).get('letters')[noteData];
				animation.play(animToPlay);
			}
		}

		// trace(prevNote);
		if(!hasNoteType)
			texture = skin;

		if (isSustainNote && prevNote != null)
		{
			alpha = 0.6;
			multAlpha = 0.6;
			hitsoundDisabled = true;
			if (ClientPrefs.downScroll)
				flipY = true;

			offsetX += width / 2;
			copyAngle = false;

			animation.play(Note.keysShit.get(mania).get('letters')[noteData] + ' tail');

			updateHitbox();

			offsetX -= width / 2;

			if (PlayState.isPixelStage)
				offsetX += 30 * Note.pixelScales[mania];

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play(Note.keysShit.get(mania).get('letters')[prevNote.noteData] + ' hold');

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.05;
				if (PlayState.instance != null)
				{
					prevNote.scale.y *= PlayState.instance.songSpeed;
				}

				if(PlayState.isPixelStage) { ///Y E  A H
					prevNote.scale.y *= 1.19;
					prevNote.scale.y *= (6 / height); //Auto adjust note size
				}
				prevNote.updateHitbox();
				prevNote.defScale.copyFrom(prevNote.scale);
				// prevNote.setGraphicSize();
			}

			if (PlayState.isPixelStage)
			{
				scale.y *= PlayState.daPixelZoom;
				updateHitbox();
			}
		}
		else if (!isSustainNote)
		{
			earlyHitMult = 1;
		}
		defScale.copyFrom(scale);
		x += offsetX;
	}

	var lastNoteOffsetXForPixelAutoAdjusting:Float = 0;
	var lastNoteScaleToo:Float = 1;
	public var originalHeightForCalcs:Float = 6;
	function reloadNote(?prefix:String = '', ?texture:String = '', ?suffix:String = '')
	{
		if (prefix == null)
			prefix = '';
		if (texture == null)
			texture = '';
		if (suffix == null)
			suffix = '';

		var skin:String = texture;
		if(texture.length < 1) {
			skin = PlayState.SONG.arrowSkin;
			if(skin == null || skin.length < 1) {
				skin = 'noteskins/normal';
			}
		}

		var animName:String = null;
		if(animation.curAnim != null) {
			animName = animation.curAnim.name;
		}

		var arraySkin:Array<String> = skin.split('/');
		arraySkin[arraySkin.length - 1] = prefix + arraySkin[arraySkin.length - 1] + suffix;

		var lastScaleY:Float = scale.y;
		var blahblah:String = arraySkin.join('/');

		defaultWidth = 157;
		defaultHeight = 154;
		if(PlayState.isPixelStage) {
			if(isSustainNote) {
				loadGraphic(Paths.image('pixelUI/' + blahblah + 'ENDS'));
				width = width / pixelNotesDivisionValue;
				height = height / 2;
				originalHeightForCalcs = height;
				loadGraphic(Paths.image('pixelUI/' + blahblah + 'ENDS'), true, Math.floor(width), Math.floor(height));
			} else {
				loadGraphic(Paths.image('pixelUI/' + blahblah));
				width = width / pixelNotesDivisionValue;
				height = height / 5;
				loadGraphic(Paths.image('pixelUI/' + blahblah), true, Math.floor(width), Math.floor(height));
			}
			defaultWidth = width;
			setGraphicSize(Std.int(width * PlayState.daPixelZoom * Note.pixelScales[mania]));
			loadPixelNoteAnims();
			antialiasing = false;

			if(isSustainNote) {
				offsetX += lastNoteOffsetXForPixelAutoAdjusting;
				lastNoteOffsetXForPixelAutoAdjusting = (width - 7) * (PlayState.daPixelZoom / 2);
				offsetX -= lastNoteOffsetXForPixelAutoAdjusting;
			}
		} else {
			frames = Paths.getSparrowAtlas('noteskins/' + blahblah);
			loadNoteAnims();
			antialiasing = ClientPrefs.globalAntialiasing;
		}
		if (isSustainNote)
		{
			scale.y = lastScaleY;
			if (ClientPrefs.inputSystem == 'Kade Engine')
			{
				scale.y *= 0.75;
			}
		}
		defScale.copyFrom(scale);
		updateHitbox();

		if(animName != null)
			animation.play(animName, true);

		if (inEditor)
		{
			setGraphicSize(ChartingState.GRID_SIZE, ChartingState.GRID_SIZE);
			updateHitbox();
		}
	}

	private var originalScale:Float = 1;

	private function set_scrollSpeed(value:Float):Float
	{
		scrollSpeed = value;

		if (isSustainNote && (animation.curAnim != null && !animation.curAnim.name.endsWith('end')))
		{
			scale.y = originalScale;
			updateHitbox();

			scale.y *= Conductor.stepCrochet / 100 * 1.05;
			if (PlayState.instance != null)
			{
				scale.y *= scrollSpeed;
			}

			if (PlayState.isPixelStage)
			{
				scale.y *= 1.19;
				scale.y *= (6 / height); // Auto adjust note size
			}
			updateHitbox();

			if (PlayState.isPixelStage)
			{
				scale.y *= PlayState.daPixelZoom;
				updateHitbox();
			}
			updateHitbox();
			// prevNote.setGraphicSize();
		}

		return value;
	}

	function loadNoteAnims() {
		for (i in 0...gfxLetter.length)
			{
				animation.addByPrefix(gfxLetter[i], gfxLetter[i] + '0');
				
				if (isSustainNote)
				{
					animation.addByPrefix(gfxLetter[i] + ' hold', gfxLetter[i] + ' hold');
					animation.addByPrefix(gfxLetter[i] + ' tail', gfxLetter[i] + ' tail');
				}
			}
			
			ogW = width;
			ogH = height;
			if (!isSustainNote)
				setGraphicSize(Std.int(defaultWidth * scales[mania]));
			else
				setGraphicSize(Std.int(defaultWidth * scales[mania]), Std.int(defaultHeight * scales[0]));
			updateHitbox();
	}

	function loadPixelNoteAnims() {
		if(isSustainNote) {
			for (i in 0...gfxLetter.length) {
				animation.add(gfxLetter[i] + ' hold', [i]);
				animation.add(gfxLetter[i] + ' tail', [i + pixelNotesDivisionValue]);
			}
		} else {
			for (i in 0...gfxLetter.length) {
				animation.add(gfxLetter[i], [i + pixelNotesDivisionValue]);
			}
		}
	}

	public function applyManiaChange()
	{
		if (isSustainNote)
			scale.y = 1;
		reloadNote(texture);
		if (isSustainNote)
			offsetX = width / 2;
		if (!isSustainNote)
		{
			var animToPlay:String = '';
			animToPlay = Note.keysShit.get(mania).get('letters')[noteData];
			animation.play(animToPlay);
		}

		if (isSustainNote && prevNote != null)
		{
			animation.play(Note.keysShit.get(mania).get('letters')[noteData] + ' tail');
			if (prevNote.isSustainNote)
			{
				prevNote.animation.play(Note.keysShit.get(mania).get('letters')[noteData] + ' hold');
				prevNote.updateHitbox();
			}
		}

		updateHitbox();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		mania = PlayState.mania;

		if (chara != null && !this.exNote) skin = chara;
		else if (this.exNote && PlayState.dad2 != null) skin = PlayState.dad2.strumSkin;
		else 'normal';

		if (tooLate || (parentNote != null && parentNote.tooLate))
			alpha = 0.3;

		if (isSustainNote)
		{
			if (prevNote != null && prevNote.isSustainNote)
				zIndex = z + prevNote.zIndex;
			else if (prevNote != null && !prevNote.isSustainNote)
				zIndex = z + prevNote.zIndex - 1;
		}
		else
			zIndex = z;

		zIndex += desiredZIndex;
		zIndex -= (mustPress == true ? 0 : 1);

		colorSwap.daAlpha = alphaMod * alphaMod2;

		if (ClientPrefs.inputSystem == "Hypno Input")
		{
			if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset) 
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset))
				canBeHit = true;
			else
				canBeHit = false;
		}
		else
		{
			if (mustPress)
			{
				// ok river
				if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
					&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * earlyHitMult))
					canBeHit = true;
				else
					canBeHit = false;

				if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
					tooLate = true;
			}
			else
			{
				canBeHit = false;

				if (strumTime <= Conductor.songPosition)
					wasGoodHit = true;
			}
		}

		if (mustPress)
		{
			// ok river
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * earlyHitMult))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (isSustainNote && !susActive)
			multAlpha = 0.2;

		if (tooLate && !inEditor)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}