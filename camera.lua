Camera = {}
Camera.__index = Camera

function Camera.create(x, y)
   local c = {}             -- our new object
   setmetatable(c, Camera)  -- make Account handle lookup
   c.x = x or 100
   c.y = y or 100

   return c
end

function Camera:draw(dt)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

	if debug then
		love.graphics.print(self.x, self.x + self.w + 5, self.y+15)
		love.graphics.print(self.y, self.x + self.w + 5, self.y+30)
	end
end

function Camera:update(dt)

end