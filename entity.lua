Entity = {}
Entity.__index = Entity

function Entity.create(n, x, y, w, h)
   local e = {}             -- our new object
   setmetatable(e, Entity)  -- make Account handle lookup
   e.name = n
   e.x = x or 100
   e.y = y or 100
   e.w = w or 32
   e.h = h or 32

   e.dx = 0
   e.dy = 0

   e.friction = 10

   return e
end

function Entity:draw(dt)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

	if debug then
		love.graphics.print(self.name, self.x + self.w + 5, self.y)
		love.graphics.print(self.x, self.x + self.w + 5, self.y+15)
		love.graphics.print(self.y, self.x + self.w + 5, self.y+30)
	end
end

function Entity:update(dt)

end