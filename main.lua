function love.load(arg)
	require 'tile'

	-- global variables
	is_debugging = false

	t = Tile.create("wood", 100, 100)
	Tiles = { t }

	LoopTables = { Tiles }

end

function love.update(dt)
	for k,v in ipairs(LoopTables) do
		for i,j in ipairs(v) do
			j:update(dt)
		end
	end
end

function love.draw()
	for k,v in ipairs(LoopTables) do
		for i,j in ipairs(v) do
			j:draw()
		end
	end

	love.graphics.print(love.timer.getFPS(), 10, 10)
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		is_debugging = not is_debugging
	end
end

function love.keyreleased(key, scancode)
end

function love.directorydropped(path)
end

function love.errhand(msg)
end

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