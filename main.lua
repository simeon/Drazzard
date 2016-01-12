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

	-- visuals
	mainmenu_image = love.graphics.newImage("DrazzardLogo.png")
	mainmenu_image:setFilter("nearest", "nearest")
	innerGear = love.graphics.newImage("logos/innerGear.png")
	innerGear:setFilter("nearest", "nearest")
	outerGear = love.graphics.newImage("logos/outerGear.png")
	outerGear:setFilter("nearest", "nearest")

	-- sounds
	explosion_sound = love.audio.newSource("audio/explosion.wav", "static")
	click_sound = love.audio.newSource("audio/click.wav", "static")
	cast_sound = love.audio.newSource("audio/swish.wav", "static")

	game_music = love.audio.newSource("audio/Jaunty Gumption.mp3")
	menu_music = love.audio.newSource("audio/Rhinoceros.mp3")



	-- global variables
	gamestate = "mainmenu"
	prev_gamestate = "splashscreen"
	printvar = ""
	translateX, translateY = 0, 0
	tilesize = 32
	is_debugging = false
	is_camfocused = true
	is_paused = false
	is_maploaded = false
	current_round = 35

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
	start_button = Button.create("game", 200, 190, "game")
	controls_button = Button.create("how to play", 200, 270, "controls")
	credits_button = Button.create("credits", 200, 350, "credits")
	mainmenu_button = Button.create("main menu", 10, 10, "mainmenu")
	back_button = Button.create("back", 10, 10, "PREV_GAMESTATE")
end

function love.update(dt)

	if gamestate == "game" then
		if not is_maploaded then		
			loadMap("arena")
			is_maploaded = true
		end

		menu_music:stop()
		game_music:play()
		-- game over check
		if player.health <= 0 then
			player.health = 0
			is_paused = true
		end

		-- damage from enemies
		for k,v in ipairs(Entities) do
			if v ~= player and math.distance(v.x+v.w/2, v.y+v.h/2, player.x+player.w/2, player.y+player.h/2) < v.attack_range then
				player.health = player.health - v.attack*dt
			end
		end

		-- potion check
		for k,v in ipairs(Objects) do
			if (v.type == "manapotion" or v.type == "healthpotion") and math.distance(player.x+player.w/2, player.y+player.h/2, v.x+v.w/2, v.y+v.h/2) < tilesize then
				v:destroy()
				if v.type == "manapotion" then
					local mana_amount = love.math.random(30)
					player.mana = player.mana + mana_amount
					if player.mana > 100 then player.mana = 100 end
				elseif v.type == "healthpotion" then
					local health_amount = love.math.random(30)
					player.health = player.health + health_amount
					if player.health > 100 then player.health = 100 end
				end
			end
		end

		if not is_paused then
			Buttons = {}
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
		else 
			--[[Buttons = {
				mainmenu_button,
				controls_button,
				credits_button
			}
			mainmenu_button.y = 190
			mainmenu_button.text = "quit game"]]
		end
	elseif gamestate == "mainmenu" then
		timer = timer + dt

		game_music:stop()
		menu_music:play()

		Buttons = {
			start_button,
			controls_button,
			credits_button
		}
		start_button.y = 190
		start_button.text = "new game"

	elseif gamestate == "controls" then
		-- where the "back button" will link
		if prev_gamestate == "game" then
			Buttons = { start_button }
				start_button.x = 10
				start_button.y = 10
		elseif prev_gamestate == "mainmenu" then
			Buttons = { mainmenu_button }
				mainmenu_button.x = 10
				mainmenu_button.y = 10
		end
	elseif gamestate == "credits" then
		-- where the "back button" will link
		if prev_gamestate == "game" then
			Buttons = { start_button }
				start_button.x = 10
				start_button.y = 10
		elseif prev_gamestate == "mainmenu" then
			Buttons = { mainmenu_button }
				mainmenu_button.x = 10
				mainmenu_button.y = 10
		end
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
		love.graphics.draw(map_image, -30*tilesize, -30*tilesize)

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
	--	if is_paused then drawPauseMenu() end

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

	if is_debugging then
		love.graphics.printf(love.timer.getFPS(), -10, 10, love.graphics.getWidth(), "right")
		love.graphics.setColor(0, 0, 0, 100)
		love.graphics.rectangle("fill", 0, 0, 300, 200)
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print(prev_gamestate.."   "..gamestate, 10, 10)
		love.graphics.print(tostring(is_debugging), 10, 30)
		love.graphics.print(timer, 10, 50)
		love.graphics.print(#Buttons.." buttons", 10, 70)
		love.graphics.print(#Entities.." entities", 10, 90)
		love.graphics.print(#Objects.." objects", 10, 110)
	end

	for k,v in ipairs(Buttons) do
		v:draw()
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
		menu_music:stop()
		game_music:stop()
		love.load()
	end

	if gamestate == "game" then
		if key == "p" then
			is_paused = not is_paused
		end
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
						prev_gamestate = gamestate
						gamestate = v.link
					end
				end
			end
		end
	end

	if gamestate == "game" and not is_paused and is_maploaded then
		if button == 1 then
			player:launchProjectile()
		end
	end

	if gamestate == "game" and is_paused and is_maploaded then
		if button == 1 then
			for k,v in ipairs(Buttons) do
				if mouseOverlaps(v) then
					if v.link then 
						click_sound:play()
						prev_gamestate = gamestate
						gamestate = v.link
						if v.link == "mainmenu" then -- the user is quitting game
							game_music:stop()
							love.load()
							gamestate = "mainmenu"
							prev_gamestate = "splashscreen"
						end
					end
				end
			end
		end
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
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", 80, 10, player.health, 10)
	love.graphics.setColor(0, 200, 200)
	love.graphics.rectangle("fill", 80, 20, player.mana, 10)
	love.graphics.setColor(255, 255, 255)

	love.graphics.print("Lv. "..current_round, 80, 35)
end

function loadMap(name)
	if name == "arena" then
		map_image = love.graphics.newImage("Village.png")

		player = Entity.create("bluemage", 14.5*tilesize, 14.5*tilesize)
		player.team = "green"
		player.speed = 200
		player.health_regen_rate = 0
		table.insert(Entities, player)

		-- top wall
		table.insert(Objects, Object.create("wall", 0*tilesize, 0*tilesize, 30*tilesize, 1*tilesize))
		-- left wall
		table.insert(Objects, Object.create("wall", 0*tilesize, 0*tilesize, 1*tilesize, 30*tilesize))
		-- right wall
		table.insert(Objects, Object.create("wall", 29*tilesize, 0*tilesize, 1*tilesize, 30*tilesize))
		-- bottom wall
		table.insert(Objects, Object.create("wall", 0*tilesize, 29*tilesize, 30*tilesize, 1*tilesize))

		table.insert(Entities, Entity.create("soldier", 14.5*tilesize, 1*tilesize)) -- N

		-- rocks
		table.insert(Objects, Object.create("rock", 8*tilesize, 5*tilesize))
		table.insert(Objects, Object.create("rock", 12*tilesize, 17*tilesize))
		table.insert(Objects, Object.create("rock", 27*tilesize, 11*tilesize))
		table.insert(Objects, Object.create("rock", 18*tilesize, 23*tilesize))
		
		-- door
		table.insert(Objects, Object.create("door", 14.5*tilesize, .1*tilesize))

	end

end

function drawMainMenu()
	-- background image
	love.graphics.draw(mainmenu_image, 0, -260, 0, love.graphics.getWidth()/768, 1)

	love.graphics.setFont(title_font)
	-- text shadow
	love.graphics.setColor(0, 0, 0, 150)
	love.graphics.printf("DRAZZARD", 0, 30+8*math.sin(timer), love.graphics.getWidth(),"center")
	-- main title text
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf("DRAZZARD", 0, 15+5*math.sin(timer), love.graphics.getWidth(),"center")

	-- buttons 
	for k,v in ipairs(Buttons) do
		centerX(v)
	end
	love.graphics.setFont(ui_font)
end

function drawControlsScreen()
	-- title
	love.graphics.setFont(button_font)
	love.graphics.printf("HOW TO PLAY", 0, 10, love.graphics.getWidth(),"center")
	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.setFont(button_font)
	love.graphics.printf("wasd   ->   move", 0, 100, love.graphics.getWidth(),"center")
	love.graphics.printf("  left click  ->  cast spell", 0, 150, love.graphics.getWidth(),"center")
	love.graphics.printf("                   p  ->  pause game", 0, 200, love.graphics.getWidth(),"center")

	love.graphics.printf("Enemies will damage you if they get close", 0, 300, love.graphics.getWidth(),"center")
	love.graphics.printf("Explosion from spell can damage multiple enemies", 0, 350, love.graphics.getWidth(),"center")
	love.graphics.printf("Potions will restore your mana and health", 0, 400, love.graphics.getWidth(),"center")

	love.graphics.setFont(ui_font)
end

function drawCreditScreen()
	-- title
	love.graphics.setFont(button_font)
	love.graphics.printf("CREDITS", 0, 10, love.graphics.getWidth(),"center")
	love.graphics.setColor(255, 255, 255, 255)


	-- right column
	love.graphics.setFont(button_font)
	love.graphics.printf("Sprites", love.graphics.getWidth()/2, 100, love.graphics.getWidth()/2,"center")
	love.graphics.setFont(h4)
	love.graphics.printf("DawnBringer", love.graphics.getWidth()/2, 160, love.graphics.getWidth()/2,"center")
	love.graphics.setColor(255, 255, 255, 130)
	love.graphics.printf("( DawnBringer Palette )", love.graphics.getWidth()/2, 180, love.graphics.getWidth()/2,"center")
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf("DragonDePlatino", love.graphics.getWidth()/2, 210, love.graphics.getWidth()/2,"center")
	love.graphics.setColor(255, 255, 255, 130)
	love.graphics.printf("( DawnLike Tileset )", love.graphics.getWidth()/2, 230, love.graphics.getWidth()/2,"center")
	love.graphics.setColor(255, 255, 255, 255) 

	-- left column
	love.graphics.setFont(button_font)
	love.graphics.printf("Concept and Programming", 0, 100, love.graphics.getWidth()/2,"center")
	love.graphics.setFont(h4)
	love.graphics.printf("Simeon Videnov", 0, 160, love.graphics.getWidth()/2,"center")
	love.graphics.setColor(255, 255, 255, 130)
	love.graphics.printf("( http://simeon.io )", 0, 180, love.graphics.getWidth()/2,"center")
	love.graphics.setColor(255, 255, 255, 255)

	-- left column
	love.graphics.setFont(button_font)
	love.graphics.printf("Music", 0, 250, love.graphics.getWidth()/2,"center")
	love.graphics.setFont(h4)
	love.graphics.printf("\"Jaunty Gumption\",\"Rhinoceros\"\nKevin MacLeod (incompetech.com)\nLicensed under Creative Commons: By Attribution 3.0\nhttp://creativecommons.org/licenses/by/3.0", 0, 310, love.graphics.getWidth()/2,"center")

	love.graphics.setFont(ui_font)
end

function drawMinimap()
	-- walls
	for k,v in ipairs(Objects) do
		if v.is_explosive then
			love.graphics.setColor(255, 0, 0)
		end
		if v.is_solid then
			love.graphics.rectangle("line", 10+v.x/16, 10+v.y/16, v.w/16, v.h/16)
		end
	end
	-- players
	for k,v in ipairs(Entities) do
		if v.team == "red" then
			love.graphics.setColor(255, 0, 0)
		elseif v.team == "green" then
			love.graphics.setColor(0, 255, 0)
		end

		love.graphics.circle("line", 10+v.x/16, 10+v.y/16, 1)
	end
	love.graphics.setColor(255, 255, 255)
end

function drawPauseMenu()
	love.graphics.setColor(0, 0, 0, 100)
	love.graphics.rectangle("fill", love.graphics.getWidth()/3, love.graphics.getHeight()/8, love.graphics.getWidth()/3, 6*love.graphics.getHeight()/8)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(title_font)
	if player.health <= 0 then
		love.graphics.printf("game over", 0, 70, love.graphics.getWidth(),"center")
	else
		love.graphics.printf("Paused", 0, 70, love.graphics.getWidth(),"center")
	end
	love.graphics.setFont(ui_font)

	-- buttons 
	for k,v in ipairs(Buttons) do
		centerX(v)
		v:draw()
	end
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