Object = {}
Object.__index = Object

function Object.create(t, x, y, w, h)
	local e = {}   
	setmetatable(e, Object)
	
	e.type = t
	e.x = x or 32
	e.y = y or 32
	e.w = w or tilesize
	e.h = h or tilesize

	e.dx = 0
	e.dy = 0

	e.is_solid = true
	e.is_explosive = false

	e.opacity = 255
	e.is_fading = false
	e.fade_rate = 30

	e.is_damaging = false
	e.collision_damage = 30
	e.creator = nil

	e.is_highlighted = false

	e.image = love.graphics.newImage("assets/"..e.type..".png")
	e.image:setFilter("nearest", "nearest")
	e.image2 = love.graphics.newImage("assets/"..e.type.."_alt.png")
	e.image2:setFilter("nearest", "nearest")
	return e
end

function Object:draw()
	love.graphics.setColor(255, 255, 255, self.opacity)
	if imageState1 then love.graphics.draw(self.image, self.x, self.y) else love.graphics.draw(self.image2, self.x, self.y) end

	if self.is_highlighted then
		love.graphics.setColor(255, 255, 255, 100)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
		love.graphics.setColor(255, 255, 255, 255)
	end
	love.graphics.setColor(255, 255, 255, 255)

	if is_debugging then
		love.graphics.setColor(255, 100, 255, 200)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
		love.graphics.setColor(255, 255, 255, 255)
		--love.graphics.print("("..self.x.."\n"..self.y..")", self.x, self.y)
	end
end

function Object:update(dt)
	-- prevent movement on collision against objects
	for k,v in ipairs(Objects) do
		if v ~= self and v.is_solid then
			if collision(v, self) then
				self.dx = 0
				self.dy = 0
				-- explodes if necessary
				self:explode()
			end
		end
	end

	-- damage against entities
	if self.is_damaging then
		for k,v in ipairs(Entities) do
			if collision(v, self) and v ~= self.creator then
				self.dx = 0
				self.dy = 0
				v.health = v.health - 1
				self:explode()
			end
		end
	end

	-- if has been marked to disappear gracefully
	if self.is_fading then
		self.opacity = self.opacity - self.fade_rate*dt
		if self.opacity < 0 then
			self:destroy()
		end
	end

	self.x = self.x + self.dx*dt
	self.y = self.y + self.dy*dt
end

function Object:explode( )
	if self.is_explosive and self.is_solid then
		explosion_sound:play()

		self.image = love.graphics.newImage("assets/explosion.png")
		self.image2 = love.graphics.newImage("assets/explosion_alt.png")
		self.is_solid = false
		self.is_fading = true
		self.fade_rate = 180
		for k,v in ipairs(Entities) do
			if math.distance(v.x+v.w/2, v.y+v.h/2, self.x+self.w/2, self.y+self.h/2) < 1.5*tilesize then
				v.health = v.health - 5
			end
		end
	end
end

function Object:destroy()
	for i = #Objects, 1, -1 do
	    if Objects[i] == self then
	        table.remove(Objects, i)
	    end
	end
end