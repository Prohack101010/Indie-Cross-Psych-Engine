function onCreate()
--effect
makeLuaSprite('bbg','bendy/BACKBACKgROUND',-275,-800)
	makeLuaSprite('effect', nil, -700, -500);
	makeGraphic('effect', screenWidth * 2, screenHeight * 2, '707070');
	addLuaSprite('effect', true);
	setProperty('effect.color', getColorFromHex('707070')); -- 646464 707070
	setObjectCamera('effect', 'other')
  --background
  makeLuaSprite('bg','bendy/BackgroundwhereDEEZNUTSfitINYOmOUTH',-600,-800)
 --scaleObject('bbg', 2, 2)
  makeLuaSprite('mid','bendy/MidGround',-600,-800)
  --scaleObject('mid', 2, 2)
  makeLuaSprite('fg','bendy/Foreground',-600,-640)
  --scaleObject('fg', 2, 2)
  makeLuaSprite('nuts','bendy/NUTS',-600,-824)
  --scaleObject('nuts', 4, 4)
  makeLuaSprite('chains','bendy/Chains',-600,-600)
  --scaleObject('chains', 4, 4)
  makeAnimatedLuaSprite('sammy','bendy/SammyBg',600,50)
  addAnimationByPrefix('sammy','idle','Sam',24,true)
  objectPlayAnimation('sammy','idle',true)
  addLuaSprite('bbg',false)
  addLuaSprite('bg',false)
  addLuaSprite('sammy',false)
  addLuaSprite('mid',false)
  addLuaSprite('fg',true)
  addLuaSprite('chains',true)
  addLuaSprite('nuts',false)
 -- close(true);
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
    setProperty('boyfriend.x', 1347)
    setProperty('effect.alpha', 0)
    setObjectOrder('bg', getObjectOrder('bbg')+2)
    setObjectOrder('sammy', getObjectOrder('bg')+1)
    setObjectOrder('mid', getObjectOrder('sammy')+1)
    setObjectOrder('fg', getObjectOrder('mid')+1)
    setObjectOrder('effect', 69696969)
    end