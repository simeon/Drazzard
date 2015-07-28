Wall = {}
Wall.__index = Wall

function Wall.create(n, x, y, w, h)
   local v = {}            
   setmetatable(v, Wall)  
   v.name = n or "NO NAME"
   v.x = x * tilesize or 0
   v.y = y * tilesize or 0
   v.w = tilesize
   v.h = tilesize

   return v
end

function Wall:draw(dt)
   love.graphics.setColor(255, 255, 255, 255-distance(player.x+player.w/2, player.y+player.h/2, self.x+self.w/2, self.y+self.h/2))
   if distance(player.x+player.w/2, player.y+player.h/2, self.x+self.w/2, self.y+self.h/2) < 255 then
      love.graphics.draw(wall_tile_barrel, self.x, self.y)
   end
   love.graphics.setColor(255, 255, 255, 255)

	if debug then
		love.graphics.print(self.x, self.x + self.w + 5, self.y+15)
		love.graphics.print(self.y, self.x + self.w + 5, self.y+30)
      love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	end
end

function Wall:update(dt)
   
end