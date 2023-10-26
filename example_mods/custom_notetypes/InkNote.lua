function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is an Instakill Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'InkNote' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'yepThisIsNothing');

			setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true); --Miss has no penalties
			setPropertyFromGroup('unspawnNotes', i, 'hitHealth', '0.023'); --Default value is: 0.023, health gained on hit

			setPropertyFromGroup('unspawnNotes', i, 'missHealth', '0.0475'); --Default value is: 0.0475, health lost on miss'
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', 'yepThisIsNothing')
			end

		end
	end
	function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'InkNote' then
--	  playSound('inked')
--	--debugPrint('Script started!')
end
end
end
