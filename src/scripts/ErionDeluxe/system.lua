erion = erion or {}

--- Root of the entire package initializes the foundational pieces and then runs the client
--- @event erion.system.boot Use this event to do any initialization within a module.
--- @event erion.system.init Use this event to do any intializiation between modules
--- @event erion.system.client Use this event to start the client. It's meant to be used by the client of the package.
--- @event erion.system.shutdown Use this event to shutdown a module before unloading it.
--- @event erion.system.cleanup Use this event to do final clean up. Since modules use events this is where they can be deleted.
erion.system = erion.system or {
  PACKAGE_NAME = "@PKGNAME@",
  finalizers = {},
}

local system = erion.system


function system.boot()
  registerNamedEventHandler(system.PACKAGE_NAME, "handleSysInstallPackage", 'sysInstallPackage', function (_, packageName)
    if system.PACKAGE_NAME ~= packageName then return true end

    system.raiseBoot()
  end)

  registerNamedEventHandler(system.PACKAGE_NAME, "handleSysLoadEvent", 'sysLoadEvent', function ()
    system.raiseBoot()
  end)

  registerNamedEventHandler(system.PACKAGE_NAME, 'handleSysUninstallPackage', 'sysUninstallPackage', function (_, packageName)
    if system.PACKAGE_NAME ~= packageName then return true end

    system.raiseShutdown()
  end)

  registerNamedEventHandler(system.PACKAGE_NAME, 'handleSysUnloadEvent', 'sysUnloadEvent', function ()
    system.raiseShutdown()
  end)
end

function system.cleanup()
  return deleteNamedEventHandler(system.PACKAGE_NAME, 'handleSysInstallPackage') or
    deleteNamedEventHandler(system.PACKAGE_NAME, 'handleSysLoadEvent') or
    deleteNamedEventHandler(system.PACKAGE_NAME, 'handleSysUninstallPackage') or
    deleteNamedEventHandler(system.PACKAGE_NAME, 'handleSysUnloadEvent')
end

function system.registerFinal(callback)
  local handlerId = registerAnonymousEventHandler('erion.system.final', callback, true)
  table.insert(erion.system.finalizers, handlerId)
  return handlerId
end

-- @internal
function system.raiseShutdown()
  debugc("---=== SHUTDOWN ===---")
  raiseEvent('erion.system.shutdown')

  debugc("---=== CLEAN UP ===---")
  raiseEvent('erion.system.cleanup')

  debugc("---=== FINAL ===---")
  raiseEvent('erion.system.final')

  system.purgeFinalizers()

  deleteAllNamedEventHandlers(system.PACKAGE_NAME)
end

-- @internal
function system.purgeFinalizers()
  for _, handlerId in ipairs(system.finalizers) do
    killAnonymousEventHandler(handlerId)
  end

  system.finalizers = {}
end

-- @internal
function system.raiseBoot()
  debugc("---=== BOOTING ===---")
  raiseEvent('erion.system.boot')

  debugc("---=== INITIALIZE ===---")
  raiseEvent('erion.system.init')

  debugc("---=== MAIN === ---")
  raiseEvent('erion.system.main')

  deleteNamedEventHandler(system.PACKAGE_NAME, 'handleSysInstallPackage')
  deleteNamedEventHandler(system.PACKAGE_NAME, 'handleSysLoadEvent')
end

system.boot()
