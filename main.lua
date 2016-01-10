function love.load(arg)
	require 'tile'
	require 'object'
	require 'entity'

	font_karmatic_lg = love.graphics.newFont("misc/Karmatic_Arcade.ttf", 50)
	font_karmatic_md = love.graphics.newFont("misc/Karmatic_Arcade.ttf", 10)

	h1 = love.graphics.newFont("misc/Roboto-Black.ttf", 35)
	h2 = love.graphics.newFont("misc/Roboto-Bold.ttf", 30)
	h3 = love.graphics.newFont("misc/Roboto-Medium.ttf", 25)
	h4 = love.graphics.newFont("misc/Roboto-Regular.ttf", 20)
	h5 = love.graphics.newFont("misc/Roboto-Regular.ttf", 15)
	h6 = love.graphics.newFont("misc/Roboto-Regular.ttf", 10)

	love.graphics.setFont(font_karmatic_md)
	cursor = love.mouse.newCursor("misc/wand_cursor.png", 0, 0)
	love.mouse.setCursor(cursor)

	-- global variables
	gamestate = "credits"
	printvar = ""
	translateX, translateY = 0, 0
	tilesize = 32
	is_debugging = false
	is_camfocused = true
	is_paused = false

	-- timer
	timer = 0
	timerEnd = .5
	imageState1 = true

	-- world
	Tiles = {}
	Objects = {}
	Entities = {}

	LoopTables = { Tiles, Objects, Entities }
	player = Entity.create("bluemage", 1*tilesize, 1*tilesize)
	player.demeanor = "green"
	table.insert(Entities, player)
	loadMap("village")
end

function love.update(dt)
	-- game over check
	printvar = #Objects
	if player.health <= 0 then
		player.health = 0
		is_paused = true
	end

	if not is_paused then
		if love.mouse.getX()-translateX < player.x+player.w/2 then player.direction = "left" else player.direction = "right" end
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
end

function love.draw()

	if gamestate == "game" then
		if is_camfocused then
			love.graphics.push()
			translateX = love.graphics.getWidth()/2-player.x-player.w/2
			translateY = love.graphics.getHeight()/2-player.y-player.h/2
			love.graphics.translate(translateX, translateY)
		end
		----------------------------------------------------------------
		love.graphics.draw(map_image, 0, 0)

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
	elseif gamestate == "credits" then
		drawCreditScreen()
	end

	love.graphics.print(love.timer.getFPS(), 10, 10)
	love.graphics.print(gamestate, 10, 30)
end

function readKeys(dt)
	local speed = 320
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
	if button == 1 then
		player:launchProjectile()
	end
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

function loadMap(name)
	--[[npc = Entity.create("soldier", 4*tilesize, 1*tilesize)
	npc2 = Entity.create("soldier", 4*tilesize, 2*tilesize)
	npc3 = Entity.create("soldier", 4*tilesize, 4*tilesize)
	npc4 = Entity.create("soldier", 6*tilesize, 4*tilesize)
	table.insert(Entities, npc)
	table.insert(Entities, npc2)
	table.insert(Entities, npc3)
	table.insert(Entities, npc4)

	enemy = Entity.create("blueslime", 8*tilesize, 8*tilesize)
	enemy.demeanor = "hostile"
	enemy.sight_range = 6*tilesize
	enemy.attack_range = 1.5*tilesize
	table.insert(Entities, enemy)]]


	if name == "village" then
		map_image = love.graphics.newImage("maps/village.png")

		-- villagers
		table.insert(Entities, Entity.create("soldier", -9*tilesize, -6*tilesize))
		table.insert(Entities, Entity.create("soldier", 20*tilesize, -7*tilesize))
		table.insert(Entities, Entity.create("soldier", 23*tilesize, -7*tilesize))

		-- upper left house
		table.insert(Objects, Object.create("wall", 40*tilesize, 33*tilesize, 7*tilesize, 3*tilesize))
		table.insert(Objects, Object.create("wall", 40*tilesize, 36*tilesize, 1*tilesize, 4*tilesize))
		table.insert(Objects, Object.create("wall", 46*tilesize, 36*tilesize, 1*tilesize, 4*tilesize))
		table.insert(Objects, Object.create("wall", 41*tilesize, 39*tilesize, 2*tilesize, 1*tilesize))
		table.insert(Objects, Object.create("wall", 44*tilesize, 39*tilesize, 2*tilesize, 1*tilesize))

		-- lower left house
		table.insert(Objects, Object.create("wall", 40*tilesize, 45*tilesize, 9*tilesize, 9*tilesize))
		table.insert(Objects, Object.create("wall", 36*tilesize, 54*tilesize, 13*tilesize, 7*tilesize))

		-- uppper right house
		table.insert(Objects, Object.create("wall", 70*tilesize, 33*tilesize, 23*tilesize, 8*tilesize))
		table.insert(Objects, Object.create("wall", 84*tilesize, 41*tilesize, 9*tilesize, 8*tilesize))
		
		enemy = Entity.create("blueslime", 50*tilesize, 40*tilesize)
		enemy.demeanor = "red"
		enemy.sight_range = 20*tilesize
		enemy.attack_range = 1.5*tilesize
		table.insert(Entities, enemy)
	end

end

function drawCreditScreen()
	-- title
	love.graphics.setFont(font_karmatic_lg)
	love.graphics.printf("Credits", 0, 15, love.graphics.getWidth(),"center")

	-- body
	love.graphics.setColor(255, 255, 255, 160)
	love.graphics.setFont(h1)
	love.graphics.printf("~ PROGRAMMING ~", 0, 100, love.graphics.getWidth(), "center")
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(h2)
	love.graphics.printf("Simeon Videnov", 0, 140, love.graphics.getWidth(), "center")
	love.graphics.setFont(h4)
	love.graphics.printf("( http://simeon.io )", 0, 170, love.graphics.getWidth(), "center")
	
	
	love.graphics.setColor(255, 255, 255, 160)
	love.graphics.setFont(h1)
	love.graphics.printf("~ ART & SPRITES ~", 0, 210, love.graphics.getWidth(), "center")
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(h2)
	love.graphics.printf("DawnBringer & DragonDePlatino", 0, 250, love.graphics.getWidth(), "center")
	love.graphics.setFont(h4)
	love.graphics.printf("( http://pixeljoint.com/p/23821.htm )", 0, 280, love.graphics.getWidth(), "center")
	love.graphics.printf("( http://opengameart.org/users/dragondeplatino )", 0, 300, love.graphics.getWidth(), "center")

	love.graphics.setColor(255, 255, 255, 160)
	love.graphics.setFont(h1)
	love.graphics.printf("~ MUSIC & SFX ~", 0, 340, love.graphics.getWidth(), "center")
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(h2)
	love.graphics.printf("---", 0, 380, love.graphics.getWidth(), "center")
	love.graphics.setFont(h4)
	love.graphics.printf("( --- )", 0, 410, love.graphics.getWidth(), "center")


	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(font_karmatic_md)
end

function math.distance(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end