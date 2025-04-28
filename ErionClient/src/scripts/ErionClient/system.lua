erion = erion or {}
erion.packages = erion.packages or {}
erion.packages["@PKGNAME@"] = "@PKGNAME@"

local System = {}
System.__index = System

function System:new()
  system = {
    handlerIds = {}
  }

  setmetatable(system, System)

  for _, pkg in pairs(erion.packages) do
    system:register(pkg)
  end
  
  return system
end
-- Create and setup a system.
-- Use once per package
function System:register(registeredPackageName)
  debugc("Registering Package: " .. registeredPackageName)
  if not self.handlerIds[registeredPackageName] then
    self.handlerIds[registeredPackageName] = {}
  else
    self:cleanup(registeredPackageName)
  end

  self.handlerIds[registeredPackageName].onInstall = registerAnonymousEventHandler('sysInstallPackage', function (_, packageName)
    if registeredPackageName ~= packageName then return true end

    self:raiseBoot()
  end, true)

  self.handlerIds[registeredPackageName].onLoad = registerAnonymousEventHandler('sysLoadEvent', function ()
    self:raiseBoot()
  end, true)

  self.handlerIds[registeredPackageName].onUninstall = registerAnonymousEventHandler('sysUninstallPackage', function (_, packageName)
    if registeredPackageName ~= packageName then return true end

    self:shutdown(registeredPackageName)
  end, true)

  self.handlerIds[registeredPackageName].onUnload = registerAnonymousEventHandler('sysUnloadEvent', function ()
    self:shutdown(registeredPackageName)
  end, true)
end

function System:shutdown(packageName)
  debugc("Shutdown: " .. packageName)
  raiseEvent('erion.client.shutdown', packageName)

  self:cleanup(packageName)
end

function System:raiseBoot()
  raiseEvent('erion.client.boot')
  raiseEvent('erion.client.init')

  -- Clear out all boot events. Since we don't boot per package.
  for pkg, events in pairs(self.handlerIds) do
    if events.onInstall then
      killAnonymousEventHandler(events.onInstall)
      events.onInstall = nil
    end
    if events.onLoad then
      killAnonymousEventHandler(events.onLoad)
      events.onLoad = nil
    end
  end
end

function System:cleanup(packageName)
  debugc("Cleanup: " .. packageName)
  for eventType, handlerId in pairs(self.handlerIds[packageName]) do
    if handlerId then
      killAnonymousEventHandler(handlerId)
    end
  end
end

function System:dispatcher(packageName, callbacks)
  return erion.Dispatcher:new(packageName, callbacks)
end

if not erion.system then
  erion.system = System:new()
else
  erion.system:register("@PKGNAME@")
end

