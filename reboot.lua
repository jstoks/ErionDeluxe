-- This is a script to allow Muddler reload these packages
-- Add it to your scripts, but not in any package that's going to get reloaded.


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
  -- Each of these should be a path to the development folders of these packages.
  local pathToErionClient = ''
  local pathToErionSoundpack = ''
  if not Reboot.packages['ErionClient'] then
    Reboot.addPackage('ErionClient', pathToErionClient)
  end
  if not Reboot.packages['ErionSoundpack'] then
    Reboot.addPackage('ErionSoundpack', pathToErionSoundpack)
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
