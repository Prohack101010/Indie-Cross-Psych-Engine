--[[function onCreate()
    makeLuaText('strumLineNotesoffsx', 'strumLineNotes X: ' .. getPropertyFromGroup('strumLineNotes', i, 'offset.x'), 200, 0, 400)
    makeLuaText('strumLineNotesoffsy', 'strumLineNotes Y: ' .. getPropertyFromGroup('strumLineNotes', i, 'offset.y'), 200, 0, 550)
    addLuaText('strumLineNotesoffsx')
    addLuaText('strumLineNotesoffsy')

end

function onUpdate(elapsed)
for i = 0, getProperty('strumLineNotes.length')+7 do
    setTextString('strumLineNotesoffsx', 'strumLineNotes X: ' .. getPropertyFromGroup('strumLineNotes', i, 'offset.x'))
    setTextString('strumLineNotesoffsy', 'strumLineNotes Y: '.. getPropertyFromGroup('strumLineNotes', i, 'offset.y'))
    setTextSize('strumLineNotesoffsx', 30)
    setTextSize('strumLineNotesoffsy', 30)
        if keyPressed('left') then
            setPropertyFromGroup('strumLineNotes', i, 'offset.x',getPropertyFromGroup('strumLineNotes', i, 'offset.x') +1)
        elseif keyPressed('right') then
            setPropertyFromGroup('strumLineNotes', i, 'offset.x',getPropertyFromGroup('strumLineNotes', i, 'offset.x') -1)
        elseif keyPressed('up') then
            setPropertyFromGroup('strumLineNotes', i, 'offset.y',getPropertyFromGroup('strumLineNotes', i, 'offset.y') +1)
        elseif keyPressed('down') then
            setPropertyFromGroup('strumLineNotes', i, 'offset.y',getPropertyFromGroup('strumLineNotes', i, 'offset.y') -1)
        end
    end
end
function onUpdatePost(elapsed)
        if getPropertyFromClass("flixel.FlxG","keys.justPressed.A") and keyPressed('space') then
            setPropertyFromGroup('strumLineNotes.x',getProperty('strumLineNotes.x')-9)
        elseif getPropertyFromClass("flixel.FlxG", "keys.justPressed.D") and keyPressed('space') then
            setPropertyFromGroup('strumLineNotes.x',getProperty('strumLineNotes.x')+9)
        elseif getPropertyFromClass("flixel.FlxG", "keys.justPressed.W") and keyPressed('space') then
            setPropertyFromGroup('strumLineNotes.y',getProperty('strumLineNotes.y')-9)
        elseif getPropertyFromClass("flixel.FlxG", "keys.justPressed.S") and keyPressed('space') then
            setPropertyFromGroup('strumLineNotes.y',getProperty('strumLineNotes.y')+9)
        end
    end]]