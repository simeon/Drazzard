Room = {}
Room.__index = Room

function Room.create(n, x, y, w, h)
   local r = {}             -- our new object
   setmetatable(r, Room)  -- make Account handle lookup
   r.name = n or "NO NAME"
   r.x = x * tilesize or 0
   r.y = y * tilesize or 0
   r.w = w * tilesize or 0
   r.h = h * tilesize or 0

   return r
end

function Room:draw(dt)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

	if debug then
		love.graphics.print(self.x, self.x + self.w + 5, self.y+15)
		love.graphics.print(self.y, self.x + self.w + 5, self.y+30)
	end
end

function Room:update(dt)
   
end