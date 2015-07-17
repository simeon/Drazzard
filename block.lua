Block = {}
Block.__index = Block

function Block.create(n, x, y, dx, dy, w, h)
   local b = {}             -- our new object
   setmetatable(b, Block)  -- make Account handle lookup
   b.name = n or "NO NAME"
   b.x = x or 100
   b.y = y or 100
   b.w = w or 16
   b.h = h or 16

   b.dx = dx or 0
   b.dy = dy or 0

   b.xScreen = x
   b.yScreen = y
   return b
end

function Block:draw(dt)
   love.graphics.setColor(255, 200, 0)
	love.graphics.circle("fill", self.x, self.y, self.w/2, self.h)
   love.graphics.setColor(255, 200, 0)
   

	if debug then
		love.graphics.print(self.x, self.x + self.w + 5, self.y+15)
		love.graphics.print(self.y, self.x + self.w + 5, self.y+30)
	end
end

function Block:update(dt)
   self.x = self.x + self.dx * dt
   self.y = self.y + self.dy * dt

   self.xScreen = self.x + translateX
   self.yScreen = self.y + translateY
end