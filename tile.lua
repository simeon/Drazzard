Tile = {}
Tile.__index = Tile

function Tile.create(n, x, y, w, h)
   local t = {} 
   setmetatable(t, Tile) 
   t.type = t or "stone_tile"
   t.x = x * tilesize or 0
   t.y = y * tilesize or 0
   t.xC = x
   t.yC = y
   t.w = tilesize
   t.h = tilesize

   return t
end

function Tile:draw(dt)

   --love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
   --love.graphics.setColor(255, 255, 255)

   if debug then
		love.graphics.print(self.xC, self.x, self.y)
		love.graphics.print(self.yC, self.x, self.y+15)
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
      if v ~= self and checkCollision(self.x-1, self.y, self.w, self.h, v.x, v.y, v.w, v.h) then
         return true
      end
   end
end

function Tile:collidesRight()
   for k,v in ipairs(tiles) do
      if v ~= self and checkCollision(self.x+1, self.y, self.w, self.h, v.x, v.y, v.w, v.h) then
         return true
      end
   end
end

function Tile:collidesTop()
   for k,v in ipairs(tiles) do
      if v ~= self and checkCollision(self.x, self.y-1, self.w, self.h, v.x, v.y, v.w, v.h) then
         return true
      end
   end
end

function Tile:collidesBottom()
   for k,v in ipairs(tiles) do
      if v ~= self and checkCollision(self.x, self.y+1, self.w, self.h, v.x, v.y, v.w, v.h) then
         return true
      end
   end
end