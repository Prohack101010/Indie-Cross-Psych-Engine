function onCreate()
	makeLuaSprite('effect', nil, -700, -500);
	makeGraphic('effect', screenWidth * 2, screenHeight * 2, '646464');
	addLuaSprite('effect', true);
	setProperty('effect.color', getColorFromHex('646464')); -- 646464 707070
	setObjectCamera('effect', 'other')
end
function onUpdatePost()
	if getProperty('effect.alpha') == 1 then
	runTimer('off', 0.9)
setProperty('effect.alpha', 0.99)
end
if getProperty('effect.alpha') == 0 then
runTimer('on', 0.9)
setProperty('effect.alpha', 0.0001)
end
end
function onTimerCompleted(tag, loops, loopsLeft)
if tag == 'off' then
	
	doTweenAlpha('off', 'effect', 0, 2, 'linear');
end
if tag == 'on' then
	doTweenAlpha('on', 'effect', 1, 2, 'linear');
	end
end
function onCreatePost()
    setBlendMode('effect', 'subtract')
    setObjectOrder('effect', 69696969)
end
function onStepHit()
    if curStep == 768 then
    setProperty('effect.visible', false)
    elseif curStep == 1065 then
    setProperty('effect.visible', true)
    end
end