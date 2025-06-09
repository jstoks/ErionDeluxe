erion = erion or {}
erion.events = erion.events or {}

local s = require("@PKGNAME@.schema")
local util = require "@PKGNAME@.util"

local EventType = {}

local events = erion.events
local eventData = {
  registry = {},
  handlers = {},
  handlerIds = {},
}

function events.registerAnonHandler(eventKey, callback)
  local id = registerAnonymousEventHandler(eventKey, callback)

  eventData.handlerIds[id] = nil

  return id
end

function events.registerHandler(namespace, eventKey, context, callback)
  return events.registerNamedHandler(util.handlerName(namespace, eventKey, context), eventKey, callback)
end

function events.registerNamedHandler(handlerName, eventKey, callback)
  registerNamedEventHandler("@PKGNAME@", handlerName, eventKey, callback)

  eventData.handlers[handlerName] = handlerName

  debugc("Registering Handler: " .. handlerName)

  return handlerName
end

function events.deleteHandler(namespace, eventKey, context)
  local handlerName = util.handlerName(namespace, eventKey, context)

  events.deleteNamedHandler(handlerName)
end

function events.deleteNamedHandler(name)
  eventData.handlers[name] = nil

  debugc("Unregistering Handler: " .. name)

  deleteNamedEventHandler("@PKGNAME@", name)
end

function events.deleteAnonHandler(id)
  eventData.handlerIds[id] = nil
  killAnonymousEventHandler(id)
end

function events.registerMsdpHandler(namespace, varName, context, callback)
  if not callback and type(context) == 'function' then
    callback = context
    context = nil
  end

  return events.registerMsdpNamedHandler(util.handlerName(namespace, varName, context), varName, callback)
end

function events.registerMsdpNamedHandler(handlerName, varName, callback)
  local _, _, connected = getConnectionInfo()
  local eventKey = 'msdp.' .. varName

  if connected then
    sendMSDP("REPORT", varName)
  else
    events.registerHandler(eventKey .. '.report', 'sysConnectedEvent', function () sendMSDP("REPORT", varName) end)
  end

  events.registerNamedHandler(handlerName, eventKey, callback)

  return handlerName
end

function events.raiseEvent(eventKey, ...)
  local eventType = events.lookupType(eventKey)

  if not eventType then
    debugc("Event Not Found: " .. eventKey)
    return
  end

  eventType:raiseEvent(...)
end

function events.newType(key, name, description, schema)
  local eventType = events.lookupType(key) or EventType:new(key, name, description, schema)
  events.addType(eventType)
  return eventType
end

function events.addType(eventType)
  eventData.registry[eventType.key] = eventType
end

function events.removeType(eventType)
  eventData.registry[eventType.key] = nil
end

function events.lookupType(eventKey)
  if type(eventKey) == 'table' then
    return eventKey
  end

  return eventData.registry[eventKey]
end


EventType.__index = EventType

function EventType:new(key, name, description, schema)
  local ev = {
    name = name,
    description = description,
    key = key,
    schema = schema or s.Any,
  }

  debugc("Define Event: " .. key)

  setmetatable(ev, self)

  return ev
end

function EventType:raise(...)
  local data = {...}
  local err = s.CheckSchema(data, self.schema)

  if err then
    debugc("EventType: " .. self.key)
    debugc("Schema error: " .. s.FormatOutput(err))
  end

  debugc("Raise: " .. self.key)

  raiseEvent(self.key, ...)
end

function EventType:registerHandler(namespace, context, callback)
  return self:registerNamedHandler(util.handlerName(namespace, self.key, context), callback)
end

function EventType:registerNamedHandler(handlerName, callback)
  events.registerNamedHandler(handlerName, self.fullKey, callback)

  return handlerName
end

function EventType:registerAnonymousHandler(callback)
  return registerAnonymousEventHandler(self.fullKey, callback)
end

registerNamedEventHandler(util.handlerTuple('erion.events', 'erion.system.final', function ()
  for _, handlerName in pairs(eventData.handlers) do
    events.deleteNamedHandler(handlerName)
  end

  for _, handlerId in pairs(eventData.handlerIds) do
    events.deleteAnonHandler(handlerId)
  end

  eventData.handlers = {}
  eventData.handlerIds = {}
  eventData.registry = {}
end))
