Item = {}
Item.__index = Item

function Item.create(n, p, x, y, w, h)
    local i = {}             -- our new object
    setmetatable(i, Item)  -- make Account handle lookup
    i.name = n or "NO NAME"
    i.path = p or "NO PATH"
    i.x = x or 100
    i.y = y or 100
    i.w = w or 200
    i.h = h or 50

    i.level = 1
    i.cost = 50

    i.xScreen = x
    i.yScreen = y

    return i
end

function Item:draw(dt)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.printf(self.name, self.x, self.y+12, self.w, "center")

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