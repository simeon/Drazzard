Entity = {}
Entity.__index = Entity

function Entity.create(n, x, y, w, h)
   local e = {}             -- our new object
   setmetatable(e, Entity)  -- make Account handle lookup
   e.name = n
   e.x = x or 100
   e.y = y or 100
   e.w = w or 32
   e.h = h or 32

   e.dx = 0
   e.dy = 0

   e.speed = 100

   e.xScreen = x
   e.yScreen = y

   return e
end

function Entity:draw(dt)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

	if self:collidingLeft() then
		love.graphics.circle("fill", self.x, self.y + self.h/2, 3)
	end
	if self:collidingRight() then
		love.graphics.circle("fill", self.x + self.w, self.y + self.h/2, 3)
	end
	if self:collidingTop() then
		love.graphics.circle("fill", self.x + self.w/2, self.y, 3)
	end
	if self:collidingBottom() then
		love.graphics.circle("fill", self.x + self.w/2, self.y + self.h, 3)
	end

	if debug then
		love.graphics.print(self.name, self.x + self.w + 5, self.y)
		love.graphics.print("A:"..math.floor(self.x)..","..math.floor(self.y), self.x + self.w + 5, self.y+15)
		love.graphics.print("S:"..math.floor(self.xScreen)..","..math.floor(self.yScreen), self.x + self.w + 5, self.y+30)
	end
end

function Entity:update(dt)
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

	self.xScreen = self.x + translateX
	self.yScreen = self.y + translateY
end


function Entity:colliding()
	return self:collidingRight()
end


function Entity:collidingLeft()
	for k,v in ipairs(walls) do
		if checkCollision(self.x-5, self.y, 5, self.h, v.x, v.y, v.w, v.h) then
			return true
		end
	end
	for k,v in ipairs(entities) do
		if self ~= v and checkCollision(self.x-5, self.y, 5, self.h, v.x, v.y, v.w, v.h) then
			return true
		end
	end
end

function Entity:collidingRight()
	for k,v in ipairs(walls) do
		if checkCollision(self.x+self.w, self.y, 5, self.h, v.x, v.y, v.w, v.h) then
			return true
		end
	end
	for k,v in ipairs(entities) do
		if self ~= v and checkCollision(self.x+self.w, self.y, 5, self.h, v.x, v.y, v.w, v.h) then
			return true
		end
	end
end

function Entity:collidingTop()
	for k,v in ipairs(walls) do
		if checkCollision(self.x, self.y - 5, self.w, 5, v.x, v.y, v.w, v.h) then
			return true
		end
	end
	for k,v in ipairs(entities) do
		if self ~= v and checkCollision(self.x, self.y - 5, self.w, 5, v.x, v.y, v.w, v.h) then
			return true
		end
	end
end

function Entity:collidingBottom()
	for k,v in ipairs(walls) do
		if checkCollision(self.x, self.y+self.h, self.w, 5, v.x, v.y, v.w, v.h) then
			return true
		end
	end
	for k,v in ipairs(entities) do
		if self ~= v and checkCollision(self.x, self.y+self.h, self.w, 5, v.x, v.y, v.w, v.h) then
			return true
		end
	end
end