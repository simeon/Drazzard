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

   e.isShooting = false

   -- graphics
   e.image = love.graphics.newImage("sprites/entities/knight.png")
   e.image:setFilter("nearest")
   return e
end

function Entity:draw(dt)
	if self ~= player then
		love.graphics.setColor(255, 0, 0, 50)
		love.graphics.circle("line", self.x+self.w/2, self.y+self.h/2, 50)
		love.graphics.setColor(255, 255, 255, 255)
	end

	if self ~= player and (player.xScreen+player.w/2 < self.xScreen+self.w/2) then 
		love.graphics.draw(self.image, self.x, self.y, 0, -3, 3, self.w/3, 0)
	elseif self == player and (love.mouse.getX() < self.xScreen+self.w/2) then 
		love.graphics.draw(self.image, self.x, self.y, 0, -3, 3, self.w/3, 0)
	else
		love.graphics.draw(self.image, self.x, self.y, 0, 3, 3)
	end

	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", self.x, self.y - 15, self.health * (self.w/100), 5)
	love.graphics.setColor(0, 200, 200)
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

	-- damage within radius
	for k,v in ipairs(entities) do
		if v ~= player then
			if distance(v.x, v.y, player.x, player.y) < 50 then
				love.graphics.line(self.x+self.w/2, self.y+self.h/2, player.x+self.w/2, player.y+self.h/2)
			end
		end
	end


	if debug then
		love.graphics.setColor(255, 255, 255, 100)
		love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
		love.graphics.print(self.name, self.x + self.w + 5, self.y)
		love.graphics.print("A:"..math.floor(self.x)..","..math.floor(self.y), self.x + self.w + 5, self.y+15)
		love.graphics.print("S:"..math.floor(self.xScreen)..","..math.floor(self.yScreen), self.x + self.w + 5, self.y+30)
		love.graphics.setColor(255, 255, 255, 255)
	end
end

function Entity:update(dt)
	if self == player and self.health <= 0 then
		isPaused = true
	elseif self ~= player and self.health <= 0 then
		self:destroy()
	end

	if self.health < 100 then self.health = self.health + 5 * dt end
	if self.mana < 100 then self.mana = self.mana + 5 * dt end

	if self.sprinting then
		self.mana = self.mana - 20 * dt
	end

	-- checks if hit by damage wall
	for k,v in ipairs(blocks) do
		if v.name == "damage" and v.owner ~= self and checkCollision(self.x, self.y, self.w, self.h, v.x, v.y, v.w, v.h) then
			self.health = self.health - 30 *dt
		end
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

function Entity:destroy()
	for i = #entities, 1, -1 do
	    if entities[i] == self then
	        table.remove(entities, i)
	    end
	end
end