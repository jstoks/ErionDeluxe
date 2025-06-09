
local util = {}

-- join strings with hyphen
function util.dot(...)
  return table.concat(arg, '.')
end

function util.undot(str)
  local result = {};
  for part in string.gmatch(str, "[^%.]+") do
    table.insert(result, part)
  end
  return result
end

function util.handlerName(namespace, eventKey, context)
  if type(context) == 'function' then
    printDebug('context func', true)
  end
  if not context then
    context = ''
  else
    context = '-for::' .. context
  end
  if type(namespace) == 'table' then
    printDebug("Namespace table", true)
  end
  if not namespace then
    printDebug("Namespace nil", true)
  end
  return namespace .. '-handler::' .. eventKey .. context
end

--- Create NamedHandler Arguments from this namespace/context structure
--- @string namespace
--- @string[opt] context
--- @string eventKey
--- @func callback
function util.handlerTuple(namespace, eventKey, context, callback)
  if not callback and type(context) == 'function' then
    callback = context
    context = nil
  end

  return "@PKGNAME", util.handlerName(namespace, eventKey, context), eventKey, callback
end

util.table = {}

--- Deeply sets a vlue with a dotted key
-- @tparam t table 
-- @string key multi-part key with dots between each part
-- @param value value to be s.t
function util.table.deep_set(t, key, value)
  local iter = t
  local keyParts = util.undot(key)
  local lastPart = table.remove(keyParts)
  for part in ipairs(keyParts) do
    if not iter[part] then
      iter[part] = {}
    end
    iter = iter[part]
  end
  iter[lastPart] = value
end

--- Deeply gets a vlue with a dotted key
-- @tparam t table 
-- @string key multi-part key with dots between each part
function util.table.deep_get(t, key, default)
  local iter = t
  local keyParts = util.undot(key)
  for part in ipairs(keyParts) do
    iter = iter[part]
    if not iter then
      return default
    end
  end
  return iter
end

return util
