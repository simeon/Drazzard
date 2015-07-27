Tile = {}
Tile.__index = Tile

function Tile.create(n, x, y, w, h)
   local t = {} 
   setmetatable(t, Tile) 
   t.name = n or "stone"
   t.x = x * tilesize or 0
   t.y = y * tilesize or 0
   t.xC = x
   t.yC = y
   t.w = tilesize
   t.h = tilesize

   t.role = " "
   t.rand = math.random()
   return t
end

function Tile:draw(dt)

   love.graphics.setColor(255, 255, 255, 255-distance(player.x+player.w/2, player.y+player.h/2, self.x+self.w/2, self.y+self.h/2))
   if distance(player.x+player.w/2, player.y+player.h/2, self.x+self.w/2, self.y+self.h/2) < 255 then
      if self.name == "stone" then
         if self.role == "C" then
            love.graphics.draw(stone_tile, self.x, self.y)
         elseif self.role == "C2" then
            love.graphics.draw(stone_tile_alt, self.x, self.y)
         elseif self.role == "C3" then
            love.graphics.draw(stone_tile_alt2, self.x, self.y)
         elseif self.role == "W" then
            love.graphics.draw(stone_tile_W, self.x, self.y)
         elseif self.role == "E" then
            love.graphics.draw(stone_tile_E, self.x, self.y)
         elseif self.role == "S" then
            love.graphics.draw(stone_tile_S, self.x, self.y)
            love.graphics.draw(stone_tile_SIDEalt, self.x, self.y+tilesize)
         elseif self.role == "N" then
            love.graphics.draw(stone_tile_N, self.x, self.y)


         elseif self.role == "NW" then
            love.graphics.draw(stone_tile_NW, self.x, self.y)
         elseif self.role == "NE" then
            love.graphics.draw(stone_tile_NE, self.x, self.y)
         elseif self.role == "SW" then
            love.graphics.draw(stone_tile_SW, self.x, self.y)
            love.graphics.draw(stone_tile_SIDEalt, self.x, self.y+tilesize)
         elseif self.role == "SE" then
            love.graphics.draw(stone_tile_SE, self.x, self.y)
            love.graphics.draw(stone_tile_SIDEalt, self.x, self.y+tilesize)

         elseif self.role == "C-V" then
            love.graphics.draw(stone_tile_C_V, self.x, self.y)
         elseif self.role == "C-H" then
            love.graphics.draw(stone_tile_C_H, self.x, self.y)
            love.graphics.draw(stone_tile_SIDEalt, self.x, self.y+tilesize)
         elseif self.role == "C-A" then
            love.graphics.draw(stone_tile_C_A, self.x, self.y)

         elseif self.role == "N-P" then
            love.graphics.draw(stone_tile_N_P, self.x, self.y)
            love.graphics.draw(stone_tile_SIDEalt, self.x, self.y+tilesize)
         elseif self.role == "W-P" then
            love.graphics.draw(stone_tile_W_P, self.x, self.y)
            love.graphics.draw(stone_tile_SIDEalt, self.x, self.y+tilesize)
         elseif self.role == "E-P" then
            love.graphics.draw(stone_tile_E_P, self.x, self.y)
            love.graphics.draw(stone_tile_SIDEalt, self.x, self.y+tilesize)
         elseif self.role == "S-P" then
            love.graphics.draw(stone_tile_S_P, self.x, self.y)
            love.graphics.draw(stone_tile_SIDEalt, self.x, self.y+tilesize)
         end
      elseif self.name == "bridge" then
         if self.role == "V" then
            love.graphics.draw(bridge_tile_V, self.x, self.y)
         elseif self.role == "H" then
            love.graphics.draw(bridge_tile_H, self.x, self.y)
         end
      end
   end
   love.graphics.setColor(255, 255, 255, 255)

   if debug then
      love.graphics.print(self.x/tilesize, self.x, self.y-5)
		love.graphics.print(self.y/tilesize, self.x, self.y+5)
      love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	end
end

function Tile:update(dt)
   if checkCollision(player.x, player.y, player.w, player.h, self.x, self.y, self.w, self.h) then
      current_Tile = self
   end
end

function Tile:collidesLeft()
   for k,v in ipairs(tiles) do
      if v ~= self and distance(self.x, self.y, v.x, v.y) < 200 and checkCollision(self.x-1, self.y, self.w, self.h, v.x, v.y, v.w, v.h) then
         return true
      end
   end
end

function Tile:collidesRight()
   for k,v in ipairs(tiles) do
      if v ~= self and distance(self.x, self.y, v.x, v.y) < 200 and checkCollision(self.x+1, self.y, self.w, self.h, v.x, v.y, v.w, v.h) then
         return true
      end
   end
end

function Tile:collidesTop()
   for k,v in ipairs(tiles) do
      if v ~= self and distance(self.x, self.y, v.x, v.y) < 200 and checkCollision(self.x, self.y-1, self.w, self.h, v.x, v.y, v.w, v.h) then
         return true
      end
   end
end

function Tile:collidesBottom()
   for k,v in ipairs(tiles) do
      if v ~= self and distance(self.x, self.y, v.x, v.y) < 200 and checkCollision(self.x, self.y+1, self.w, self.h, v.x, v.y, v.w, v.h) then
         return true
      end
   end
end
