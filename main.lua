function love.load(arg)
	require 'tile'
	require 'entity'

	-- global variables
	tilesize = 32
	is_debugging = false
	is_camfocused = true

	-- timer
	timer = 0
	timerEnd = .75
	imageState1 = true
	-- world
	Tiles = { }
	Entities = { }

	loadMap()

	LoopTables = { Tiles, Entities }
	player = Entity.create("player", 3*tilesize, 3*tilesize)
	table.insert(Entities, player)
end

function love.update(dt)
	readKeys(dt)

	for k,v in ipairs(LoopTables) do
		for i,j in ipairs(v) do
			j:update(dt)
		end
	end
	timer = timer + dt
	if timer >= timerEnd then
		timer = 0
		imageState1 = not imageState1
	end
end

function love.draw()
	if is_camfocused then
		love.graphics.push()
		translateX = love.graphics.getWidth()/2-player.x-player.w/2
		translateY = love.graphics.getHeight()/2-player.y-player.h/2
		love.graphics.translate(translateX, translateY)
	end
	----------------------------------------------------------------

	for k,v in ipairs(LoopTables) do
		for i,j in ipairs(v) do
			j:draw()
		end
	end

	----------------------------------------------------------------
	if is_camfocused then love.graphics.pop() end
	love.graphics.print(love.timer.getFPS(), 10, 10)
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		is_debugging = not is_debugging
	end
end

function readKeys(dt)
	if love.keyboard.isDown("w") then
		player.dy = -100
	elseif love.keyboard.isDown("s") then
		player.dy = 100
	end
	if love.keyboard.isDown("a") then
		player.dx = -100
	elseif love.keyboard.isDown("d") then
		player.dx = 100
	end
end

function love.keyreleased(key, scancode)
end

function love.directorydropped(path)
end

--function love.errhand(msg)
--end

function love.filedropped(file)
end

function love.focus(f)
end

function love.lowmemory()
end

function love.mousefocus(f)
end

function love.mousemoved(x, y, dx, dy)
end

function love.mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
end

function love.resize(w, h)
end

function love.textedited(text, start, length)
end

function love.textinput(text)
end

function love.threaderror(thread, errorstr)
end

function love.touchmoved(id, x, y, pressure)
end

function love.touchpressed(id, x, y, pressure)
end

function love.touchreleased(id, x, y, pressure)
end

function love.visible(v)
end

function love.wheelmoved(x, y)
end

function love.quit()
end

function loadMap()
	for i=1,10 do
		for j=1,10 do
			t = Tile.create("wood", i*tilesize, j*tilesize)
			table.insert(Tiles, t)
		end
	end
end