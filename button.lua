Button = {}
Button.__index = Button

function Button.create(n, p, x, y, w, h)
   local b = {}             -- our new object
   setmetatable(b, Button)  -- make Account handle lookup
   b.name = n or "NO NAME"
   b.path = p or "NO PATH"
   b.x = x or 100
   b.y = y or 100
   b.w = w or 50
   b.h = h or 50
   b.cost = 50

   b.xScreen = x
   b.yScreen = y

   return b
end

function Button:draw(dt)
   love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
   love.graphics.print(self.name, self.x, self.y)
   love.graphics.print(self.path, self.x, self.y+15)


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