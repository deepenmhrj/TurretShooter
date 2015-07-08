--Turrett     Shooter 
--Deependra Maharjan

display.setStatusBar(display.HiddenStatusBar)
local physics = require("physics")
physics.start()
physics.setDrawMode ("hybrid")

local Shooter
local bullet 
local target
local target1
local rate = 1000
local timer_countdown = 4


local bg              = display.newImage("bg.png",0,500)
local backgroundMusic = audio.loadStream("bgmusic.aiff")
local bulletAudio     = media.newEventSound( "shootmusic.aiff")
local collisionAudio  = media.newEventSound( "explosionmusic.aiff")
local bgmusic         = audio.play(backgroundMusic,{loops = -1})
audio.setVolume(.1)
Shooter 			  = display.newImage("shooter.png", 320,1050)

local score   = display.newText("Score: ", 80, 23.5, 'Courier Bold', 30)
local scoreTF = display.newText('0', 150, 23.5, 'Courier Bold', 30)
scoreTF:setTextColor(0, 255, 0)
score:setTextColor(0, 255, 0)


function targetFall(  )
	local collisionFilter            = {groupIndex = -2}
	rand                             = math.random(0,640)
	rand1                            = math.random(0,640)
	target                           = display.newImage("target.png", rand, -50)
	physics.addBody(target, {filter  = collisionFilter})
	target.id                        = "target"
	target1                          = display.newImage("target1.png", rand1, -50)
	physics.addBody(target1, {filter = collisionFilter})
	target1.id                       = "target"
	rate                             = rate - 135
	if (timer_countdown <=0) then
		target:removeSelf( )
		target1:removeSelf( )
		audio.setVolume( 0 )
	end
end

function game_timer( )
	timer_countdown = timer_countdown - 1
	if (timer_countdown <=0) then


		local removebg = display.newRect( display.contentWidth/2,display.contentHeight/1.85,display.contentWidth, display.contentHeight )
		local game_over  = display.newImage( "gameover.png",  display.contentWidth/2, display.contentHeight/2)
	
	end
end

function tapOccured(event)
	media.playEventSound(bulletAudio)
	Shooter.rotation               = math.deg(math.atan2(event.x - Shooter.x,Shooter.y - event.y))
	bullet                         = display.newImage("bullet.png", 320, 1050)
	bullet.id                      = "bullet"
	changeX                        = event.x - bullet.x
	changeY                        = event.y - bullet.y
	physics.addBody(bullet,{bounce = -1})
	bullet.rotation                = Shooter.rotation 
	bullet:applyLinearImpulse      (changeX/1000, changeY/1000, bullet.x, bullet.y)
end

function onCollision(event)
	if ( event.phase == "began" ) then
        print( "began: " .. event.object1.id .. " and " .. event.object2.id .." at " .. event.object1.x .." and " ..event.object2.y)
    	explosion = display.newImage("explosion.png", event.object1.x, event.object2.y)
    	media.playEventSound(collisionAudio)
		scoreTF.text = tostring(tonumber(scoreTF.text) + 1)
    	scoreTF.x = 150 
		

    elseif (event.phase == "ended") then     
    	print( "ended: " .. event.object1.id .. " and " .. event.object2.id )
    	event.object1: removeSelf()
		event.object2:removeSelf()
        event.object1 = nil
		event.object2 = nil
        explosion:removeSelf()
		explosion = nil
	else
		 explosion:removeSelf()
		explosion = nil
    end
end

Runtime:addEventListener("collision", onCollision)
display.currentStage:addEventListener("tap", tapOccured)
timer.performWithDelay(1000, game_timer,0)
timer.performWithDelay(rate, targetFall,0)



