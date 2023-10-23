function onCreate()
	 makeAnimatedLuaSprite('notesDark', 'bendy/NOTE_nmrunassets', 730, 50);
	 addAnimationByPrefix('notesDark', 'arrowLEFT', 'arrowLEFT',24, true )
	 setObjectCamera('notesDark', 'other')
	 scaleObject('notesDark',0.7,0.7);
	 addLuaSprite('notesDark', true)
setProperty('notesDark.alpha', 0.0001)

	 makeAnimatedLuaSprite('notesDark1', 'bendy/NOTE_nmrunassets', 844, 50);
	 addAnimationByPrefix('notesDark1', 'arrowDown', 'arrowDOWN',24, true )
	 setObjectCamera('notesDark1', 'other')
	 scaleObject('notesDark1',0.7,0.7);
	 addLuaSprite('notesDark1', true)
setProperty('notesDark1.alpha', 0.0001)

	 makeAnimatedLuaSprite('notesDark2', 'bendy/NOTE_nmrunassets', 954, 50);
	 addAnimationByPrefix('notesDark2', 'arrowUP', 'arrowUP',24, true )
	 setObjectCamera('notesDark2', 'other')
	 scaleObject('notesDark2',0.7,0.7);
	 addLuaSprite('notesDark2', true)
setProperty('notesDark2.alpha', 0.0001)

	 makeAnimatedLuaSprite('notesDark3', 'bendy/NOTE_nmrunassets', 1067, 50);
	 addAnimationByPrefix('notesDark3', 'arrowRIGHT', 'arrowRIGHT',24, true )
	 setObjectCamera('notesDark3', 'other')
	 scaleObject('notesDark3',0.7,0.7);
	 addLuaSprite('notesDark3', true)
setProperty('notesDark3.alpha', 0.0001)
end
function toggelDarkNotes()
    doTweenAlpha('dark', 'notesDark', 1,0.5, 'ease')
end
function onTweenCompleted(tag)
    if tag == 'dark' then
   setProperty('notesDark.alpha', 0)
for e = 0, 7 do
	setPropertyFromGroup('strumLineNotes', e, 'texture', 'bendy/NOTE_nmrunassets');
setPropertyFromGroup('unspawnNotes', e, 'texture', 'bendy/NOTE_nmrunassets');
    end
		for i = 0, getProperty('unspawnNotes.length')-1 do
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') or getPropertyFromGroup('unspawnNotes', i, 'mustPress') == false then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'bendy/NOTE_nmrunassets');
			end
	if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'InkNote' then
	setPropertyFromGroup('unspawnNotes', i, 'texture', 'notes/NOTE_nmrunink');
end
	if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'SinNote' then
	setPropertyFromGroup('unspawnNotes', i, 'texture', 'notes/sinNotesDark');
	end
		end
    end
end
function onUpdate()
    noteAlpha = getProperty('notesDark.alpha')
    setProperty('notesDark1.alpha', noteAlpha)
setProperty('notesDark2.alpha', noteAlpha)
setProperty('notesDark3.alpha', noteAlpha)
end
function onStepHit()
	if curStep == 410 or curStep == 537 or curStep == 777 or curStep == 1050 or curStep == 1306 or curStep == 1675 or curStep == 1931 then
	 toggelDarkNotes()
	end
end