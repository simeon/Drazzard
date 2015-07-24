Button = {}
Button.__index = Button

function Button.create(n, p, x, y, c)
   local b = {}             -- our new object
   setmetatable(b, Button)  -- make Account handle lookup
   b.name = n or "NO NAME"
   b.path = p or "NO PATH"
   b.x = x or 100
   b.y = y or 100
   b.w = w or 200
   b.h = h or 50
   b.isCentered = c or false

   b.level = 1
   b.cost = 50

   b.xScreen = x
   b.yScreen = y

   b.image = love.graphics.newImage("assets/sprites/GUI/button.png")

   return b
end

function Button:draw(dt)
   if self.isCentered then
      -- love.graphics.rectangle("line", love.graphics.getWidth()/2 - self.w/2, self.y, self.w, self.h)
      love.graphics.draw(self.image, love.graphics.getWidth()/2 - self.w/2, self.y)
      love.graphics.setColor(0,0,0)
      love.graphics.printf(self.name, 0, self.y+12, love.graphics.getWidth(), "center")
      love.graphics.setColor(255, 255, 255)
   else
      -- love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
      love.graphics.draw(self.image, self.x, self.y)
      love.graphics.setColor(0,0,0)
      love.graphics.printf(self.name, self.x, self.y+12, self.w, "center")
      love.graphics.setColor(255, 255, 255)
   end

	if debug then
		love.graphics.print(self.x, self.x + self.w + 5, self.y+15)
		love.graphics.print(self.y, self.x + self.w + 5, self.y+30)
	end
end

function Button:update(dt)

end

function Button:destroy()
   for i = #Buttons, 1, -1 do
       if Buttons[i] == self then
           table.remove(Buttons, i)
       end
   end
end