Item = {}
Item.__index = Item

function Item.create(n, p, v, l, x, y, w, h)
    local i = {}             -- our new object
    setmetatable(i, Item)  -- make Account handle lookup
    i.name = n or "NO NAME"
    i.path = p or "NO PATH"
    i.var = v or "NO VAR"
    i.x = x or 100
    i.y = y or 100
    i.w = w or 150
    i.h = h or 75

    i.level = 1
    i.max_level = l
    i.cost = 100

    i.xScreen = x
    i.yScreen = y

    i.image = love.graphics.newImage("assets/sprites/items/"..i.path..".png")

    return i
end

function Item:draw(dt)
    love.graphics.draw(self.image, self.x+self.w/2, self.y-45, 0, 1, 1, 32, 32)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.printf(self.name, self.x, self.y+8, self.w, "center")
    if self.level >= self.max_level then
      love.graphics.printf("Max Level", self.x, self.y+30, self.w, "center")
      love.graphics.printf("Level: "..self.level, self.x, self.y+45, self.w, "center")
    else
      love.graphics.printf(self.cost.." gold", self.x, self.y+30, self.w, "center")
      love.graphics.printf("Level: "..self.level, self.x, self.y+45, self.w, "center")
    end

    if debug then
    	love.graphics.print(self.x, self.x + self.w + 5, self.y+15)
    	love.graphics.print(self.y, self.x + self.w + 5, self.y+30)
    end
end

function Item:update(dt)

end

function Item:destroy()
    for i = #Items, 1, -1 do
        if Items[i] == self then
            table.remove(Items, i)
        end
    end
end