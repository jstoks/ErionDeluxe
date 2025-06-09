erion = erion or {}
erion.module = {}

local util = require "@PKGNAME@.util"

local moduleData = {
  modules = {}
}

local s = require("@PKGNAME@.schema")

local Module = {}
Module.__index = Module
local ModuleSchema = s.Record({
  namespace = s.String,
  onInit = s.Optional(s.Function),
  onShutdown = s.Optional(s.Function),
  onCleanup = s.Optional(s.Function),
  onFinal = s.Optional(s.Function),
  onMain = s.Optional(s.Function),
})

local module = erion.module

function module.extend(modTable)
  debugc("Extending: " .. modTable.namespace)

  modTable.eventTypes = {}
  modTable.handlerNames = {}
  modTable.handlerIds = {}
  modTable.triggerIds = {}
  modTable.events = {}

  setmetatable(modTable, Module)

  modTable:registerModuleHandlers()

  return modTable
end

function module.exists(namespace)
  return moduleData.modules[namespace]
end

function module.lookup(namespace)
  return moduleData.modules[namespace]
end

function Module:registerModuleHandlers()
  if self.onInit then
    self:registerHandler('erion.system.init', function () self:onInit() end)
  end

  if self.onMain then
    self:registerHandler('erion.system.main', function () self:onMain() end)
  end

  if self.onShutdown then
    self:registerHandler('erion.system.shutdown', function () self:onShutdown() end)
  end

  self:registerHandler('erion.system.cleanup', function ()
    if self.onCleanup then
      self:onCleanup()
    end

    self:cleanupEventSystem()
    setmetatable(self, nil)
  end)

  if self.onFinal then
    erion.system.registerFinal(function() self:onFinal() end)
  end
end

function Module:cleanupEventSystem()
  for _, name in pairs(self.handlerNames) do
    erion.events.deleteNamedHandler(name)
  end

  for _, id in ipairs(self.handlerIds) do
    erion.events.deleteAnonHandler(id)
  end

  for _, eventType in pairs(self.eventTypes) do
    erion.events.removeType(eventType)
  end

  self.handlerNames = {}
  self.handlerIds = {}
  self.eventTypes = {}
  self.events = {}
end

function Module:lookupEvent(key)
  if type(key) == 'table' then
    return key
  end

  return self.events[key] or erion.events.lookupType(key)
end

function Module:raiseEvent(key, ...)
  local event = self:lookupEvent(key)
  event:raise(...)
end

function Module:registerEvent(key, name, description, schema)
  if self:lookupEvent(key) then
    debugc(string.format("Event Already Regisetered: %s in %s", key, self.namespace))
  end

  local keyParts = util.undot(key)
  local lastPart = table.remove(keyParts)
  local iter = self.events

  for _, part in ipairs(keyParts) do
    if not iter[part] then
      iter[part] = {}
    end

    iter = iter[part]
  end

  local fullKey = self.namespace .. '.' .. key

  local eventType = erion.events.newType(fullKey, name, description, schema)

  self.eventTypes[key] = eventType
  iter[lastPart] = eventType

  return eventType
end

function Module:registerHandler(eventKey, context, callback)
  if not callback and type(context) == 'function' then
    callback = context
    context = nil
  end

  local handlerName = erion.events.registerHandler(self.namespace, eventKey, context, callback)

  if self.handlerNames[handlerName] then
    debugc(string.format("Handler Already Regisetered: %s in %s", handlerName, self.namespace))
  end

  self.handlerNames[handlerName] = handlerName

  return handlerName
end

function Module:registerNamedHandler(handlerName, eventKey, callback)
  if self.handlerNames[handlerName] then
    debugc(string.format("Handler Already Regisetered: %s in %s", handlerName, self.namespace))
  end

  erion.events.registerNamedHandler(handlerName, eventKey, callback)

  self.handlerNames[handlerName] = handlerName

  return handlerName
end

function Module:registerAnonHandler(eventKey, callback)
  table.insert(self.handlerIds, erion.events.registerAnonHandler(eventKey, callback))
end

function Module:makeTrigger(triggerFunction, eventType, patterns)
  if type(patterns) == 'string' then
    patterns = { patterns }
  end

  if self.triggerIds[eventType.key] then
    self.triggerIds[eventType.key] = {}
  end

  for _, pattern in ipairs(patterns) do
    if not triggerFunction then
      printDebug("no trigger functionw", true)
    end
    local id = triggerFunction(pattern, function () eventType:raise() end)
    if not self.triggerIds[eventType.key] then
      self.triggerIds[eventType.key] = {}
    end
    table.insert(self.triggerIds[eventType.key], id)
  end
end

function Module:regexTrigger(eventType, patterns)
  self:makeTrigger(erion.triggers.regexTrigger, eventType, patterns)
end

function Module:substringTrigger(eventType, patterns)
  self:makeTrigger(erion.triggers.substringTrigger, eventType, patterns)
end

function Module:beginTrigger(eventType, patterns)
  self:makeTrigger(erion.triggers.beginTrigger, eventType, patterns)
end

function Module:exactTrigger(eventType, patterns)
  self:makeTrigger(erion.triggers.exactTrigger, eventType, patterns)
end

function Module:msdpHandler(eventType, varName)
  local msdpName = erion.events.registerMsdpHandler(self.namespace, varName, function() eventType:raise() end)

  self.handlerNames[msdpName] = msdpName
end

local DefineEvent = {}

function Module:defineEvent(key, name, description, schema)
  local eventType = self:registerEvent(key, name, description, schema)

  local defEvent = {
    eventType = eventType,
    module = self,
  }

  setmetatable(defEvent, DefineEvent)

  return defEvent
end

DefineEvent.__index = DefineEvent

function DefineEvent:regexTrigger(patterns)
  self.module:regexTrigger(self.eventType, patterns)
  return self
end

function DefineEvent:substringTrigger(patterns)
  self.module:substringTrigger(self.eventType, patterns)
  return self
end

function DefineEvent:beginTrigger(patterns)
  self.module:beginTrigger(self.eventType, patterns)
  return self
end

function DefineEvent:exactTrigger(patterns)
  self.module:exactTrigger(self.eventType, patterns)
  return self
end

function DefineEvent:msdpHandler(key)
  self.module:msdpHandler(self.eventType, key)
  return self
end
