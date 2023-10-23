local BfFrames = 0
local DadFrames = 0
local EnableDadBendyFrames = false
local EnableBFBendyFrames = false
local ChangeBendyNotes = true
local BfMaxFrames = 11
local DadMaxFrames = 9
local BeatHit = 0
--original script by bf myt

function onUpdate()
     BfFrames = BfFrames + 0.35
     EnableBFBendyFrames = true
        DadFrames = DadFrames + 0.4
        EnableDadBendyFrames = true
    if EnableBFBendyFrames == true then
        setProperty('boyfriend.animation.curAnim.curFrame',math.min(math.floor(BfFrames), BfMaxFrames))
        setProperty('boyfriend.animation.curAnim.frameRate',0)
    end
    if EnableDadBendyFrames == true then
        setProperty('dad.animation.curAnim.curFrame',math.min(math.floor(DadFrames), DadMaxFrames))
        setProperty('dad.animation.curAnim.frameRate',0)
    end

    if (getProperty('boyfriend.animation.curAnim.name') ~= 'idle-alt') then
        BfMaxFrames = 11
    else
        BfMaxFrames = 9
    end
    if (math.floor(BfFrames) > BfMaxFrames) then
        BfFrames = 0
    end
    if (math.floor(DadFrames) > DadMaxFrames) then
        DadFrames = 0
    end
end

function onStepHit()
    if curStep > 800 and curStep < 1312 or curStep >= 164 and curStep < 288 or curStep == 400 or curStep == 671 or curStep == 864 or curStep == 962 or curStep == 1504 or curStep == 1600 or curStep == 1948 then
        BeatHit = 1
    elseif curStep == 288 or curStep == 608 or curStep == 736 or curStep == 800 or curStep == 928 or curStep == 1312 or curStep == 1440 or curStep == 1568 or curStep == 1632 or curStep == 1696 then
        BeatHit = 2
    elseif curStep == 544 or curStep == 768 or curStep == 1664 or curStep == 1936 or curStep == 2078 then
        BeatHit = 0
    elseif curStep == 1072 and curStep <= 1304 then
        allowParticle = true
    elseif curStep == 1304 then
        allowParticle = false
    elseif allowParticle == true then
        Particle()
    end
end
function onBeatHit()
    if curBeat % BeatHit == 0 then
        triggerEvent('Add Camera Zoom','','')
    end
end
function Particle()
songPos = getSongPosition()
currentBeat = (songPos/100)
  f = f + 1
  sus = math.random(1, 9000)
  makeLuaSprite('part'.. f, 'bendy/particles', math.random(-200, -225,-250,-275,-300), 500)
  doTweenY(sus, 'part'.. f, -900*math.tan((currentBeat+1*0.1)*math.pi), 6)
  addLuaSprite('part'.. f, true)
  setObjectCamera('part', 'hud')
  if f >= 50 then
  f = 1
  end
end