function onCreatePost()
  --background
  makeAnimatedLuaSprite('hall','Nightmare Sans Stage',-300,-250)
  addAnimationByPrefix('hall','idle','Normal',24,false)
  addAnimationByPrefix('hall','floor','Normal',24,true)
  addAnimationByPrefix('hall','wall','sd',15,false)
  objectPlayAnimation('hall','idle',true)
  scaleObject('hall',1.3, 1.3)
  addLuaSprite('hall', false)

  makeAnimatedLuaSprite('effect','Nightmare Sans Stage',-100,300)
  addAnimationByPrefix('effect','dd','dd',32,false)
  setObjectCamera('effect', 'other') --80 425
  addLuaSprite('effect', true)
  scaleObject('effect',1.1, 1.1)
  setBlendMode('effect','add')
  setProperty('effect.alpha', 0)
end
function onStepHit()
  if curStep == 384 then
    objectPlayAnimation('hall','floor',true)
  elseif curStep == 512 then
    objectPlayAnimation('hall','wall',true)
  elseif curStep == 768 then
   objectPlayAnimation('hall','floor',true)
   elseif curStep == 928 then
   objectPlayAnimation('hall','wall',true)
   elseif curStep == 1184 then
   objectPlayAnimation('hall','floor',true)
   elseif curStep == 1440 then
   objectPlayAnimation('hall','wall',true)
  end
end
function onBeatHit()
if getProperty('hall.animation.curAnim.name') == 'wall' and curBeat % 2 == 0 then
    setProperty('effect.alpha', 1)
    else setProperty('effect.alpha', 0)
end
objectPlayAnimation('effect', 'dd', true)
    end