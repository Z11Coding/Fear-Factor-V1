function onCreate()
    makeLuaSprite("bg", 'stages/street/night', 0, 0)
    scaleObject('bg', 0.9, 0.9, true)
    screenCenter("bg", 'xy')

    makeLuaSprite("house", 'stages/street/home1', -1500, -200)
    scaleObject('house', 0.9, 0.9, true)

    makeLuaSprite("other house", 'stages/street/home2', 0, -200)
    scaleObject('other house', 0.9, 0.9, true)

    makeLuaSprite("other other house", 'stages/street/home3', -3000, -200)
    scaleObject('other other house', 0.9, 0.9, true)

    makeLuaSprite("copy of other other house", 'stages/street/home3', 1500, -200)
    scaleObject('copy of other other house', 0.9, 0.9, true)

    makeLuaSprite("light", 'stages/street/lights', 520, -80)
    scaleObject('light', 0.9, 0.9, true)

    makeLuaSprite("ground", 'stages/street/streets', -2000, -280)
    scaleObject('ground', 0.9, 0.9, true)

    makeLuaSprite("fence", 'stages/street/fences', -1500, 500)
    scaleObject('fence', 0.9, 0.9, true)


    addLuaSprite('bg')
    addLuaSprite('house')
    addLuaSprite('other house')
    addLuaSprite('other other house')
    addLuaSprite('copy of other other house')
    addLuaSprite('fence')
    addLuaSprite('ground')
    addLuaSprite('light', true)

    makeLuaText('where?', 'YOU ARE HERE', 1500, -430, -800)
    setObjectCamera('where?', 'hud')
    setTextSize("where?", 40)
    setTextFont("where?", "ItFont-qVv0.ttf")
    addLuaText('where?')
    setProperty('defaultCamZoom', 0.3)
end

function onCreatePost()
    queueEase(1, 16, 'opponentSwap', 1, 'sineInOut', -1, 0)
    queueEase(1, 16, 'centerrotateY', 360, 'sineInOut', -1, 0)
    queueSet(1279, 'drunk', 0.5, -1)
    setTextFont("scoreTxt", "ItFont-qVv0.ttf")
    setTextFont("botplayTxt", "ItFont-qVv0.ttf")
    setTextFont("lyrics", "ItFont-qVv0.ttf")
    setTextFont("skipText", "ItFont-qVv0.ttf")
    setTextFont("timeTxt", "ItFont-qVv0.ttf")
    triggerEvent("Fade Out", 0.00001)
end

function onSongStart()
    --setProperty('camFollowPos.y', getProperty('camFollowPos.y') - 1500)
    triggerEvent("Fade In", 12)
    zoomEvent(0.6, 12)
end

function onUpdate()
    setProperty('gf.flipX', false)
end

function onStepHit()
    if curStep == 8 then
        doTweenY('who?', 'where?', 200, 2, 'quadOut')
    end
    if curStep == 64 then
        doTweenY('who?', 'where?', -350, 2, 'elasticInOut')
    end
    if curStep == 1807 then
        zoomEvent(0.3, 12)
        triggerEvent("Fade Out", 10)
    end
end

function zoomEvent(v1,v2)

    if v2 == '' then
        setProperty("defaultCamZoom",v1)
    else
        doTweenZoom('camz','camGame',tonumber(v1),tonumber(v2),'sineInOut')
    end
end

function onTweenCompleted(name)
    if name == 'camz' then
        setProperty("defaultCamZoom",getProperty('camGame.zoom')) 
    end
end