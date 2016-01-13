Button = {}
Button.__index = Button

function Button.create(text, x, y, link, w, h)
	local e = {}   
	setmetatable(e, Button)
	
	e.text = text
	e.link = link or nil
	e.x = x or 32
	e.y = y or 32
	e.w = w or 8*tilesize
	e.h = h or 2*tilesize

	e.is_centered = false
	e.is_highlighted = false

	e.image = love.graphics.newImage("assets/button.png")
	e.image:setFilter("nearest", "nearest")
	return e
end

function Button:draw()

	if self.is_highlighted then
		love.graphics.setColor(200, 200, 200)
	end

	love.graphics.draw(self.image, self.x, self.y, 0, 2, 2)
	--love.graphics.setColor(255, 255, 255, 200)
	--love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	love.graphics.setFont(button_font)
	love.graphics.setColor(0, 0, 0)
	love.graphics.printf(self.text, self.x, self.y+7, self.w, "center")
	love.graphics.setColor(255, 255, 255)
	love.graphics.printf(self.text, self.x, self.y+10, self.w, "center")
	love.graphics.setFont(ui_font)

	if is_debugging then
		if self.link then love.graphics.printf(self.link, self.x, self.y, self.w, "center") end
		love.graphics.setColor(255, 255, 255, 80)
		love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
		--love.graphics.print("("..self.x.."\n"..self.y..")", self.x, self.y)
	end

	love.graphics.setColor(255, 255, 255)
end

function Button:update(dt)
	self.is_highlighted = mouseOverlaps(self)
end