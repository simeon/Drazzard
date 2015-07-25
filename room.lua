Room = {}
Room.__index = Room

function Room.create(n, t, x, y, w, h)
   local r = {}             -- our new object
   setmetatable(r, Room)  -- make Account handle lookup
   r.name = n or "NO NAME"
   r.type = t or "hall"
   r.x = x * tilesize or 0
   r.y = y * tilesize or 0
   r.w = w * tilesize or 0
   r.h = h * tilesize or 0
   r.status = "new"

   return r
end

function Room:draw(dt)

   if current_room == self then
      love.graphics.setColor(0, 255, 0)
   end
   love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
   love.graphics.setColor(255, 255, 255)
   love.graphics.printf(self.name.." "..self.type.."\n("..self.status..")", self.x, self.y, self.w, "center")

	
   if debug then
		love.graphics.print(self.x, self.x + self.w + 5, self.y+15)
		love.graphics.print(self.y, self.x + self.w + 5, self.y+30)
	end
end

function Room:update(dt)
   if checkCollision(player.x, player.y, player.w, player.h, self.x, self.y, self.w, self.h) then
      current_room = self
   end
end