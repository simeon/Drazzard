Weapon = {}
Weapon.__index = Weapon

function Weapon.create(n, d)
   local v = {}             -- our new object
   setmetatable(v, Weapon)  -- make Account handle lookup
   v.name = n or "NO NAME"
   v.damage = d or 20
   return v
end

function Weapon:draw(dt)
end

function Weapon:update(dt)
end