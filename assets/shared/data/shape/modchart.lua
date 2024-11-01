local localStep = 0
function onCreatePost()
    if not middlescroll then
        setValue('transformX', 3000, 1)
        setValue('transformX', -325, 0)
    end
    setTextFont("scoreTxt", "ITC Serif Gothic Std Heavy.otf")
    setTextFont("botplayTxt", "ITC Serif Gothic Std Heavy.otf")
    setTextFont("lyrics", "ITC Serif Gothic Std Heavy.otf")
    setTextFont("skipText", "ITC Serif Gothic Std Heavy.otf")
    setTextFont("timeTxt", "ITC Serif Gothic Std Heavy.otf")

    if getPropertyFromClass('backend.ClientPrefs', 'data.modcharts') then
        queueEase(0, 256, 'receptorAngle', 360*10, 'sineOut')
        queueEase(0, 256, 'haloRadiusX', 0, 'sineInOut')
        queueEase(0, 256, 'haloRadiusZ', 0, 'sineInOut')
        queueEase(0, 256, 'haloSpeed', 0, 'sineInOut')
        queueEase(0, 256, 'mini', 0, 'sineInOut')

        queueEase(1536, 1540, 'fieldYaw', -360, 'sineInOut')
        queueEase(1536, 1540, 'fieldPitch', 66, 'sineInOut')
        queueEase(1536, 1540, 'mini', 0.25, 'backOut')
        queueEase(1536, 1540, 'twirl', 1, 'backOut')
        queueSet(1536, 'drawDistance', 1750)

        queueEase(1660, 1660 + 4, 'fieldYaw', 360, 'sineInOut')
        queueEase(1660, 1660 + 4, 'fieldPitch', -66, 'sineInOut')

        queueEase(1788, 1788 + 4, 'fieldYaw', 600, 'sineInOut')
        queueEase(1788, 1788 + 4, 'fieldPitch', 39, 'sineInOut')

        queueEase(1916, 1916 + 4, 'fieldYaw', 10, 'sineInOut')
        queueEase(1916, 1916 + 4, 'fieldPitch', 130, 'sineInOut')
        queueEase(1916, 1916 + 4, 'receptorScroll', 1, 'sineInOut')

        queueEase(2044, 2044 + 4, 'fieldYaw', 0, 'sineInOut')
        queueEase(2044, 2044 + 4, 'fieldPitch', 0, 'sineInOut')
        queueEase(2044, 2044 + 4, 'twirl', 0, 'sineInOut')
        queueEase(2044, 2044 + 4, 'dizzy', 1, 'sineInOut')
        queueEase(2044, 2044 + 4, 'flaccid', 2, 'sineInOut')
        queueEase(2044, 2044 + 4, 'fieldRoll', 90, 'sineInOut')
        queueEase(2044, 2044 + 4, 'receptorScroll', 0, 'sineInOut')

        queueEase(2172, 2172 + 4, 'fieldPitch', 0, 'sineInOut')
        queueEase(2172, 2172 + 4, 'flaccid', 4, 'sineInOut')
        queueEase(2172, 2172 + 4, 'fieldRoll', 180, 'sineInOut')
        queueEase(2172, 2172 + 4, 'flip', 1, 'sineInOut')

        queueEase(2300, 2300 + 4, 'fieldPitch', 180, 'sineInOut')
        queueEase(2300, 2300 + 4, 'flaccid', 6, 'sineInOut')
        queueEase(2300, 2300 + 4, 'fieldRoll', 270, 'sineInOut')
        queueEase(2300, 2300 + 4, 'flip', 0, 'sineInOut')
        queueEase(2300, 2300 + 4, 'invert', 1, 'sineInOut')

        queueEase(2428, 2428 + 4, 'fieldPitch', 8, 'sineInOut')
        queueEase(2428, 2428 + 4, 'flaccid', 8, 'sineInOut')
        queueEase(2428, 2428 + 4, 'fieldRoll', 50, 'sineInOut')

        queueEase(2536, 2536 + 8, 'fieldPitch', 0, 'sineInOut')
        queueEase(2536, 2536 + 8, 'flaccid', 0, 'sineInOut')
        queueEase(2536, 2536 + 8, 'fieldRoll', 0, 'sineInOut')
        queueEase(2536, 2536 + 8, 'invert', 0, 'sineInOut')
        queueEase(2536, 2536 + 8, 'dizzy', 0, 'sineInOut')

        queueEase(2536, 2552, 'drunk', 1, 'sineInOut')
        queueEase(2536, 2552, 'drunkZ', 1, 'sineInOut')

        queueEase(2944, 2945, 'drunk', 0, 'sineInOut')
        queueEase(2944, 2945, 'drunkZ', 0, 'sineInOut')

        queueEase(2944, 3040, 'haloSpeed', 5, 'sineInOut')
        queueEase(2944, 3040, 'haloRadiusX', 5000, 'sineInOut')
        queueEase(2944, 3040, 'haloRadiusZ', 3000, 'sineInOut')

        queueEase(3040, 3070, 'haloSpeed', 0, 'sineInOut')
        queueEase(3040, 3070, 'haloRadiusX', 0, 'sineInOut')
        queueEase(3040, 3070, 'haloRadiusZ', 0, 'sineInOut')
    end
end

function postModifierRegister()
    if getPropertyFromClass('backend.ClientPrefs', 'data.modcharts') then
        addBlankMod("haloRadiusX", 0)
        addBlankMod("haloRadiusZ", 0)
        addBlankMod("haloSpeed", 0)
        addBlankMod("camAngle", 0);
        addBlankMod('flashCol', 0)
    end
end

function onSongStart()
    if getPropertyFromClass('backend.ClientPrefs', 'data.modcharts') then
        if localStep <= 0 then
            setValue('haloRadiusX', 1000, 0)
            setValue('haloRadiusZ', 500, 0)
            setValue('haloSpeed', 3, 0)
            setValue("mini", 1)
            setValue("flashCol", 1)
        end
    end
end

local continuous = {}
local function queueContFunc(startStep, endStep, callback)
    table.insert(continuous, { startStep, endStep, callback })
end

function onUpdate(elapsed)
    for i = #continuous, 1, -1 do
        local data = continuous[i];
        if(curStep >= data[1])then
            if(curStep > data[2])then
                table.remove(continuous, i)
            else
                data[3](getProperty("curDecStep"));
            end
        end
    end
end

function onUpdatePost()
    if getPropertyFromClass('backend.ClientPrefs', 'data.modcharts') then
        setProperty('camGame.angle', getValue('camAngle'))
        setProperty('camHUD.angle', -getValue('camAngle'))
        if getProperty("camGame.zoom") > getProperty('defaultCamZoom') then
            doTweenZoom('camResetGame', 'camGame', getProperty('defaultCamZoom'), 1, 'sineOut')
            doTweenZoom('camResetHUD', 'camHUD', 1, 1, 'sineOut')
        end
        if getValue('stretch') > 0 then
            setValue('stretch', getValue('stretch') - 0.09)
        end
        if getValue('squish') > 0 then
            setValue('squish', getValue('squish') - 0.09)
        end
        if getValue('localrotateY') > 0 then
            setValue('localrotateY', getValue('localrotateY') - 5)
        end
        if getValue('localrotateY') < 0 then
            setValue('localrotateY', getValue('localrotateY') + 5)
        end
        if getValue('localrotateX') > 0 then
            setValue('localrotateX', getValue('localrotateX') - 5)
        end
        if getValue('localrotateX') < 0 then
            setValue('localrotateX', getValue('localrotateX') + 5)
        end
    end
end

function onStepHit()
    if getPropertyFromClass('backend.ClientPrefs', 'data.modcharts') then
        if curStep == 256 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 262 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 280 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 284 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 288 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 294 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 312 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 316 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 320 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)        
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 326 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 344 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 348 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 352 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 358 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 368 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 374 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end

        if curStep == 384 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 390 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 408 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 412 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 416 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 422 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 440 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 444 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 448 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 454 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 472 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 476 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 480 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 486 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 496 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 502 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 1648 then
            setValue('flash', 1)
            setValue('flashR', 10)
            setValue('flashG', 10)
            setValue('flashB', 10)
            queueEase(localStep, localStep + 4, 'flashR', 0, 'sineOut')
            queueEase(localStep, localStep + 4, 'flashG', 0, 'sineOut')
            queueEase(localStep, localStep + 4, 'flashB', 0, 'sineOut')
        end
        if curStep == 1652 then
            setValue('flashR', 10)
            setValue('flashG', 10)
            setValue('flashB', 10)
            queueEase(localStep, localStep + 4, 'flashR', 0, 'sineOut')
            queueEase(localStep, localStep + 4, 'flashG', 0, 'sineOut')
            queueEase(localStep, localStep + 4, 'flashB', 0, 'sineOut')
        end
        if curStep == 1656 then
            setValue('flashR', 10)
            setValue('flashG', 10)
            setValue('flashB', 10)
            queueEase(localStep, localStep + 4, 'flashR', 0, 'sineOut')
            queueEase(localStep, localStep + 4, 'flashG', 0, 'sineOut')
            queueEase(localStep, localStep + 4, 'flashB', 0, 'sineOut')
        end
        if curStep == 1660 then
            setValue('flashR', 10)
            setValue('flashG', 10)
            setValue('flashB', 10)
            queueEase(localStep, localStep + 8, 'flashR', 0, 'sineOut')
            queueEase(localStep, localStep + 8, 'flashG', 0, 'sineOut')
            queueEase(localStep, localStep + 8, 'flashB', 0, 'sineOut')
        end
        
        --One year later lmao
        if curStep == 3072 then
            for col = 0, 3 do
                setValue("transform" .. col .. "Z", 0, 0)
            end
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3078 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3096 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3100 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3104 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3110 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3128 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3132 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3136 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3142 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3160 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3164 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3168 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3174 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3184 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3190 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3200 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3206 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3224 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3228 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3232 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3238 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3256 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3260 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3264 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3270 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3288 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3292 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3296 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3302 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3312 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3318 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3328 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3334 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3352 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3356 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3360 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3366 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3384 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3388 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3392 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3398 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3416 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3420 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3424 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3430 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3430 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3446 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3456 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3462 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3480 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3484 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3488 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3494 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3512 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3516 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3520 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3526 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3544 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3548 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3552 then
            setValue('localrotateY', 50)
            setValue('stretch', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3558 then
            setValue('localrotateY', -50)
            setValue('stretch', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3568 then
            setValue('localrotateX', 50)
            setValue('squish', 1)
            setValue('receptorAngle', 25)
            queueEase(localStep, localStep + 3, 'receptorAngle', 0, 'sineOut')
            setValue('camAngle', 8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end
        if curStep == 3574 then
            setValue('localrotateX', -50)
            setValue('squish', 1)
            setValue('camAngle', -8)
            queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
        end

        if curStep == 3840 then
            setValue('tornado', 1)
            setValue('split', 1)
        end
        if curStep == 3872 then
            queueEase(localStep, localStep + 3, 'split', 0, 'sineOut')
            queueEase(localStep, localStep + 3, 'cross', 1, 'sineOut')
        end
        if curStep == 3872 then
            queueEase(localStep, localStep + 3, 'split', 0, 'sineOut')
            queueEase(localStep, localStep + 3, 'cross', 1, 'sineOut')
        end
        if curStep == 3904 then
            queueEase(localStep, localStep + 3, 'cross', 0, 'sineOut')
            queueEase(localStep, localStep + 3, 'reverse', 1, 'sineOut')
        end
        if curStep == 3936 then
            queueEase(localStep, localStep + 3, 'reverse', 0, 'sineOut')
            queueEase(localStep, localStep + 3, 'alternate', 1, 'sineOut')
        end
        if curStep == 3964 then
            queueEase(localStep, localStep + 3, 'alternate', 0, 'sineOut')
            queueEase(localStep, localStep + 3, 'centered', 1, 'sineOut')
        end

        if curStep == 3968 then
            queueEase(localStep, localStep + 3, 'split', 0, 'sineOut')
            queueEase(localStep, localStep + 3, 'cross', 1, 'sineOut')
        end
        if curStep == 4000 then
            queueEase(localStep, localStep + 3, 'split', 0, 'sineOut')
            queueEase(localStep, localStep + 3, 'cross', 1, 'sineOut')
        end
        if curStep == 4032 then
            queueEase(localStep, localStep + 3, 'cross', 0, 'sineOut')
            queueEase(localStep, localStep + 3, 'reverse', 1, 'sineOut')
        end
        if curStep == 4064 then
            queueEase(localStep, localStep + 3, 'reverse', 0, 'sineOut')
            queueEase(localStep, localStep + 3, 'alternate', 1, 'sineOut')
            queueEase(localStep, localStep + 3, 'invert', 1, 'sineOut')
        end
        if curStep == 4092 then
            queueEase(localStep, localStep + 3, 'alternate', 0, 'sineOut')
            queueEase(localStep, localStep + 3, 'centered', 0, 'sineOut')
            queueEase(localStep, localStep + 3, 'invert', 0, 'sineOut')
        end
        localStep = curStep
    end
end

function onBeatHit()
    if getPropertyFromClass('backend.ClientPrefs', 'data.modcharts') then
        if curBeat >= 128 and curBeat <= 317 or curBeat >= 896 and curBeat <= 959 then
            setValue('drunk', 2)
            queueEase(localStep, localStep + 4, 'drunk', 0, 'sineOut')
            if curBeat % 2 == 0 then
                setValue('camAngle', 8)
                queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
                setValue('stretch', 0.5)
                for i = 0, 3 do
                    setValue('transform'..i..'Y', math.random(-200, 200), 0)
                    setValue('transform'..i..'X', math.random(-200, 200), 0)
                    queueEase(localStep, localStep + 4, 'transform'..i..'Y', 0, 'backOut')
                    queueEase(localStep, localStep + 4, 'transform'..i..'X', 0, 'backOut')
                end
            end
            if curBeat % 2 == 1 then
                setValue('squish', 0.5)
                setValue('camAngle', -8)
                queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')

                for i = 0, 3 do
                    setValue('transform'..i..'Y', math.random(-200, 200), 0)
                    setValue('transform'..i..'X', math.random(-200, 200), 0)
                    queueEase(localStep, localStep + 4, 'transform'..i..'Y', 0, 'backOut')
                    queueEase(localStep, localStep + 4, 'transform'..i..'X', 0, 'backOut')
                end
            end
        end
        if curBeat >= 320 and curBeat <= 383 then
            setValue('drunk', 2)
            queueEase(localStep, localStep + 4, 'drunk', 0, 'sineOut')
            if curBeat % 2 == 0 then
                setValue('camAngle', 8)
                queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')
                setValue('stretch', 0.5)
                for i = 0, 3 do
                    setValue('transform'..i..'Y', math.random(-200, 200), 0)
                    setValue('transform'..i..'X', math.random(-200, 200), 0)
                    queueEase(localStep, localStep + 4, 'transform'..i..'Y', 0, 'backOut')
                    queueEase(localStep, localStep + 4, 'transform'..i..'X', 0, 'backOut')
                end
            end
            if curBeat % 2 == 1 then
                setValue('squish', 0.5)
                setValue('camAngle', -8)
                queueEase(localStep, localStep + 3, 'camAngle', 0, 'sineOut')

                for i = 0, 3 do
                    setValue('transform'..i..'Y', math.random(-200, 200), 0)
                    setValue('transform'..i..'X', math.random(-200, 200), 0)
                    queueEase(localStep, localStep + 4, 'transform'..i..'Y', 0, 'backOut')
                    queueEase(localStep, localStep + 4, 'transform'..i..'X', 0, 'backOut')
                end
            end
        end
    end
end

--[[function goodNoteHit(a, b, c, d)
if c == 'Bullet Note' or c == 'Shotgun Note' then
    for i = 0, 3 do
        setValue('transform'..i..'Y', math.random(-500, 500), 0)
        setValue('transform'..i..'X', math.random(-500, 500), 0)
        queueEase(localStep, localStep + 4, 'transform'..i..'Y', 0, 'backOut')
        queueEase(localStep, localStep + 4, 'transform'..i..'X', 0, 'backOut')
    end
end
end]]

queueContFunc(0, 256, function(step)
    local beat = step / 4;
    for col = 0, 3 do
        local speed = getValue("haloSpeed", 0)
        local input = (col + 1 + beat) * math.rad(360 / 4)
        local radiusX = getValue("haloRadiusX", 0)
        local radiusZ = getValue("haloRadiusZ", 0)
        setValue("transform" .. col .. "X", radiusX * math.sin(input) * speed, 0)
        setValue("transform" .. col .. "Z", radiusZ * math.cos(input) * speed, 0)
    end
end)

queueContFunc(2536, 3070, function(step)
    local beat = step / 4;
    for col = 0, 3 do
        local speed = getValue("haloSpeed", 0)
        local input = (col + 1 + beat) * math.rad(360 / 4)
        local radiusX = getValue("haloRadiusX", 0)
        local radiusZ = getValue("haloRadiusZ", 0)
        setValue("transform" .. col .. "X", radiusX * math.sin(input) * speed, 0)
        setValue("transform" .. col .. "Z", radiusZ * math.cos(input) * speed, 0)
    end
end)

queueContFunc(0, 9999, function(step)
    local beat = (step - 940) / 4;
    beat = beat + 1

    for col = 0, 3 do
        local mu = 1 --col%2==0 and -1 or 1;
        for pN = 0, 1 do
            setValue("transform" .. col .. "X", 32 * math.sin((beat + col * 0.25) * 0.25 * math.pi) * getValue("kadeWave", pN), pN);
            setValue("transform" .. col .. "Y", 32 * mu * math.cos((beat + col * .25) * 0.25 * math.pi) * getValue("kadeWave", pN), pN);
        end
    end
end)