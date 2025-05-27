erion = erion or {}
erion.state = erion.state or {}

local Dataset = {}
Dataset.__index = Dataset

function Dataset:new(key, defaults)
  assert(type(defaults) == 'table', 'Default data must be a table')

  local dataset = table.deepcopy(defaults)
  local metadata = { key = key }

  metadata.__index = metadata
  setmetatable(metadata, self)
  setmetatable(dataset, metadata)

  erion.state[key] = dataset

  return dataset
end

function Dataset:change(dataKey, target, newData)
  assert(type(target) == 'table' and type(newData) == 'table', 'Data must be a table')

  local changes = {}

  for key, value in pairs(target) do
    local newValue = data[key]

    -- Not all values are requird for update
    if newValue then 
      local valueType = type(value)
      local newValueType = type(newValue)
      local changeKey = dataKey .. '.' .. key
      assert(valueType == newValueType, "Data must have same type: " .. changeKey)

      if valueType == 'table' then
        local tableChanges = Dataset:change(changeKey, value, newValue)
        if not table.is_empty(tableChanges) then
          changes[key] = tableChanges
        end
      elseif value ~= dataValue then
        changes[key] = newValue
        target[key] = newValue
      end
    end
  end

  return changes
end

function Dataset:update(data)
  local oldData = table.deepcopy(data)
  local changes = self:change(self.key, self, data)

  erion.events.state[self.key].raise(self, oldData, changes)
end

function erion.state.boot()
  debugc('Booting: State')

  Dataset:new('character', erion.state.character or {
    hp = { current = 0, max = 0 },
    mp = { current = 0, max = 0 },
  })

  Dataset:new('location', erion.state.location or {
    area = '',
    room = '',
    sector = '',
    vnum = '',
    exits = {
      north = '_',
      east = '_',
      south = '_',
      west = '_',
      up = '_',
      down = '_',
    },
  })

  local eventTable = {}
  for key, dataSet in pairs(erion.state) do
    eventTable[key] = { name = key, description = "State update for " .. key .. " data."}
  end

  erion.EventSystem:defineEventTable('state', eventTable)
end

registerNamedEventHandler("@PKGNAME@", 'state.handler-erion.client.boot', 'erion.client.boot', erion.state.boot, true)
