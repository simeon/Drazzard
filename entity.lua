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
	return e
end

function Entity:draw()
end

function Entity:update(dt)
end