function onCreate()
    makeLuaSprite("bg", 'stages/saw/tiles', 0, 0)
    scaleObject('bg', 0.9, 0.9, true)
    screenCenter("bg", 'xy')

    makeLuaSprite("glow", 'stages/saw/green_glow', -1900, -1400)
    scaleObject('glow', 0.9, 0.9, true)
    setBlendMode("glow", 'add')

    makeLuaSprite("pipe", 'stages/saw/pipe_shaded', 1400, 0)
    scaleObject('pipe', 0.9, 0.9, true)

    addLuaSprite('bg')
    addLuaSprite('pipe')
    addLuaSprite('glow', true)
end

function onCreatePost()
    if not middlescroll then
        setValue('transformX', 3000, 1)
        setValue('transformX', -325, 0)
    end
    triggerEvent("Fade Out", 0.00001)
    setTextFont("scoreTxt", "SAWesome.ttf")
    setTextFont("botplayTxt", "SAWesome.ttf")
    setTextFont("skipText", "SAWesome.ttf")
    setTextFont("timeTxt", "SAWesome.ttf")
    setProperty('boyfriend.visible', false)
end

function onUpdatePost()
    setTextFont("lyrics", "SAWesome.ttf")
end

function onStepHit()
    if curStep == 1 then
        zoomEvent(0.7, 10)
        triggerEvent("Fade In", 10)
    end
    if curStep == 1280 then
        triggerEvent("Fade Out", 0.001)
    end
end

function zoomEvent(v1,v2)
    if v2 == '' then
        setProperty("defaultCamZoom",v1)
    else
        doTweenZoom('camz','camGame',tonumber(v1),tonumber(v2),'sineInOut')
        setProperty("defaultCamZoom",v1)
    end
end

function onTweenCompleted(name)
    if name == 'camz' then
        setProperty("defaultCamZoom",getProperty('camGame.zoom'))
    end
end