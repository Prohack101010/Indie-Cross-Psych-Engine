composer = 'theinnuendo & saster - '
IntroSubTextSize = 40;
IntroTagWidth = 25;
function onSongStart()

	makeLuaSprite('JukeBox', 'musicBar', 0-IntroTagWidth, 15)
	setObjectCamera('JukeBox', 'other')
	setProperty('JukeBox.y', 450);
	setProperty('JukeBox.alpha', 0.7);
	setProperty('JukeBox.x', 1400);
	addLuaSprite('JukeBox', true)

	makeLuaText('JukeBoxSubText', composer.. songName, 0-IntroTagWidth, 60)

	setTextAlignment('JukeBoxSubText', 'left')
setTextFont('JukeBoxSubText', 'ComicSansMS3.ttf')
	setObjectCamera('JukeBoxSubText', 'other')
	setProperty('JukeBoxSubText.alpha', 0.7);
	setTextSize('JukeBoxSubText', IntroSubTextSize)
	setProperty('JukeBoxSubText.y', 445);
	setProperty('JukeBoxSubText.x', 1400);
	addLuaText('JukeBoxSubText')
	doTweenX('MoveInTwo', 'JukeBox', 550, 1, 'CircInOut')
	doTweenX('MoveInFour', 'JukeBoxSubText', 630, 1, 'CircInOut')
	runTimer('JukeBoxWait', 3, 1)
	runTimer('goodbyejuke', 6)
end
function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'JukeBoxWait' then
		doTweenX('MoveOutTwo', 'JukeBox', 1300, 1.5, 'CircInOut')
		doTweenX('MoveOutFour', 'JukeBoxSubText', 1380, 1.5, 'CircInOut')
	end
	if tag == 'goodbyejuke' then
		removeLuaSprite('JukeBox', true)
		removeLuaText('JukeBoxSubText', true)
	end
end