function love.load()
	require 'entity'

	debug = true
	player = Entity.create("Me!", 200, 200)

end

function love.update(dt)
	checkKeys(dt)
	player:update(dt)
end

function love.draw(dt)
	player:draw(dt)

	-- GUI
	love.graphics.circle("line", 0,0,5)

	-- DEBUG
	love.graphics.print("FPS: "..love.timer.getFPS(), 800, 0)

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

	if love.keyboard.isDown("d") then
		player.x = player.x + speed * dt
	end
	if love.keyboard.isDown("a") then
		player.x = player.x - speed * dt
	end
	if love.keyboard.isDown("s") then
		player.y = player.y + speed * dt
	end
	if love.keyboard.isDown("w") then
		player.y = player.y - speed * dt
	end
end



