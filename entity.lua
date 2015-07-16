Entity = {}
Entity.__index = Entity

function Entity.create(n, x, y, weapon)
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

   e.health = 100
   e.mana = 100

   e.sprinting = false

   e.weapon = weapon or nil

   return e
end

function Entity:draw(dt)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	love.graphics.setColor(0, 255, 0)
	love.graphics.rectangle("fill", self.x, self.y - 15, self.health * (self.w/100), 5)
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", self.x, self.y - 10, self.mana * (self.w/100), 5)
	love.graphics.setColor(255, 255, 255)


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
	if self.health < 100 then self.health = self.health + 1 * dt end
	if self.mana < 100 then self.mana = self.mana + 10 * dt end

	if self.sprinting then
		self.mana = self.mana - 20 * dt
	end


	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

	self.xScreen = self.x + translateX
	self.yScreen = self.y + translateY
end


function Entity:colliding()
	return self:collidingRight() or
	self:collidingRight() or
	self:collidingTop() or
	self:collidingBottom()
end

function Entity:attack()
	if self.weapon ~= nil then
		
	end
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