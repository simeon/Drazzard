Entity = {}
Entity.__index = Entity

function Entity.create(n, x, y)
	local e = {}   
	setmetatable(e, Entity)
	
	e.name = n
	e.x = x or 100
	e.y = y or 100
	e.w = w or tilesize
	e.h = h or tilesize
	e.dx = 0
	e.dy = 0

	e.demeanor = "friendly" -- friendly, neutral, or hostile
	e.direction = "left"
	e.looks_at_target = false

	e.level = 100
	e.xp = 10
	e.health = 80
	e.mana = 50


	e.sight_range = 0*tilesize
	e.attack_range = 0*tilesize
	e.target = player

	e.speed = 40
	e.can_move_left = true
	e.can_move_right = true
	e.can_move_up = true
	e.can_move_down = true

	e.hitbox_up = {x=e.x, y=e.y, w=e.w, h=5}
	e.hitbox_down = {x=e.x, y=e.y, w=e.w, h=5}
	e.hitbox_left = {x=e.x, y=e.y, w=e.w, h=5}
	e.hitbox_right = {x=e.x, y=e.y, w=e.w, h=5}

	e.image = love.graphics.newImage("assets/"..e.name..".png")
	e.image:setFilter("nearest", "nearest")
	e.image2 = love.graphics.newImage("assets/"..e.name.."_alt.png")
	e.image2:setFilter("nearest", "nearest")

	return e
end

function Entity:draw()
	-- draws sprite
	if imageState1 then
		if self.direction == "left" then
			love.graphics.draw(self.image, self.x, self.y)
		elseif self.direction == "right" then
			love.graphics.draw(self.image, self.x, self.y, 0, -1, 1, self.w, 0)
		end
	else 
		if self.direction == "left" then
			love.graphics.draw(self.image2, self.x, self.y)
		elseif self.direction == "right" then
			love.graphics.draw(self.image2, self.x, self.y, 0, -1, 1, self.w, 0)
		end
	end

	if is_debugging then
		-- draws statbars
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", self.x, self.y-20, self.w, 10)
		love.graphics.setColor(255, 0, 0)
		love.graphics.rectangle("fill", self.x, self.y-20, self.health/100*self.w, 5)
		love.graphics.setColor(0, 200, 255)
		love.graphics.rectangle("fill", self.x, self.y-15, self.mana/100*self.w, 5)
		love.graphics.setColor(255, 255, 255)

		-- vision range
		love.graphics.circle("line", self.x+self.w/2, self.y+self.h/2, self.sight_range)
		love.graphics.circle("line", self.x+self.w/2, self.y+self.h/2, self.attack_range)

		love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
		love.graphics.print("("..math.floor(self.x)..","..math.floor(self.y)..")", self.x+self.w, self.y)

		if self.demeanor == "friendly" then	love.graphics.setColor(0, 255, 0) elseif self.demeanor == "neutral" then love.graphics.setColor(255, 255, 255, 100) elseif self.demeanor == "hostile" then love.graphics.setColor(255, 0, 0) end

		-- collision hitboxes
		love.graphics.rectangle("fill", self.hitbox_up.x, self.hitbox_up.y, self.hitbox_up.w, self.hitbox_up.h)
		love.graphics.rectangle("fill", self.hitbox_down.x, self.hitbox_down.y, self.hitbox_down.w, self.hitbox_down.h)
		love.graphics.rectangle("fill", self.hitbox_left.x, self.hitbox_left.y, self.hitbox_left.w, self.hitbox_left.h)
		love.graphics.rectangle("fill", self.hitbox_right.x, self.hitbox_right.y, self.hitbox_right.w, self.hitbox_right.h)

		-- draws where entity can move
		love.graphics.setColor(255, 255, 0, 255)
		if self.can_move_up then love.graphics.circle("fill", self.x+self.w/2, self.y, 5, 4) end
		if self.can_move_down then love.graphics.circle("fill", self.x+self.w/2, self.y+self.h, 5, 4) end
		if self.can_move_left then love.graphics.circle("fill", self.x, self.y+self.h/2, 5, 4) end
		if self.can_move_right then love.graphics.circle("fill", self.x+self.w, self.y+self.h/2, 5, 4) end
	end
	love.graphics.setColor(255, 255, 255, 255)
end

function Entity:update(dt)
	-- updates direction
	if self ~= player and self.looks_at_target then
		if player.x+player.w/2 < self.x+self.w/2 then
			self.direction = "left"
		else
			self.direction = "right"
		end
	end

	self.hitbox_up = {x=self.x+5, y=self.y-5, w=self.w-10, h=5}
	self.hitbox_down = {x=self.x+5, y=self.y+self.h, w=self.w-10, h=5}
	self.hitbox_left = {x=self.x-5, y=self.y+5, w=5, h=self.h-10}
	self.hitbox_right = {x=self.x+self.w, y=self.y+5, w=5, h=self.h-10}

	-- collision against other entities
	self.can_move_left, self.can_move_right, self.can_move_up, self.can_move_down = true, true, true, true

	for k,v in ipairs(Entities) do
		if v ~= self then
			-- takes damage if within attack range of enemy
			if math.distance(v.x+v.w/2, v.y+v.h/2, self.x+self.w/2, self.y+self.h/2) < v.attack_range and v.demeanor == "hostile" and self.demeanor ~= "hostile" then
				self.health = self.health - 30*dt
			end

			-- stops movement on collision
			if collision(v, self.hitbox_up) then
				self.can_move_up = false
			end
			if collision(v, self.hitbox_down) then
				self.can_move_down = false
			end
			if collision(v, self.hitbox_left) then
				self.can_move_left = false
			end
			if collision(v, self.hitbox_right) then
				self.can_move_right = false
			end
		end
	end

	-- prevent movement on collision against objects
	for k,v in ipairs(Objects) do
		if v ~= self then
			if collision(v, self.hitbox_up) then
				self.can_move_up = false
			end
			if collision(v, self.hitbox_down) then
				self.can_move_down = false
			end
			if collision(v, self.hitbox_left) then
				self.can_move_left = false
			end
			if collision(v, self.hitbox_right) then
				self.can_move_right = false
			end
		end
	end

	if self.demeanor == "hostile" then self:enemyAI(self.name, dt) end

	-- updates entity position
	self.x = self.x + self.dx
	self.y = self.y + self.dy
	self.dx, self.dy = 0, 0
end

function Entity:enemyAI(name, dt)
	self.looks_at_target = true
	if name == "blueslime" then
		ai_type = "simplefollow"
	end

	if ai_type == "simplefollow" then
		if math.distance(self.x+self.w/2, self.y+self.h/2, self.target.x+self.target.w/2, self.target.y+self.target.h/2) < self.sight_range then
			-- moves in direction of target
			local angle = math.angle(self.x, self.y, self.target.x, self.target.y)
			self.dx = math.cos(angle) * (dt * self.speed)
			self.dy = math.sin(angle) * (dt * self.speed)
			printvar = angle

			-- deals with obstacles
			if self.dy < 0 and not self.can_move_up then self.dy = 0 end
			if self.dy > 0 and not self.can_move_down then self.dy = 0 end
			if self.dx < 0 and not self.can_move_left then self.dx = 0 end
			if self.dx > 0 and not self.can_move_right then self.dx = 0 end

		end
	end
end