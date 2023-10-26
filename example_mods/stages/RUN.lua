function onCreate()
	-- background shit
	
	 makeAnimatedLuaSprite('BendyBGRun', 'hallway', -13050, 400);
	 addAnimationByPrefix('BendyBGRun','Loop1','Loop01 instance 1',24,true);
	 addAnimationByPrefix('BendyBGRun','Loop2','Loop02 instance 1',24,true);
	 addAnimationByPrefix('BendyBGRun','Loop3','Loop03 instance 1',24,true);
	 addAnimationByPrefix('BendyBGRun','Loop4','Loop03 instance 1',24,true);
	 addAnimationByPrefix('BendyBGRun','Loop5','Loop03 instance 1',24,true);
	 addAnimationByPrefix('BendyBGRun','Tunnel','Tunnel instance 1',24,true);
	 objectPlayAnimation('BendyBGRun','Loop1',true);
	 scaleObject('BendyBGRun',2.3,2.3);
	 setLuaSpriteScrollFactor('BendyBGRun',0,1)
	 addLuaSprite('BendyBGRun',false);

	 makeAnimatedLuaSprite('BendyBGRunDark', 'hallway_but_Dark', -300, 650);
	 addAnimationByPrefix('BendyBGRunDark','Loop1','RunLol Hallway instance 1',50,true);
	 objectPlayAnimation('BendyBGRunDark','Loop1',true);
	 scaleObject('BendyBGRunDark',1.6,1.6);
	 setLuaSpriteScrollFactor('BendyBGRunDark',0,1)
 
	 makeAnimatedLuaSprite('Transition', 'Trans',-250, -150);
	 addAnimationByPrefix('Transition','Trans','beb instance 1',24,false);
	 objectPlayAnimation('Transition','Trans',false);
	 setLuaSpriteScrollFactor('Transition',0,0)
	 scaleObject('Transition',1.4,1.4);
	 setObjectCamera('Transition', 'hud');
	 addLuaSprite('Transition', true)
setProperty('Transition.alpha', 0.0001)
	 makeLuaSprite('StairsBG', 'scrollingBG',-700, -500);
	 setLuaSpriteScrollFactor('StairsBG',0,0)
	 scaleObject('StairsBG',1.4,1.4);
setProperty('StairsBG.alpha', 0.0001)
addLuaSprite('StairsBG', false)
	 makeLuaSprite('StairsBG2', 'scrollingBG',-700, -3283);
	 setLuaSpriteScrollFactor('StairsBG2',0,0)
	 scaleObject('StairsBG2',1.4,1.4);
	 setProperty('StairsBG2.alpha', 0.0001)
addLuaSprite('StairsBG2', false)
	if not lowQuality then	
	 makeLuaSprite('gradient', 'gradient',-800, -500);
	 setLuaSpriteScrollFactor('gradient',0,0)
	 scaleObject('gradient',1.6,1.6);
	 addLuaSprite('gradient', true)
	 setProperty('gradient.alpha', 0.0001)
	end
	makeLuaSprite('stairs', 'stairs',-700, -150);
	setLuaSpriteScrollFactor('stairs',0,0)
	scaleObject('stairs',1.8,1.8);
addLuaSprite('stairs', true)
setProperty('stairs.alpha', 0.0001)
	makeLuaSprite('GayBG', 'C_00',-700, -600);
	setLuaSpriteScrollFactor('GayBG',0,0)
	scaleObject('GayBG',2,2);
setProperty('GayBG.alpha', 0.0001)
addLuaSprite('GayBG', false)

	makeLuaSprite('GayBGGround', 'C_01',-1500,0);
	setLuaSpriteScrollFactor('GayBGGround',0,1)
	scaleObject('GayBGGround',1.8,1.8);
setProperty('GayBGGround.alpha', 0.0001)
addLuaSprite('GayBGGround', true)
	makeLuaSprite('GayBGGround2', 'C_01',1950,0);
	setLuaSpriteScrollFactor('GayBGGround2',0,1)
	scaleObject('GayBGGround2',1.8,1.8);
setProperty('GayBGGround2.alpha', 0.0001)
addLuaSprite('GayBGGround2', true)
	makeLuaSprite('GayBG2', 'C_02',0, -600);
	setLuaSpriteScrollFactor('GayBG2',0,0)
	scaleObject('GayBG2',1.5,1.5);
setProperty('GayBG.alpha', 0.0001)
addLuaSprite('GayBG2', false)
    BGY = -1000
	stairsY = -2200;
	playerX = -400;
	platformX = -500;

end

function onUpdate(elapsed)

	if curStep == 415 then
		objectPlayAnimation('BendyBGRun','Tunnel',true);
		setProperty('defaultCamZoom',0.65)
	end

	if curStep == 543 then
		objectPlayAnimation('BendyBGRun','Loop2',true);
		setProperty('defaultCamZoom',0.75)
	end

	if curStep == 410 or curStep == 537 or curStep == 777 or curStep == 1050 or curStep == 1306 or curStep == 1675 or curStep == 1931 then
     setProperty('Transition.alpha', 1)
	 objectPlayAnimation('Transition','Trans',true);
	 runTimer('TransitionDestroy',1.5)
	end

	if curStep == 783 then
		setProperty('BendyBGRun.alpha', 0.0001)
		setProperty('StairsBG.alpha', 1)
		setProperty('StairsBG2.alpha', 1)
		setProperty('stairs.alpha', 1)
		setProperty('defaultCamZoom',0.6)

		if not lowQuality then
		setProperty('gradient.alpha', 1)
		end
	end

	
	if curStep >= 783 and curStep <=1055 then
		setProperty('StairsBG.y',BGY)
		setProperty('StairsBG2.y',BGY - 2093)
		setProperty('stairs.y',stairsY)
		setProperty('boyfriend.x',playerX)
		setProperty('boyfriend.y',stairsY + 1950 - (playerX/2.3 + 150))
		setProperty('dad.x',playerX - 1040)
		setProperty('dad.y',stairsY + 2000 - (playerX/2.3 + 50))
		triggerEvent('Camera Follow Pos',1200,1000)
   
		BGY = BGY + 2
		stairsY = stairsY + 20
		playerX = playerX + 20
	   end

	if curStep == 1056 then
	 removeLuaSprite('StairsBG',true)
     removeLuaSprite('StairsBG2',true)
	 setProperty('gradient.alpha', 0.0001)
	 removeLuaSprite('stairs',true)
	 
     if not lowQuality then
		setProperty('GayBG.alpha', 1)
	  end
	 setProperty('GayBGGround.alpha', 1)
	 setProperty('GayBGGround2.alpha', 1)
	 setProperty('GayBG2.alpha', 1)
 
	 setProperty('defaultCamZoom',0.5)
	end

	if curStep >= 1056 and curStep <= 1310 then
       platformX = platformX - 20
	   setProperty('boyfriend.x',1800)
	   setProperty('boyfriend.y',1330)
	   setProperty('dad.x',460)
	   setProperty('dad.y',1100)

	   setProperty('GayBGGround.x',platformX)
	   setProperty('GayBGGround2.x',platformX + 2200)
	   setProperty('GayBG2.x',getProperty('GayBG2.x') - 0.25)
	   setProperty('GayBG.x',getProperty('GayBG.x') - 0.25)
	end

	if curStep == 1311 then
		removeLuaSprite('GayBGGround',true);
		removeLuaSprite('GayBGGround2',true);
		removeLuaSprite('GayBG',true);
		removeLuaSprite('GayBG2',true);
		setProperty('boyfriend.x',1800)
		setProperty('boyfriend.y',1330)
		setProperty('dad.x',460)
		setProperty('dad.y',1100)
		setProperty('BendyBGRun.alpha', 1)
		triggerEvent('Camera Follow Pos','','')
   
		setProperty('defaultCamZoom',0.75)
	end

	if curStep >= 1311 then
		setProperty('boyfriend.x',1750)
		setProperty('boyfriend.y',1360)
		setProperty('dad.x',460)
		setProperty('dad.y',1050)

	end

	if curStep == 1680 then
		objectPlayAnimation('BendyBGRun','Tunnel',true);
		setProperty('defaultCamZoom',0.65)
	end

	if curStep == 1937 then
		objectPlayAnimation('BendyBGRun','Loop3',true);
		setProperty('defaultCamZoom',0.75)
	end

	if stairsY >= 2000 then
		stairsY = -2200
		playerX = -400
	end

	if platformX <= -2000 then
		platformX = -1600
	end

	if BGY >= 1600 then 
		BGY = -1000
	end
end

function onTimerCompleted(tag)
	if tag == 'TransitionDestroy' then
		setProperty('Transition.alpha', 0.0001)
	end
end
function onCreatePost()
    --preload stuff
setProperty('stairs.alpha', 0.0001)
setProperty('StairsBG.alpha', 0.0001)
setProperty('StairsBG2.alpha', 0.0001)
setProperty('GayBG.alpha' ,0.0001)
setProperty('GayBG2.alpha' ,0.0001)
setProperty('GayBGGround.alpha', 0.0001)
setProperty('GayBGGround2.alpha' ,0.0001)
setProperty('Transition.alpha' ,0.0001)
setProperty('gradient.alpha' ,0.0001)
end