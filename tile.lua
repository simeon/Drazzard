Tile = {}
Tile.__index = Tile

function Tile.create(t, x, y)
	local e = {}   
	setmetatable(e, Tile)
	
	e.type = t
	e.x = x or 32
	e.y = y or 32
	e.w = w or tilesize
	e.h = h or tilesize

	e.image = love.graphics.newImage("assets/"..e.type..".png")
	return e
end

function Tile:draw()
	love.graphics.draw(self.image, self.x, self.y)

	if is_debugging then
		love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
		love.graphics.print("("..self.x.."\n"..self.y..")", self.x, self.y)
	end
end

function Tile:update(dt)
end