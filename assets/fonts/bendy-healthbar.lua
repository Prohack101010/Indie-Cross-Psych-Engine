--Bendy Healthbar
	--Zoe.exe
-----------------------------------------------------------
--Variables

--local allowCountdownEnd = false -- this us nothing
-----------------------------------------------------------
--HealthBar Create--

function onCreate()
	makeLuaSprite('bendyHB', 'bendyhealthbar', 0, 0)
	setObjectCamera('bendyHB', 'hud')
	setScrollFactor('bendyHB', 0.9, 0.9)
	
	addLuaSprite('bendyHB', true)
end
-----------------------------------------------------------
--HB Offset--

function onCreatePost()
	--Fucker's Healthbar
	setProperty('bendyHB.alpha',  getPropertyFromClass('ClientPrefs', 'healthBarAlpha'))
	setProperty('bendyHB.x', getProperty('healthBar.x') - 40)
	setProperty('bendyHB.angle', getProperty('healthBar.angle'))
	setProperty('bendyHB.y', getProperty('healthBar.y') - 90)
	setProperty('bendyHB.scale.x', getProperty('healthBar.scale.x'))
	setProperty('bendyHB.scale.y', getProperty('healthBar.scale.y'))
	setObjectOrder('bendyHB', 4)
	setObjectOrder('healthBar', 3)
	setObjectOrder('healthBarBG', 2)
	setProperty('healthBar.scale.y', 3)
end
-----------------------------------------------------------
----Never Gonna Give You Up