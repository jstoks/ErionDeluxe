--[[
-- Add this file to a folder in the profil's script.
--
-- Do Not Add it to the ErionDeluxe folder!
-- I also don't recommend adding it to the Muddler folder.
--]]
local function packageKiller(name)
  return function ()
    for pkgName, _ in pairs(package.loaded) do
      if pkgName:find(name) then
        debugc("Uncaching lua package " .. pkgName)
        package.loaded[pkgName] = nil
      end
    end
  end
end

Reboot = Reboot or {
  packages = {},
}

function Reboot.addPackage(name, path)
  if Reboot.packages[name] then Reboot.packages[name]:stop() end
  
  Reboot.packages[name] = Muddler:new({
    path = path,
    postremove = packageKiller(name)
  })
end

function Reboot.start()
  -- Edit this to the absolute path on your system
  local pathToErionDeluxeCode

  if not Reboot.packages['ErionDeluxe'] then
    Reboot.addPackage('ErionDeluxe', pathToErionDeluxeCode)
  end
end

function Reboot.all()
  for _, pkg in ipairs(Reboot.packages) do
    if pkg then
      pkg:reload()
    end
  end
end
Reboot.start()
