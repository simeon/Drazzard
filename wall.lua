Wall = {}
Wall.__index = Wall

function Wall.create(n, x, y, w, h)
   local v = {}             -- our new object
   setmetatable(v, Wall)  -- make Account handle lookup
   v.name = n or "NO NAME"
   v.x = x or 100
   v.y = y or 100
   v.w = w or 32
   v.h = h or 32

   return v
end

function Wall:draw(dt)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

	if debug then
		love.graphics.print(self.x, self.x + self.w + 5, self.y+15)
		love.graphics.print(self.y, self.x + self.w + 5, self.y+30)
	end
end

function Wall:update(dt)
   
end