Button = {}
Button.__index = Button

function Button.create(n, p, x, y, w, h)
   local b = {}             -- our new object
   setmetatable(b, Button)  -- make Account handle lookup
   b.name = n or "NO NAME"
   b.path = p or "NO PATH"
   b.x = x or 100
   b.y = y or 100
   b.w = w or 200
   b.h = h or 50
   b.cost = 50

   b.xScreen = x
   b.yScreen = y

   b.image = love.graphics.newImage("assets/sprites/GUI/base_button.png")
   return b
end

function Button:draw(dt)
   love.graphics.draw(self.image, self.x, self.y)
   love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

   if self.path == "FOV" then
      love.graphics.print("Field of View: "..player.fov, self.x, self.y-20)
      love.graphics.print(" +10 Field of View", self.x+10, self.y+20)
   elseif self.path == "RANGE" then
      love.graphics.print("Range: "..player.range, self.x, self.y)
   elseif self.path == "DAMAGE" then
      love.graphics.print("Damage: "..player.damage, self.x, self.y)
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