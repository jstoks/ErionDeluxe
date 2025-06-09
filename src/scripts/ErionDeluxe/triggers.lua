erion = erion or {}

local util = require "@PKGNAME@.util"

erion.triggers = {
  triggerIds = {}
}
local triggers = erion.triggers

function triggers.regexTrigger(pattern, callback)
  local id = tempRegexTrigger(pattern, callback)
  if id then
    triggers.triggerIds[id] = id
  end
  return id
end

function triggers.exactTrigger(pattern, callback)
  local id = tempExactMatchTrigger(pattern, callback)
  if id then
    triggers.triggerIds[id] = id
  end
  return id
end

function triggers.beginTrigger(pattern, callback)
  local id = tempBeginOfLineTrigger(pattern, callback)
  if id then
    triggers.triggerIds[id] = id
  end
  return id
end

function triggers.substringTrigger(pattern, callback)
  local id = tempTrigger(pattern, callback)
  if id then
    triggers.triggerIds[id] = id
  end
  return id
end

function triggers.killTrigger(id)
  if triggers.triggerIds[id] then
    triggers.triggerId[id] = nil
  end
  killTrigger(id)
end

registerNamedEventHandler(util.handlerTuple('erion.triggers', 'erion.system.final', function ()
  for _, id in pairs(triggers.triggerIds) do
    killTrigger(id)
  end

  triggers.triggerIds = {}
end))
