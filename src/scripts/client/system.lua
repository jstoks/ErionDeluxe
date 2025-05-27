erion = erion or {}
erion.System = erion.System or {}

erion.System.PackageName = "@PKGNAME@"

function erion.System:boot()
  if self:cleanup() then
    debugc("Cleanup on shutdown failed.")
  end

  registerNamedEventHandler(self.PackageName, "handleSysInstallPackage", 'sysInstallPackage', function (_, packageName)
    if self.PackageName ~= packageName then return true end

    self:raiseBoot()
  end, true)

  registerNamedEventHandler(self.PackageName, "handleSysLoadEvent", 'sysLoadEvent', function ()
    self:raiseBoot()
  end, true)

  registerNamedEventHandler(self.PackageName, 'handleSysUninstallPackage', 'sysUninstallPackage', function (_, packageName)
    if self.PackageName ~= packageName then return true end

    self:shutdown()
  end, true)

  registerNamedEventHandler(self.PackageName, 'handleSysUnloadEvent', 'sysUnloadEvent', function ()
    self:shutdown()
  end, true)
end

function erion.System:cleanup()
  return deleteNamedEventHandler(self.PackageName, 'handleSysInstallPackage') or
    deleteNamedEventHandler(self.PackageName, 'handleSysLoadEvent') or
    deleteNamedEventHandler(self.PackageName, 'handleSysUninstallPackage') or
    deleteNamedEventHandler(self.PackageName, 'handleSysUnloadEvent')
end

function erion.System:shutdown()
  debugc("Shutdown: " .. self.PackageName)
  raiseEvent('erion.client.shutdown')

  debugc("Cleanup: " .. self.PackageName)
  deleteAllNamedEventHandlers(self.PackageName)
end

function erion.System:raiseBoot()
  debugc("---=== BOOTING ===---")
  raiseEvent('erion.client.boot')
  debugc("---=== INITIALIZE ===---")
  raiseEvent('erion.client.init')

  deleteNamedEventHandler(self.PackageName, 'handleSysInstallPackage')
  deleteNamedEventHandler(self.PackageName, 'handleSysLoadEvent')
end

erion.System:boot()
