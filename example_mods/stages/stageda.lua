function onCreate()
  makeLuaSprite('bg','dabg',-350,50)
  scaleObject('bg',1.3,1.3)
  makeLuaSprite('curt1','Curtain1',-300,-170)
  scaleObject('curt1',1.5,1.5)
  makeLuaSprite('curt2','Curtain2',600,-170)
  scaleObject('curt2',1.5,1.5)
  addLuaSprite('bg',false)
  addLuaSprite('curt1',false)
  addLuaSprite('curt2',false)
end
function onStepHit()
  if curStep==687 then
    makeLuaSprite('black','black',0,0)
    setObjectCamera('black','hud')
    addLuaSprite('black',true)
  end
  if curStep==698 then
    doTweenAlpha('black','black',0,1)
  end
  if curStep==700 then
    doTweenX('curt1','curt2',1300,1)
    doTweenX('curt2','curt1',-1100,1)
  end
  end