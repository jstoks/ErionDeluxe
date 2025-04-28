erion = erion or {}

erion.Dispatcher = {}
local Dispatcher = erion.Dispatcher

Dispatcher.__index = Dispatcher

function Dispatcher:new(packageName, name, callbacks)
  callbacks = callbacks or {}

  dispatcher = {
    packageName = packageName,
    name = name,
    handlerIds = {},
  }

  setmetatable(dispatcher, self)

  dispatcher:onShutdown(function () 
    debugc("Dispatcher Shutdown: " .. name)
    dispatcher:killAllHandlers()
  end)

  if callbacks.onInit then
    dispatcher:onInit(callbacks.onInit)
  end

  if callbacks.onShutdown then
    dispatcher:onShutdown(callback.onShutdown)
  end

  return dispatcher
end

function Dispatcher:onInit(callback)
  self:registerHandler('erion.client.init', callback, true)
end

function Dispatcher:onShutdown(callback)
  self:registerHandler('erion.client.shutdown', function (evKey, packageName)
    if packageName ~= self.packageName then return true end

    callback(evKey, packageName)
  end, true)
end

function Dispatcher:registerHandler(eventKey, callback, once)
  debugc("Registering: " .. eventKey)
  local handlerId = registerAnonymousEventHandler(eventKey, callback, once)

  if not self.handlerIds[eventKey] then
    self.handlerIds[eventKey] = {}
  end

  table.insert(self.handlerIds[eventKey], handlerId)

  return handlerId
end

function Dispatcher:killHandlers(eventKey)
  for idx, handlerId in ipairs(self.handlerIds[eventKey]) do
    killAnonymousEventHandler(handlerId)
  end
end

function Dispatcher:killAllHandlers()
  for key, _ in pairs(self.handlerIds) do
    self:killHandlers(key)
  end
end
