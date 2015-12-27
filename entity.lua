Entity = {}
Entity.__index = Entity

function Entity.create(n, x, y)
	local e = {}   
	setmetatable(e, Entity)
	
	e.name = n
	e.x = x or 100
	e.y = y or 100
	e.w = w or 32
	e.h = h or 32
	e.dx = 0
	e.dy = 0
	e.image = love.graphics.newImage("assets/"..e.name..".png")
	e.image2 = love.graphics.newImage("assets/"..e.name.."_alt.png")

	return e
end

function Entity:draw()
	if imageState1 then
		love.graphics.draw(self.image, self.x, self.y)
	else
		love.graphics.draw(self.image2, self.x, self.y)
	end

	if is_debugging then
		love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
		love.graphics.print("("..math.floor(self.x)..","..math.floor(self.y)..")", self.x+self.w, self.y)
	end
end

function Entity:update(dt)
	self.x = self.x + self.dx*dt
	self.y = self.y + self.dy*dt

	self.dx = 0
	self.dy = 0
end