function love.load(arg)
	require 'tile'
	require 'object'
	require 'entity'

	font = love.graphics.newFont("misc/Karmatic_Arcade.ttf", 10)
	love.graphics.setFont(font)

	-- global variables
	translateX, translateY = 0, 0
	tilesize = 32
	is_debugging = false
	is_camfocused = true

	-- timer
	timer = 0
	timerEnd = .5
	imageState1 = true

	-- world
	Tiles = {}
	Objects = {}
	Entities = {}

	loadMap()

	LoopTables = { Tiles, Entities, Objects }
	player = Entity.create("soldier", 2*tilesize, 4*tilesize)
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

function readKeys(dt)
	local speed = 120
	if love.keyboard.isDown("d") and player.can_move_right then
		player.dx = speed*dt
	end
	if love.keyboard.isDown("a") and player.can_move_left then
		player.dx = -speed*dt
	end
	if love.keyboard.isDown("w") and player.can_move_up then
		player.dy = -speed*dt
	end
	if love.keyboard.isDown("s") and player.can_move_down then
		player.dy = speed*dt
	end
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		is_debugging = not is_debugging
	end
	if key == "r" then
		love.load()
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

function collision(a, b)
	return a.x < b.x+b.w and
	b.x < a.x+a.w and
	a.y < b.y+b.h and
	b.y < a.y+a.h
end

function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and
	x2 < x1+w1 and
	y1 < y2+h2 and
	y2 < y1+h1
end

function mouseHovers(obj)
	local mX = love.mouse.getX()-translateX
	local mY = love.mouse.getY()-translateY
	return mX < obj.x+obj.w and
	mX > obj.x and
	mY < obj.y+obj.h and
	mY > obj.y
end

function drawHUD()
	love.graphics.print("Lv. "..player.level, love.graphics.getWidth()/2-50, love.graphics.getHeight()-40)
	love.graphics.setColor(255, 255, 0)
	love.graphics.rectangle("fill", love.graphics.getWidth()/2-50, love.graphics.getHeight()-25, player.xp, 5)
	love.graphics.setColor(200, 0, 0)
	love.graphics.rectangle("fill", love.graphics.getWidth()/2-50, love.graphics.getHeight()-20, player.health, 10)
	love.graphics.setColor(0, 200, 200)
	love.graphics.rectangle("fill", love.graphics.getWidth()/2-50, love.graphics.getHeight()-10, player.mana, 10)
	love.graphics.setColor(255, 255, 255)
end

function loadMap()
	npc = Entity.create("soldier", 4*tilesize, 1*tilesize)
	npc2 = Entity.create("soldier", 4*tilesize, 2*tilesize)
	npc3 = Entity.create("soldier", 4*tilesize, 4*tilesize)
	npc4 = Entity.create("soldier", 6*tilesize, 4*tilesize)
	table.insert(Entities, npc)
	table.insert(Entities, npc2)
	table.insert(Entities, npc3)
	table.insert(Entities, npc4)

	npc4 = Entity.create("blueslime", 8*tilesize, 8*tilesize)
	table.insert(Entities, npc4)

	for i=1,20 do
		for j=1,20 do
			t = Tile.create("grass", i*tilesize, j*tilesize)
			table.insert(Tiles, t)
		end
	end

	table.insert(Objects, Object.create("fountain", 3*tilesize, 3*tilesize))
	table.insert(Objects, Object.create("sign", 7*tilesize, 3*tilesize))

	for i=1,10 do
		table.insert(Objects, Object.create("tree", 5*tilesize + i*tilesize, 1*tilesize))
	end

end

function math.distance(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end