Entity = {}
Entity.__index = Entity

function Entity.create(n, x, y, weapon)
	local e = {}             -- our new object
	setmetatable(e, Entity)  -- make Account handle lookup
	e.level = 1.1 * enemies_killed

	e.name = n
	e.x = x or 100
	e.y = y or 100
	e.w = w or 32
	e.h = h or 32

	e.dx = 0
	e.dy = -50
	e.speed = 50

	e.xScreen = x
	e.yScreen = y

	e.total_health = 100 * e.level
	e.health = e.total_health
	e.total_mana = 100
	e.mana = 100

	e.isShooting = false

	if self == player then 
		e.range = 75
		e.damage = 20
	else 
		e.range = 50
		e.damage = 20
	end
	e.fov = .5

	e.gold = 0
	-- graphics
	e.image = love.graphics.newImage("assets/sprites/entities/knight.png")
	e.image:setFilter("nearest")
	return e
end

function Entity:draw(dt)
	if self ~= player then
		love.graphics.setColor(255, 0, 0, 50)
		love.graphics.circle("line", self.x+self.w/2, self.y+self.h/2, self.range)
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
	love.graphics.rectangle("fill", self.x, self.y - 15, self.health * (self.w/self.total_health), 5)
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
	-- death condition
	if self == player and self.health <= 0 then
		isPaused = true
	elseif self ~= player and self.health <= 0 then
		self:destroy()
		enemies_killed = enemies_killed + 1
		score = score + 100
		player.gold = player.gold + 100
	end

	-- health & mana regeneration
	if self.health < 100 then self.health = self.health + 5 * dt end
	if self.mana < 100 then self.mana = self.mana + 10 * dt end

	if self.sprinting then
		self.mana = self.mana - 20 * dt
	end

	-- checks if hit by damaging block
	for k,v in ipairs(blocks) do
		if v.name == "damage" and v.owner ~= self and checkCollision(self.x, self.y, self.w, self.h, v.x, v.y, v.w, v.h) then
			self.health = self.health - 100*dt
		end
	end

	-- AI & Collision for non-players
	if self ~= player then
		self:AI()
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

function Entity:AI(level)
	self.dx = 0
	self.dy = 0

	local angle = math.atan2(player.y - self.y, player.x - self.x)
	if not self:collidingLeft() and math.cos(angle) < 0 then
		self.dx = self.speed*math.cos(angle)
	end
	if not self:collidingRight() and math.cos(angle) > 0 then
		self.dx = self.speed*math.cos(angle)
	end
	if not self:collidingTop() and math.sin(angle) < 0 then
		self.dy = self.speed*math.sin(angle)
	end
	if not self:collidingBottom() and math.sin(angle) > 0 then
		self.dy = self.speed*math.sin(angle)
	end
end



