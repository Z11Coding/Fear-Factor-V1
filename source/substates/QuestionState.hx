package substates;
import flixel.input.keyboard.FlxKey;

class QuestionState extends MusicBeatSubstate
{
    var Arrow:Alphabet;
    var Health:Alphabet;
    var Ulta:Alphabet;
    var indicatorThatIDidntThinkINeededToAddButHereWeAre:Alphabet;

    var timerOfDoom:FlxTimer;
    var timeOfDoom:FlxText;
    var bg:FlxSprite;
    var SFX:FlxSound;

    public function new(x:Float, y:Float)
    {
        super();

        PlayState.instance.canPause = false;

        timerOfDoom = new FlxTimer().start(7/PlayState.instance.playbackRate, function(tween:FlxTimer) {punish();});

        bg = new FlxSprite().makeGraphic(FlxG.width*2, FlxG.height*2, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
        bg.screenCenter(XY);
		add(bg);

        timeOfDoom = new FlxText(0, 0, Std.string(timerOfDoom.timeLeft), 32);
        timeOfDoom.cameras = [PlayState.instance.camHUD];
        timeOfDoom.font = Paths.font('SAWesome.ttf');
        timeOfDoom.size = 150;
        timeOfDoom.scrollFactor.set();
        timeOfDoom.screenCenter(XY);
        timeOfDoom.y -= 100;
        //timeOfDoom.x -= 10;
        add(timeOfDoom);

        Arrow = new Alphabet(0, FlxG.height/2, 'Arrow Fade', true);
        Arrow.cameras = [PlayState.instance.camHUD];
        Arrow.scrollFactor.set();
        Arrow.screenCenter(X);
        Arrow.x += 300;
        add(Arrow);

        Health = new Alphabet(0, FlxG.height/2, 'Less Health', true);
        Health.cameras = [PlayState.instance.camHUD];
        Health.scrollFactor.set();
        Health.screenCenter(X);
        Health.x -= 300;
        add(Health);

        Ulta = new Alphabet(0, FlxG.height/2.3, 'The Ultimate Punishment', true);
        Ulta.cameras = [PlayState.instance.camHUD];
        Ulta.scrollFactor.set();
        Ulta.screenCenter(XY);
        Ulta.y -= 1200;
        add(Ulta);

        var keysL:Array<FlxKey>;
        var keysR:Array<FlxKey>;

        keysL = ClientPrefs.keyBinds.get('ui_left').copy();
        keysR = ClientPrefs.keyBinds.get('ui_right').copy();

        indicatorThatIDidntThinkINeededToAddButHereWeAre = new Alphabet(-300, FlxG.height/2, '', true);
        indicatorThatIDidntThinkINeededToAddButHereWeAre.cameras = [PlayState.instance.camHUD];
        indicatorThatIDidntThinkINeededToAddButHereWeAre.scrollFactor.set();
        indicatorThatIDidntThinkINeededToAddButHereWeAre.scaleX = 0.8;
        indicatorThatIDidntThinkINeededToAddButHereWeAre.screenCenter(XY);
        add(indicatorThatIDidntThinkINeededToAddButHereWeAre);
        indicatorThatIDidntThinkINeededToAddButHereWeAre.y -= 300;
        indicatorThatIDidntThinkINeededToAddButHereWeAre.x -= 600;
        indicatorThatIDidntThinkINeededToAddButHereWeAre.text = 'PRESS '+InputFormatter.getKeyName(ClientPrefs.keyBinds.get('ui_left')[0])+'/'+InputFormatter.getKeyName(ClientPrefs.keyBinds.get('ui_left')[1])+' AND '+InputFormatter.getKeyName(ClientPrefs.keyBinds.get('ui_right')[0])+'/'+InputFormatter.getKeyName(ClientPrefs.keyBinds.get('ui_right')[1])+" TO CHOOSE.";

        SFX = new FlxSound().loadEmbedded(Paths.sound('confirmMenu'));
    }

    function doClose() {
        timeOfDoom.alpha = 0;
        FlxTween.tween(bg, {alpha: 0}, 4, {ease: FlxEase.quartInOut});
    }

    function punish() {
        madeChoice = true;
        timerOfDoom.cancel();
        timerOfDoom.destroy();
        FlxTween.tween(Ulta, {y: Ulta.y + 1200, alpha: 1}, 2, {ease: FlxEase.sineOut, onComplete: function(tween:FlxTween) {doClose(); FlxTween.tween(Ulta, {alpha: 0}, 4, {ease: FlxEase.sineOut});}});
        FlxTween.tween(Arrow, {y: Arrow.y + 500}, 2, {ease: FlxEase.sineOut});
        FlxTween.tween(Arrow, {alpha: 0}, 1, {ease: FlxEase.sineOut});
        FlxTween.tween(Health, {y: Health.y - 500}, 2, {ease: FlxEase.sineOut});
        FlxTween.tween(Health, {alpha: 0}, 1, {ease: FlxEase.sineOut});
        PlayState.instance.MaxHP = 0.6;
        PlayState.instance.modManager.setValue('vanish', 1.5, 0);
        PlayState.instance.modManager.setValue('tornado', 1, 0);
        PlayState.instance.modManager.setValue('wave', 2, 0);
        PlayState.instance.modManager.setValue('dizzy', 1, 0);
        FlxTween.num(PlayState.instance.health, 0.6, 1, {ease: FlxEase.sineOut}, function(value:Float) {PlayState.instance.health = value;});
        FlxG.save.data.punish = 'UltaPun';
        FlxG.save.flush();
    }

    var curChoice:Int = 2;
    var madeChoice:Bool = false;
    override function update(elapsed:Float)
    {
        SFX = new FlxSound();
        if (!madeChoice) timeOfDoom.text = Std.string(Std.int(timerOfDoom.timeLeft));
        super.update(elapsed);
        if (bg.alpha == 0) {
            PlayState.instance.canPause = true;
            close();
        }
        
        if (curChoice > 1) curChoice = 0;
        if (curChoice < 0) curChoice = 1;

        if (!madeChoice)
        {
            if (controls.UI_RIGHT_P) curChoice++;
            if (controls.UI_LEFT_P) curChoice--;
        }
        
        switch (curChoice) {
            case 0: 
                Arrow.alpha = 1;
                Health.alpha = 0.4;
            case 1:
                Arrow.alpha = 0.4;
                Health.alpha = 1;
            case 2:
                Arrow.alpha = 0.4;
                Health.alpha = 0.4;
        }

        if (controls.ACCEPT && !madeChoice)
        {
            SFX.play();
            madeChoice = true;
            timerOfDoom.cancel();
            timerOfDoom.destroy();
            switch (curChoice) {
                case 0:
                    FlxTween.tween(Arrow, {x: Arrow.x - 300}, 2, {ease: FlxEase.sineOut, onComplete: function(tween:FlxTween) {FlxTween.tween(Arrow, {alpha: 0}, 1, {ease: FlxEase.sineOut});}});
                    FlxTween.tween(Health, {y: Health.y - 500}, 2, {ease: FlxEase.sineOut});
                    FlxTween.tween(Health, {alpha: 0}, 1, {ease: FlxEase.sineOut});
                    PlayState.instance.modManager.setValue('vanish', 1, 0);
                    FlxG.save.data.punish = 'arrowFade';
                    FlxG.save.flush();
                case 1:
                    FlxTween.tween(Health, {x: Health.x + 300}, 2, {ease: FlxEase.sineOut, onComplete: function(tween:FlxTween) {FlxTween.tween(Health, {alpha: 0}, 1, {ease: FlxEase.sineOut});}});
                    FlxTween.tween(Arrow, {y: Arrow.y + 500}, 2, {ease: FlxEase.sineOut});
                    FlxTween.tween(Arrow, {alpha: 0}, 1, {ease: FlxEase.sineOut});
                    PlayState.instance.MaxHP = 1.3;
                    FlxTween.num(PlayState.instance.health, 1.3, 1, {ease: FlxEase.sineOut}, function(value:Float) {PlayState.instance.health = value;});
                    PlayState.instance.modManager.setValue('tornado', 0.3, 0);
                    PlayState.instance.modManager.setValue('wave', 1, 0);
                    PlayState.instance.modManager.setValue('dizzy', 0.5, 0);
                    FlxG.save.data.punish = 'lessHealth';
                    FlxG.save.flush();
            }
            doClose();
        }
    }
}