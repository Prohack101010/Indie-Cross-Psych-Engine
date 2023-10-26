function onCreate()
  --background
  makeLuaSprite('back','cup/nightmarecupbg',-1250,-1300)
  setScrollFactor('back',1.0,1.0)
  scaleObject('back',2.3,2.3)
  makeAnimatedLuaSprite('camera','cup/oldtimey',0,0)
  addAnimationByPrefix('camera','idle','Cupheadshit_gif instance 1',24,true)
  objectPlayAnimation('camera','idle',true)
  setObjectCamera('camera','hud')
  addLuaSprite('back',false)
  addLuaSprite('camera',true)
  close(true);
  end