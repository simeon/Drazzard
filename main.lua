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
	Tiles = {}
	Objects = {}
	Entities = {}

	loadMap()

	LoopTables = { Tiles, Objects, Entities }
	player = Entity.create("player", 3*tilesize, 4*tilesize)
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

	love.graphics.circle("fill", 0, 0, 1)
	love.graphics.circle("line", 0, 0, 4)
	----------------------------------------------------------------
	if is_camfocused then love.graphics.pop() end
	drawHUD()
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

function drawHUD()
	love.graphics.print("Lv. "..player.level, love.graphics.getWidth()/2-50, love.graphics.getHeight()-40)
	love.graphics.setColor(255, 255, 0)
	love.graphics.rectangle("fill", love.graphics.getWidth()/2-50, love.graphics.getHeight()-25, player.xp, 5)
	love.graphics.setColor(200, 0, 0)
	love.graphics.rectangle("fill", love.graphics.getWidth()/2-50, love.graphics.getHeight()-20, player.health, 10)
	love.graphics.setColor(0, 200, 0)
	love.graphics.rectangle("fill", love.graphics.getWidth()/2-50, love.graphics.getHeight()-10, player.mana, 10)
	love.graphics.setColor(255, 255, 255)
end

function loadMap()
	for i=1,5 do
		for j=1,5 do
			t = Tile.create("grass", i*tilesize, j*tilesize)
			table.insert(Tiles, t)
		end
	end

	table.insert(Objects, Tile.create("fountain", 3*tilesize, 3*tilesize))

end