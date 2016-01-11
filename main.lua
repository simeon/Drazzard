function love.load(arg)
	require 'tile'
	require 'object'
	require 'entity'
	require 'button'

	ui_font = love.graphics.newFont("misc/Karmatic_Arcade.ttf", 10)

	title_font = love.graphics.newFont("misc/Lady_Radical.ttf", 70)
	button_font = love.graphics.newFont("misc/Lady_Radical.ttf", 35)


	h1 = love.graphics.newFont("misc/BebasNeue.otf", 35)
	h2 = love.graphics.newFont("misc/BebasNeue.otf", 30)
	h3 = love.graphics.newFont("misc/BebasNeue.otf", 25)
	h4 = love.graphics.newFont("misc/BebasNeue.otf", 20)
	h5 = love.graphics.newFont("misc/BebasNeue.otf", 15)
	h6 = love.graphics.newFont("misc/BebasNeue.otf", 10)

	love.graphics.setFont(ui_font)
	cursor = love.mouse.newCursor("misc/wand_cursor.png", 0, 0)
	love.mouse.setCursor(cursor)

	love.graphics.setBackgroundColor(30, 25, 35)

	-- sounds
	explosion_sound = love.audio.newSource("audio/explosion.wav", "static")
	click_sound = love.audio.newSource("audio/click.wav", "static")


	-- global variables
	gamestate = "game"
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

	-- tables
	Tiles = {}
	Objects = {}
	Entities = {}
	Buttons = {}

	LoopTables = { Tiles, Objects, Entities, Buttons }

	-- buttons
	start_button = Button.create("start", 200, 150, "game")
	controls_button = Button.create("how to play", 200, 250, "controls")
	credits_button = Button.create("credits", 200, 350, "credits")
	mainmenu_button = Button.create("main menu", 10, 10, "mainmenu")


	sim = love.graphics.newImage("logos/SimeonLogo.png")
	innerGear = love.graphics.newImage("logos/innerGear.png")
	outerGear = love.graphics.newImage("logos/outerGear.png")

	-- world	
	player = Entity.create("bluemage", 1*tilesize, 1*tilesize)
	player.demeanor = "green"
	table.insert(Entities, player)
	loadMap("village")
end

function love.update(dt)

	if gamestate == "game" then
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
	elseif gamestate == "mainmenu" then
		Buttons = {
			start_button,
			controls_button,
			credits_button
		}
	elseif gamestate == "controls" then
		Buttons = {
			mainmenu_button
		}
	elseif gamestate == "credits" then
		Buttons = {
			mainmenu_button
		}
	elseif gamestate == "splashscreen" then
		Buttons = {}
		timer = timer + dt
		if timer >= 2.5 then
			timer = 0
			gamestate = "mainmenu"
		end
	end

	for k,v in ipairs(Buttons) do
		v:update()
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
		drawMinimap()
	elseif gamestate == "mainmenu" then
		drawMainMenu()
	elseif gamestate == "controls" then
		drawControlsScreen()
	elseif gamestate == "credits" then
		drawCreditScreen()
	elseif gamestate == "splashscreen" then
		love.graphics.setColor(255, 255, 255, 255)
		-- rotates image
		love.graphics.draw(innerGear, love.graphics.getWidth()/2, love.graphics.getHeight()/2-30, 0, 1, 1, 150, 150)
		love.graphics.draw(outerGear, love.graphics.getWidth()/2, love.graphics.getHeight()/2-30, timer*math.pi/12, 1, 1, 150, 150)
		love.graphics.draw(outerGear, love.graphics.getWidth()/2, love.graphics.getHeight()/2-310, math.pi/10-timer*math.pi/12, 1, 1, 150, 150)
		love.graphics.setFont(button_font)
		love.graphics.printf("http://simeon.io", 0, love.graphics.getHeight()/2+120, love.graphics.getWidth(), "center")
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.setFont(ui_font)

	end

	love.graphics.printf(love.timer.getFPS(), -10, 10, love.graphics.getWidth(), "right")
	if is_debugging then
		love.graphics.print(gamestate, 10, 10)
		love.graphics.print(tostring(is_debugging), 10, 30)
		love.graphics.print(timer, 10, 50)
	end
end

function readKeys(dt)
	local speed = player.speed
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
	if gamestate == "mainmenu" or gamestate == "credits" or gamestate == "controls" then
		if button == 1 then
			for k,v in ipairs(Buttons) do
				if mouseOverlaps(v) then
					if v.link then 
						click_sound:play()
						gamestate = v.link
					end
				end
			end
		end
	elseif gamestate == "game" then
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

	if name == "village" then
		map_image = love.graphics.newImage("Village.png")

		-- top wall
		table.insert(Objects, Object.create("wall", 0*tilesize, 0*tilesize, 30*tilesize, 1*tilesize))
		-- left wall
		table.insert(Objects, Object.create("wall", 0*tilesize, 0*tilesize, 1*tilesize, 30*tilesize))
		-- right wall
		table.insert(Objects, Object.create("wall", 29*tilesize, 0*tilesize, 1*tilesize, 30*tilesize))
		-- bottom wall
		table.insert(Objects, Object.create("wall", 0*tilesize, 29*tilesize, 30*tilesize, 1*tilesize))


		--[[ villagers
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
		table.insert(Entities, enemy)]]
	end

end

function drawMainMenu()
	love.graphics.setFont(title_font)
	-- text shadow
	love.graphics.setColor(0, 0, 0)
	love.graphics.printf("DRAZZARD", 0, 30, love.graphics.getWidth(),"center")
	-- main title text
	love.graphics.setColor(255, 255, 255)
	love.graphics.printf("DRAZZARD", 0, 15, love.graphics.getWidth(),"center")

	
	-- buttons 
	for k,v in ipairs(Buttons) do
		centerX(v)
		v:draw()
	end

	love.graphics.setFont(ui_font)
end

function drawControlsScreen()
	-- title
	love.graphics.setFont(button_font)
	love.graphics.printf("HOW TO PLAY", 0, 10, love.graphics.getWidth(),"center")
	love.graphics.setColor(255, 255, 255, 255)

	-- buttons 
	for k,v in ipairs(Buttons) do
		v:draw()
	end
end

function drawCreditScreen()
	-- title
	love.graphics.setFont(button_font)
	love.graphics.printf("CREDITS", 0, 10, love.graphics.getWidth(),"center")
	love.graphics.setColor(255, 255, 255, 255)


	-- right column
	love.graphics.setFont(button_font)
	love.graphics.printf("Sprites", 0, 100, love.graphics.getWidth()/3,"center")
	love.graphics.setFont(h3)
	love.graphics.printf("DawnBringer", 0, 160, love.graphics.getWidth()/3,"center")
	love.graphics.setColor(255, 255, 255, 130)
	love.graphics.printf("( DawnBringer Palette )", 0, 185, love.graphics.getWidth()/3,"center")
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf("DragonDePlatino", 0, 220, love.graphics.getWidth()/3,"center")
	love.graphics.setColor(255, 255, 255, 130)
	love.graphics.printf("( DawnLike Tileset )", 0, 245, love.graphics.getWidth()/3,"center")
	love.graphics.setColor(255, 255, 255, 255) 

	-- center column
	love.graphics.setFont(button_font)
	love.graphics.printf("Programming", love.graphics.getWidth()/3, 100, love.graphics.getWidth()/3,"center")
	love.graphics.setFont(h3)
	love.graphics.printf("Simeon Videnov", love.graphics.getWidth()/3, 160, love.graphics.getWidth()/3,"center")
	love.graphics.setColor(255, 255, 255, 130)
	love.graphics.printf("( http://simeon.io )", love.graphics.getWidth()/3, 185, love.graphics.getWidth()/3,"center")
	love.graphics.setColor(255, 255, 255, 255)

	-- right column
	love.graphics.setFont(button_font)
	love.graphics.printf("Music", 2*love.graphics.getWidth()/3, 100, love.graphics.getWidth()/3,"center")
	love.graphics.setFont(h3)
	love.graphics.printf("--", 2*love.graphics.getWidth()/3, 160, love.graphics.getWidth()/3,"center")
	love.graphics.setColor(255, 255, 255, 130)
	love.graphics.printf("( -- )", 2*love.graphics.getWidth()/3, 185, love.graphics.getWidth()/3,"center")
	love.graphics.setColor(255, 255, 255, 255)



	-- buttons 
	for k,v in ipairs(Buttons) do
		v:draw()
	end
end

function drawMinimap()
	-- walls
	for k,v in ipairs(Objects) do
		if v.is_explosive then
			love.graphics.setColor(255, 0, 0)
		end
		love.graphics.rectangle("line", 10+v.x/16, 10+v.y/16, v.w/16, v.h/16)
	end
	-- players
	love.graphics.setColor(0, 255, 0)
	for k,v in ipairs(Entities) do
		love.graphics.circle("line", 10+v.x/16, 10+v.y/16, 1)
	end
	love.graphics.setColor(255, 255, 255)
end

function centerX(thing)
	thing.x = love.graphics.getWidth()/2-thing.w/2
end

function math.distance(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

function mouseOverlaps(thing)
	local mX = love.mouse.getX()
	local mY = love.mouse.getY()

	return mX > thing.x and
		   mX < thing.x + thing.w and
		   mY > thing.y and
		   mY < thing.y + thing.h
end