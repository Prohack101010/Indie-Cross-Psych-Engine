function onCreate()
    makeAnimatedLuaSprite('mug', 'cup/Mugman Fucking dies', 1381, 369);
addLuaSprite('mug', true);
addAnimationByPrefix('mug', 'Mugman', 'Mugman', 24, false);
  --background
  makeLuaSprite('back','cup/CH-RN-00',-1050,-750)
  scaleObject('back',3.5,3.5)
  setScrollFactor('back',0.4,0.4)
  makeLuaSprite('mid','cup/CH-RN-01',-1050,-600)
  scaleObject('mid',3.5,3.5)
  setScrollFactor('mid',0.4,0.4)
  makeLuaSprite('floor','cup/CH-RN-02',-1050,-750)
  scaleObject('floor',3.5,3.5)
  makeAnimatedLuaSprite('camera','cup/oldtimey',0,0)
  addAnimationByPrefix('camera','idle','Cupheadshit_gif instance 1',24,true)
  objectPlayAnimation('camera','idle',true)
  setObjectCamera('camera','hud')
  makeAnimatedLuaSprite('rain','cup/rain',0,0)
  addAnimationByPrefix('rain','idle','RainFirstlayer instance 1',15,true)
  objectPlayAnimation('rain','idle',true)
  setObjectCamera('rain','hud')
  addLuaSprite('back',false)
  addLuaSprite('mid',false)
  addLuaSprite('floor',false)
  addLuaSprite('rain',false)
  addLuaSprite('camera',true)
  --close(true);
end
function onCreatePost()
removeLuaSprite('mug', false)
end
function onStepHit()
if curStep == 1072 then
doTweenZoom('camzoom', 'camGame', 0.9, 8, 'linear')
end
if curStep == 1129 then
setProperty("defaultCamZoom",0.9)
end
if curStep == 1208 then
setProperty("defaultCamZoom",0.6)
end
if curStep == 1212 then
setProperty("defaultCamZoom",1.2)
end
if curStep == 1216 then
setProperty("defaultCamZoom",0.5)
doTweenAlpha('byebye', 'knock', 0, 0.4, 'linear');
end
if curStep == 1147 then
makeAnimatedLuaSprite('mug', 'cup/Mugman Fucking dies', 1210, 369);
addLuaSprite('mug', true);
addAnimationByPrefix('mug', 'Mugman', 'Mugman', 24, false);
addAnimationByPrefix('mug', 'MUGMANDEAD YES', 'MUGMANDEAD YES', 24, false);
objectPlayAnimation('mug', 'Mugman', false);
end
end
function onUpdate()
if getProperty('mug.animation.curAnim.name') == 'Mugman' and getProperty('mug.animation.curAnim.finished') then
objectPlayAnimation('mug', 'MUGMANDEAD YES', false);
end
if getProperty('mug.animation.curAnim.curFrame') == 1 and getProperty('mug.animation.curAnim.name') == 'MUGMANDEAD YES' then
triggerEvent('Play Animation','ñ','Dad')
playSound('knockout');
makeAnimatedLuaSprite('knock', 'cup/knock', 25, 55);
addLuaSprite('knock', true);
addAnimationByPrefix('knock', 'A KNOCKOUT', 'A KNOCKOUT', 24, false);
setObjectCamera('knock','other')
end
end