function love.load()
	require 'entity'
	require 'wall'
	require 'camera'
	require 'weapon'

	debug = true

	translateX = 0
	translateY = 0

	staff = Weapon.create("Lightning Staff")

	player = Entity.create("Me!", 200, 200, staff)
	enemy = Entity.create("Enemy!", 400, 500)


	entities = { player, enemy }	
	walls = { Wall.create(500, 200, 20, 100), Wall.create(500, 300, 20, 100), Wall.create(300, 200, 200, 20) }	

	var = "none"
end

function love.update(dt)
	checkKeys(dt)
	player:update(dt)
	enemy:update(dt)

	var = player.weapon.name
end

function love.draw(dt)
	love.graphics.push()
	translateX = love.graphics.getWidth()/2-player.x-player.w/2
	translateY = love.graphics.getHeight()/2-player.y-player.h/2
	love.graphics.translate(translateX, translateY)
	-----------------------------------

	player:draw(dt)
	enemy:draw(dt)

	for k,v in ipairs(walls) do
		v:draw()
	end

	-- GUI
	love.graphics.circle("line", 0,0,5)
	love.graphics.circle("line", love.mouse.getX()-translateX, love.mouse.getY()-translateY, 5)


	-- DEBUG
	love.graphics.pop()
	love.graphics.print("FPS: "..love.timer.getFPS(), 800, 0)
	if debug then
		love.graphics.print("Var: "..var, 800, 15)
		love.graphics.print("Entities: "..#entities, 800, 30)

		love.graphics.print("Actual:"..math.floor(love.mouse.getX()-translateX)..","..math.floor(love.mouse.getY()-translateY), love.mouse.getX() + 15, love.mouse.getY()-15)
		love.graphics.print("Screen:"..love.mouse.getX()..","..love.mouse.getY(), love.mouse.getX() + 15, love.mouse.getY())
	end

end

function love.mousepressed(x, y, button)
   if button == 'l' then
   	
   end
end

function love.mousereleased(x, y, button)
   if button == 'l' then
   end
end

function love.keypressed(key)
	if key == 'escape' then
		debug = not debug
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

