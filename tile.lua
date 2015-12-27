Tile = {}
Tile.__index = Tile

function Tile.create(t, x, y)
	local e = {}   
	setmetatable(e, Tile)
	
	e.type = t
	e.x = x or 100
	e.y = y or 100
	e.w = w or 32
	e.h = h or 32

	e.image = love.graphics.newImage("assets/"..e.type..".png")
	return e
end

function Tile:draw()
	love.graphics.draw(self.image, self.x, self.y)

	if is_debugging then
		love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	end
end

function Tile:update(dt)
end