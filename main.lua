function love.load()
	require 'entity'
	require 'wall'
	require 'camera'
	require 'weapon'
	require 'block'

	-- global variables
	debug = true
	translateX = 0
	translateY = 0

	isPaused = false
	score = 0

	-- initial class instances
	player = Entity.create("Me!", 200, 200)
	enemy = Entity.create("Enemy!", 400, 500)
	fireball = Block.create("damage")

	entities = { player, enemy }	
	walls = { Wall.create("stone", 500, 200, 20, 100), Wall.create("damage", 500, 300, 20, 100), Wall.create("stone", 300, 200, 200, 20) }	
	blocks = { fireball }
	
	var = fireball.name
	notice = ""

	-- audio
	
	do
	    -- will hold the currently playing sources
	    local sources = {}
	 
	    -- check for sources that finished playing and remove them
	    -- add to love.update
	    function love.audio.update()
	        local remove = {}
	        for _,s in pairs(sources) do
	            if s:isStopped() then
	                remove[#remove + 1] = s
	            end
	        end
	 
	        for i,s in ipairs(remove) do
	            sources[s] = nil
	        end
	    end
	 
	    -- overwrite love.audio.play to create and register source if needed
	    local play = love.audio.play
	    function love.audio.play(what, how, loop)
	        local src = what
	        if type(what) ~= "userdata" or not what:typeOf("Source") then
	            src = love.audio.newSource(what, how)
	            src:setLooping(loop or false)
	        end
	 
	        play(src)
	        sources[src] = src
	        return src
	    end
	 
	    -- stops a source
	    local stop = love.audio.stop
	    function love.audio.stop(src)
	        if not src then return end
	        stop(src)
	        sources[src] = nil
	    end
	end
	sword_sound = love.audio.newSource("assets/sounds/powerup.wav", "static")


end

function love.update(dt)
	if not isPaused then
		notice = ""

		checkKeys(dt)

		for k,v in ipairs(entities) do
			v:update(dt)
			if v ~= player and distance(v.x+v.w/2, v.y+v.h/2, player.x+player.w/2, player.y+player.h/2) < v.range then
				player.health = player.health - v.damage * dt
			end
		end
		for k,v in ipairs(walls) do
			v:update(dt)
		end
		for k,v in ipairs(blocks) do
			v:update(dt)
		end

	else
		notice = "PAUSED"
		if (player.health <= 0) then
			notice = "GAME OVER, BUB!\nHit 'R' to try again!"
		end
	end
end

function love.draw(dt)
	love.graphics.push()
	translateX = love.graphics.getWidth()/2-player.x-player.w/2
	translateY = love.graphics.getHeight()/2-player.y-player.h/2
	love.graphics.translate(translateX, translateY)
	-----------------------------------
	local angle = math.atan2((love.mouse.getY()-translateY - (player.y+player.h/2)), (love.mouse.getX()-translateX - (player.x+player.w/2)))
	love.graphics.setColor(255, 255, 255, 60)
	love.graphics.arc("line", player.x+player.w/2, player.y+player.h/2, player.range, angle-player.fov, angle+player.fov)
	love.graphics.setColor(255, 255, 255, 255)

	for k,v in ipairs(entities) do
		v:draw(dt)
		local mouse_angle = math.atan2((love.mouse.getY()-translateY - (player.y+player.h/2)), (love.mouse.getX()-translateX - (player.x+player.w/2)))
		local entity_angle = math.atan2( (v.y+v.h/2) - (player.y+player.h/2), (v.x+v.w/2) - (player.x+player.w/2))
		if v ~= player and distance(player.x+player.w/2, player.y+player.h/2, v.x+v.w/2, v.y+v.h/2) < player.range and math.abs(mouse_angle-entity_angle) < player.fov then
			--love.graphics.setColor(255, 100, 100, 255)
			--love.graphics.arc("fill", player.x+player.w/2, player.y+player.h/2, player.range, entity_angle-.01, entity_angle+.01)
			--love.graphics.setColor(255, 255, 255, 255)
		end
	end
	for k,v in ipairs(walls) do
		v:draw(dt)
	end
	for k,v in ipairs(blocks) do
		v:draw(dt)
	end
	-- GUI
	love.graphics.circle("line", 0,0,5)
	love.graphics.circle("line", love.mouse.getX()-translateX, love.mouse.getY()-translateY, 5)
	love.graphics.line(player.x+player.w/2, player.y+player.h/2, love.mouse.getX()-translateX, love.mouse.getY()-translateY)

	-- DEBUG
	love.graphics.pop()
	love.graphics.print("Score: "..score, 5, 5)
	love.graphics.print(notice, 5, 20)

	love.graphics.print("FPS: "..love.timer.getFPS(), 800, 0)
	if debug then
		love.graphics.print("Var: "..var, 800, 15)
		love.graphics.print("Entities: "..#entities, 800, 30)

		love.graphics.print("Actual:"..math.floor(love.mouse.getX()-translateX)..","..math.floor(love.mouse.getY()-translateY), love.mouse.getX() + 15, love.mouse.getY()-15)
		love.graphics.print("Screen:"..love.mouse.getX()..","..love.mouse.getY(), love.mouse.getX() + 15, love.mouse.getY())
	end

end

function love.mousepressed(x, y, button)
	if button == 'l' and player.mana >= 5 and not isPaused then
		for k,v in ipairs(entities) do
			local mouse_angle = math.atan2((love.mouse.getY()-translateY - (player.y+player.h/2)), (love.mouse.getX()-translateX - (player.x+player.w/2)))
			local entity_angle = math.atan2( (v.y+v.h/2) - (player.y+player.h/2), (v.x+v.w/2) - (player.x+player.w/2))
			if v ~= player then
				if distance(v.x+v.w/2, v.y+v.h/2, player.x+player.w/2, player.y+player.h/2) < player.range and math.abs(mouse_angle-entity_angle) < player.fov then
					v.health = v.health - player.damage
					love.audio.play("assets/sounds/sword_hit.wav")
				else
					love.audio.play("assets/sounds/sword_swing.wav")
				end
			end
		end
	end

	if button == 'r' and player.mana >= 5 and not isPaused then
		--local angle = math.atan2((love.mouse.getY()-translateY - (player.y+player.h/2)), (love.mouse.getX()-translateX - (player.x+player.w/2)))
   		--table.insert(blocks, Block.create("damage", player, player.x+player.w/2, player.y+player.h/2, 400*math.cos(angle), 400*math.sin(angle)))
   		
   		for k,v in ipairs(entities) do
   			if v ~= player and distance(player.x+player.w/2, player.y+player.h/2, v.x+v.w/2, v.y+v.h/2) < player.range then
   				v.x = -10000
   				v.y = -10000
   			end
   		end
   		player.mana = player.mana - 5
    end
end

function love.mousereleased(x, y, button)
   if button == 'l' then
   end
end

function love.keypressed(key)
	if key == '2' then
		debug = not debug
	end

	if key == 'escape' and player.health > 0 then
		isPaused = not isPaused
	end

	if key == 'r' and player.health <= 0 then 
		love.load()
	end

	if key == '1' then
		table.insert(entities, Entity.create("Enemy!", math.random(0, 500), math.random(0, 500)))
	end
end

function love.keyreleased(key)

end

function love.focus(f)
  if not f then
    print("LOST FOCUS")
  else
    print("GAINED FOCUS")
  end
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end


function mouseHoversOver(thing)
	mX = love.mouse.getX()
	mY = love.mouse.getY()

	return mX > thing.x and
			mX < thing.x + thing.w and
			mY > thing.y and
			mY < thing.y + thing.h
end

function checkKeys(dt)
	local speed = 100
	player.dx = 0
	player.dy = 0
	player.sprinting = false
	if love.keyboard.isDown("lshift") and player.mana > 0 then 
		player.sprinting = true
		speed = 150
	end
	if love.keyboard.isDown("d") and not player:collidingRight() then
		player.dx = speed
	end
	if love.keyboard.isDown("a") and not player:collidingLeft() then
		player.dx = -speed
	end
	if love.keyboard.isDown("s") and not player:collidingBottom() then
		player.dy = speed
	end
	if love.keyboard.isDown("w") and not player:collidingTop() then
		player.dy = -speed
	end
end

function collideWhere(x1,y1,w1,h1, x2,y2,w2,h2)
	if x1 < x2+w2 then
		return "left"
	elseif x2 < x1+w1 then
		return "right"
	elseif y1 < y2+h2 then
		return "top"
	elseif y2 < y1+h1 then
		return "bottom"
	end
end


function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function contains(list, value)
	for k,v in ipairs(list) do
		if v == value then
			return true
		else
			return false
		end
	end
end

function distance(x1,y1,x2,y2) return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) end

