Floor = {}
Floor.__index = Floor

function Floor.create(n, x, y, w, h)
   local f = {}             -- our new object
   setmetatable(f, Floor)  -- make Account handle lookup
   f.name = n or "NO NAME"
   f.x = x * tilesize or 0
   f.y = y * tilesize or 0
   f.w = w * tilesize or 0
   f.h = h * tilesize or 0

   return f
end

function Floor:draw(dt)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

	if debug then
		love.graphics.print(self.x, self.x + self.w + 5, self.y+15)
		love.graphics.print(self.y, self.x + self.w + 5, self.y+30)
	end
end

function Floor:update(dt)
   
end