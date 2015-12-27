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

	e.level = 100
	e.xp = 10
	e.health = 100
	e.mana = 100

	e.is_hovered = false
	e.is_selected = false

	e.range = 1
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
	if imageState1 then love.graphics.draw(self.image, self.x, self.y) else love.graphics.draw(self.image2, self.x, self.y) end

	if is_debugging then
		love.graphics.setColor(255, 255, 255, 100)
		love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
		love.graphics.print("("..math.floor(self.x)..","..math.floor(self.y)..")", self.x+self.w, self.y)

		-- collision hitboxes
		love.graphics.rectangle("fill", self.hitbox_up.x, self.hitbox_up.y, self.hitbox_up.w, self.hitbox_up.h)
		love.graphics.rectangle("fill", self.hitbox_down.x, self.hitbox_down.y, self.hitbox_down.w, self.hitbox_down.h)
		love.graphics.rectangle("fill", self.hitbox_left.x, self.hitbox_left.y, self.hitbox_left.w, self.hitbox_left.h)
		love.graphics.rectangle("fill", self.hitbox_right.x, self.hitbox_right.y, self.hitbox_right.w, self.hitbox_right.h)

		-- draws where player can move
		love.graphics.setColor(255, 255, 0, 255)
		if self.can_move_up then love.graphics.circle("fill", self.x+self.w/2, self.y, 5, 4) end
		if self.can_move_down then love.graphics.circle("fill", self.x+self.w/2, self.y+self.h, 5, 4) end
		if self.can_move_left then love.graphics.circle("fill", self.x, self.y+self.h/2, 5, 4) end
		if self.can_move_right then love.graphics.circle("fill", self.x+self.w, self.y+self.h/2, 5, 4) end

		love.graphics.setColor(255, 255, 255, 255)
	end
end

function Entity:update(dt)
	self.hitbox_up = {x=self.x+5, y=self.y-5, w=self.w-10, h=5}
	self.hitbox_down = {x=self.x+5, y=self.y+self.h, w=self.w-10, h=5}
	self.hitbox_left = {x=self.x-5, y=self.y+5, w=5, h=self.h-10}
	self.hitbox_right = {x=self.x+self.w, y=self.y+5, w=5, h=self.h-10}

	-- collision against other entities
	self.can_move_left = true
	self.can_move_right = true
	self.can_move_up = true
	self.can_move_down = true

	for k,v in ipairs(Entities) do
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
end