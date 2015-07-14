Entity = {}
Entity.__index = Entity

function Entity.create(n, x, y, w, h)
   local e = {}             -- our new object
   setmetatable(e, Entity)  -- make Account handle lookup
   e.name = n
   return e
end

function Entity:draw()
	love.graphics.circle("line", self.x, self.y, self.w)
end