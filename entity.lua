Entity = {}
Entity.__index = Entity

function Entity.create(n, x, y, weapon)
	local e = {}             -- our new object
	setmetatable(e, Entity)  -- make Account handle lookup
	e.level = 1.1 * (enemies_killed+1)

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
	e.total_mana = 100 * e.level
	e.mana = e.total_mana

	e.regen = 5

	e.isShooting = false

	if self == player then 
		e.range = 80
		e.damage = 20
	else 
		e.range = 50
		e.damage = 20
	end
	e.fov = .5
	e.coinflip = math.random()


	e.gold = 0
	e.gold_boost = 1

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

	if self ~= player then
		love.graphics.setColor(255, 0, 0)
		love.graphics.rectangle("fill", self.x, self.y - 15, self.health * (self.w/self.total_health), 5)
		love.graphics.setColor(0, 200, 200)
		love.graphics.rectangle("fill", self.x, self.y - 10, self.mana * (self.w/self.total_mana), 5)
		love.graphics.setColor(255, 255, 255)
	end

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


	if self:canSee() then
		love.graphics.setColor(255, 255, 255)
	elseif not self:canSee() then
		love.graphics.setColor(255, 0, 0)
	end
	-- line of sght
	love.graphics.line(self.x+self.w/2, self.y+self.h/2, player.x+player.w/2, player.y+player.h/2)
	love.graphics.setColor(255, 255, 255)
end

function Entity:update(dt)
	-- death condition
	if self == player and self.health <= 0 then
		isPaused = true
		gamestate = "gameover"
	elseif self ~= player and self.health <= 0 then
		self:destroy()
		enemies_killed = enemies_killed + 1
		score = score + math.floor(100*self.level)
		player.gold = player.gold + math.floor(100*player.gold_boost*self.level/4)
		spawnEnemy(1)
	end

	-- health & mana regeneration
	if self.health < self.total_health then self.health = self.health + self.regen * dt end
	if self.mana < self.total_mana then self.mana = self.mana + 10 * dt end

	if self.sprinting then
		self.mana = self.mana - 20 * dt
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




function Entity:canSee()
	return self:canSeeLeft() and
		self:canSeeRight() and
		self:canSeeTop() and
		self:canSeeBottom()
end

function Entity:canSeeLeft()
	for k,v in ipairs(walls) do
		if self ~= player and self.y+self.h > v.y and self.y < v.y+v.h then
			if self.x > v.x+v.w and v.x > player.x+player.w then
				return false
			end
		end
	end
	return true
end

function Entity:canSeeRight()
	for k,v in ipairs(walls) do
		if self ~= player and self.y+self.h > v.y and self.y < v.y+v.h then
			if self.x+self.w < v.x and v.x+v.w < player.x then
				return false
			end
		end
	end
	return true
end

function Entity:canSeeTop()
	for k,v in ipairs(walls) do
		if self ~= player and self.x+self.w > v.x and self.x < v.x+v.w then
			if self.y > v.y+v.h and v.y > player.y+player.h then
				return false
			end
		end
	end
	return true
end

function Entity:canSeeBottom()
	for k,v in ipairs(walls) do
		if self ~= player and self.x+self.w > v.x and self.x < v.x+v.w then
			if self.y+self.h < v.y and v.y+v.h < player.y then
				return false
			end
		end
	end
	return true
end

function Entity:destroy()
	for i = #entities, 1, -1 do
	    if entities[i] == self then
	        table.remove(entities, i)
	    end
	end
end

function Entity:direction()
	if self.dx < 0 then return "left" end
	if self.dx > 0 then return "right" end
	if self.dy < 0 then return "up" end
	if self.dy > 0 then return "down" end
end



function Entity:canMove(dir)
	for k,v in ipairs(floors) do
		if dir == "left" then
			if checkCollision(self.x, self.y, -5, self.h, v.x, v.y, v.w, v.h) then
				return true
			end
		end
		if dir == "right" then
			if checkCollision(self.x+self.w, self.y, 5, self.h, v.x, v.y, v.w, v.h) then
				return true
			end
		end
		if dir == "top" then
			if checkCollision(self.x, self.y, self.w, -5, v.x, v.y, v.w, v.h) then
				return true
			end
		end
		if dir == "bottom" then
			if checkCollision(self.x, self.y+self.h, self.w, 5, v.x, v.y, v.w, v.h) then
				return true
			end
		end
	end
end





function Entity:AI(level)
	self.dx = 0
	self.dy = 0

	local angle = math.atan2(player.y - self.y, player.x - self.x)
	notice = angle
	if not self:collidingLeft() and self:canMove("left") and math.cos(angle) < 0 then
		self.dx = self.speed*math.cos(angle)
	end
	if not self:collidingRight() and self:canMove("right") and math.cos(angle) > 0 then
		self.dx = self.speed*math.cos(angle)
	end
	if not self:collidingTop() and self:canMove("top") and math.sin(angle) < 0 then
		self.dy = self.speed*math.sin(angle)
	end
	if not self:collidingBottom() and self:canMove("bottom") and math.sin(angle) > 0 then
		self.dy = self.speed*math.sin(angle)
	end
end



