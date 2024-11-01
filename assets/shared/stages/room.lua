function onCreate()
    makeLuaSprite("bg", 'stages/room/IMG_0826', -100, -200)
    addLuaSprite('bg')
    
    makeLuaSprite("crossDimentionalPortal", 'stages/room/IMG_0828', -100, -200)
    scaleObject('crossDimentionalPortal', 1.0, 1.0, true)
    --addLuaSprite('crossDimentionalPortal')

    makeLuaSprite("windows10", 'stages/room/IMG_0829', -100, -200)
    setBlendMode("windows10", "add")
    addLuaSprite('windows10', true)

    makeLuaText('where?', 'YOU ARE HERE', 1500, -430, -800)
    setObjectCamera('where?', 'hud')
    setTextSize("where?", 40)
    setTextFont("where?", "Scream.ttf")
    addLuaText('where?')
    setProperty("skipCountdown", true)
end

function onCreatePost()
    queueEase(1, 16, 'opponentSwap', 1, 'sineInOut', -1, 0)
    queueEase(1, 16, 'centerrotateY', 360, 'sineInOut', -1, 0)
    setProperty("camGame.zoom", 5)
    triggerEvent("Fade Out", 0.001)
    allowZoom = false
end

function onSongStart()
    setTextFont("lyrics", "Scream.ttf")
    setTextFont("scoreTxt", "Scream.ttf")
    setTextFont("botplayTxt", "Scream.ttf")
    setTextFont("skipText", "Scream.ttf")
    setTextFont("timeTxt", "Scream.ttf")
    triggerEvent("Fade In", stepCrochet*0.001*256)
    zoomEvent(1.2, stepCrochet*0.001*256)
end

function onStepHit()
    if curStep == 8 then
        doTweenY('who?', 'where?', 200, 2, 'quadOut')
    end
    if curStep == 64 then
        doTweenY('who?', 'where?', -350, 2, 'elasticInOut')
    end
    if curStep == 2319 then
        triggerEvent("Fade Out", 0.001)
    end
    if curStep == 1827 then
        allowZoom = false
        zoomEvent(getProperty("camGame.zoom") + 0.09,0.000001)
        setProperty("camHUD.zoom", getProperty("camHUD.zoom") - 0.09)
    end
    if curStep == 1830 then
        zoomEvent(getProperty("camGame.zoom") + 0.9,0.000001)
        setProperty("camHUD.zoom", getProperty("camHUD.zoom") - 0.09)
    end
    if curStep == 1834 then
        zoomEvent(getProperty("camGame.zoom") + 0.9,0.000001)
        setProperty("camHUD.zoom", getProperty("camHUD.zoom") - 0.09)
    end
    if curStep == 1836 then
        allowZoom = true
        zoomEvent(1.4, 0.1)
    end
    if curStep == 1838 then
        allowZoom = true
        setProperty("camGame.zoom", getProperty("camGame.zoom") - 0.19)
        setProperty("camHUD.zoom", getProperty("camHUD.zoom") - 0.19)
    end
end

function onUpdatePost()
    if allowZoom then
        if getProperty("camGame.zoom") > getProperty('defaultCamZoom') then
            doTweenZoom('camResetGame', 'camGame', getProperty('defaultCamZoom'), 1, 'sineOut')
            doTweenZoom('camResetHUD', 'camHUD', 1, 1, 'sineOut')
        end
        setProperty('camZoomingMult', 0)
    else
        setProperty('camZoomingMult', 1)
    end
end

function zoomEvent(v1,v2)

    if v2 == '' or v2 == nil then
        setProperty("defaultCamZoom",v1)
        setProperty('camGame.zoom', v1)
    else
        doTweenZoom('camz','camGame',tonumber(v1),tonumber(v2),'sineInOut')
    end
end

function onTweenCompleted(name)
    if name == 'camz' then
        setProperty("defaultCamZoom",getProperty('camGame.zoom')) 
    end
end