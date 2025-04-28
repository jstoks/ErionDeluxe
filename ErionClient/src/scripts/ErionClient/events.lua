--- Defines events for erion.
--- Includes events triggered by the game and events triggered by the client itself
--- @section Raise Event
---
--- @usage erion.events.client.boot.raise()
---
--- @exports erion.Event, erion.events
---
--- The big table at the bottom of the file is the place to add new events.
erion = erion or {}
erion.events = erion.events or {}

-- Defines an Event "class" that can raise itself.
erion.Event = erion.Event or {
  triggerIds = {},
  msdpNames = {},
}

erion.Event.__index = erion.Event

function erion.Event.clearAll()
  -- Clear triggers
  for key, triggerIds in pairs(erion.Event.triggerIds) do
    if triggerIds then
      for _, id in ipairs(idList) do
        if id then
          killTrigger(id)
        end
      end
    end
  end

  erion.Event.triggerIds = {}

  -- Clear Events
  for names in ipairs(erion.Event.msdpNames) do
    deleteNamedEventHandler(unpack(names))
  end
  erion.Event.msdpNames = {}
end

function erion.Event:new(prefix, keyword, eventDef)
  obj = {
    name = eventDef.name,
    description = eventDef.description,
    keyword = keyword,
    evKey = prefix .. '.' .. keyword,
  }

  setmetatable(obj, self)

  return obj
end

function erion.Event:raise(...)
  raiseEvent(self.evKey, ...)
end

function erion.Event.addTriggerId(key, id)
  if not erion.Event.triggerIds[key] then
    erion.Event.triggerIds[key] = {}
  end
  table.insert(erion.Event.triggerIds[key], id)
end

function erion.Event.addMSDPHandler(userName, eventName)
  table.insert(erion.Event.msdpNames, {userName, eventName})
end

function erion.Event.defineEventTable(namespace, eventTable)
  erion.events[namespace] = erion.Event.buildEventTable('erion.' .. namespace, eventTable)
end

-- Walk the table of events and initialize actual event objects
function erion.Event.buildEventTable(prefix, eventTable)
  local events = {}
  for key, value in pairs(eventTable) do 
    if value.name and value.description then
      events[key] = erion.Event:new(prefix, key, value)
      if value.eventConnection then
        value.eventConnection(events[key])
      end
    else
      events[key] = erion.Event.buildEventTable(prefix .. '.' .. key, value)
    end
  end
  return events
end

-- Helper function to slightly shorten event table definition
local function ev(name, description, eventConnection)
  return {
    name = name,
    description = description,
    eventConnection = eventConnection,
  }
end

local function someTrigger(patterns, callback, makeTrigger)
  return function(event)
    callback = callback or function () event:raise() end
    if type(patterns) == 'string' then
      erion.Event.addTriggerId(event.keyword, makeTrigger(patterns, callback))
    else
      for _, pattern in ipairs(patterns) do
        erion.Event.addTriggerId(event.keyword, makeTrigger(pattern, callback))
      end
    end
  end
end

local function regexTrigger(patterns, callback)
  return someTrigger(patterns, callback, tempRegexTrigger)
end

local function beginTrigger(patterns, callback)
  return someTrigger(patterns, callback, tempBeginOfLineStringTrigger)
end

local function subTrigger(patterns, callback)
  return someTrigger(patterns, callback, tempTrigger)
end

local function exactTrigger(patterns, callback)
  return someTrigger(patterns, callback, tempExactMatchTrigger)
end

local function msdpHandler(varName, callback)
  return function(event)
    callback = callback or function () event:raise() end

    local msdpEvent = "msdp." .. varName
    local reportName = event.keyword .. '.report'
    local handlerName = event.keyword .. '.msdp'

    -- If we're connected we can ask for the variable to be reported
    local host, port, connected = getConnectionInfo()
    if connected then
      sendMSDP("REPORT",varName)
    else
      -- Otherwise we can ask after we've connected
      registerNamedEventHandler('erion', reportName, 'sysConnectionEvent', function () sendMSDP("REPORT", varName) end)
      erion.Event.addMSDPHandler('erion', reportName)
    end
    registerNamedEventHandler('erion', handlerName, msdpEvent, callback)
    erion.Event.addMSDPHandler('erion', handlerName)
  end
end

-- Attempt to clear any orphaned handlers
erion.Event.clearAll()

-- Client events that are initiated within the client
-- These are not raised directly from input from the game itself.
erion.Event.defineEventTable('client', {
  boot = ev('Boot', 'Boots the client. Useful for running code after all scripts have executed.'),
  init = ev('Initialize', 'Initialize the client. Primarily used for loading data.'), 
  shutdown = ev('Shutdown', 'Shutdown the system. Save client state and clean up.')
})

-- Defines events for the game.
-- Combines events from triggers and MSDP into one unified table.
-- Event key match directly with the names from the soundpack. They are unique.
-- The nested structure here is purely for organization. Not to prevent name collisions.
-- Add more events here when they're added to the game.
-- These are raised from data from the server only.
erion.Event.defineEventTable('game', {
  crafting = {
    animals = {
      chickenegg = ev('ChickenEgg', 'Collecting a chicken egg.', msdpHandler('CHICKEN_EGG')),
      chickeneat = ev('ChickenEat', 'Chicken eating', msdpHandler('CHICKEN_EAT')),
      cowmilk = ev('CowMilk', 'Milking cow.', msdpHandler('COW_MILK')),
      cowpoop = ev('CowPoop', 'Cow Pooping.', msdpHandler('COW_POOP')),
      coweat = ev('CowEat', 'Cow eating.', msdpHandler('COW_EAT')),
      sheepeat = ev('SheepEat', 'Sheep grazing.', msdpHandler('SHEEP_EAT')),
      shearsheep = ev('ShearSheep', 'Shearing sheep.', msdpHandler('SHEAR_SHEEP')),
    },
    cleaning = {
      cleancloth = ev('CleanCloth', 'Cleaning clothes.', msdpHandler('CLEAN_CLOTH')),
      cleanfloor = ev('CleanFloor', 'Cleaning floors.', msdpHandler('CLEAN_FLOOR')),
    },
    cooking = {
      cookburnt = ev('CookBurnt', 'Food goes up in flames while cooking.', regexTrigger('.*goes up in flames and burns to ashes!$')),
      cooksizzle = ev('CookSizzle', 'Food sizzles while cooking.', regexTrigger({
        '.*sizzles deliciously over the fire\\.$',
        '^The fire hisses as fat drips from.*\\.$',
        '^You pierce.*with a spit and it begins to sizzle over the fire\\.$',
      })),
      cookding = ev('CookDing', 'Food is done cooking.', regexTrigger('^You slide.*off the spit. Mmm, perfect!$')),
    },
    creation = {
      applyresin = ev('ApplyResin', 'Applying resin to a surface.', msdpHandler('APPLY_RESIN')),
      arrangerocks = ev('ArrangeRocks', 'Arrange rocks while crafting.', msdpHandler('ARRANGE_ROCKS')),
      arrange = ev('CraftArrange', 'Prepare to heat something.', regexTrigger('^You arrange the wood and coal and prepare to heat.*\\.$')),
      attach = ev('Attach', 'Attaching something to an item.', msdpHandler('ATTACH')),
      blowglass = ev('CraftBlowGlass', 'Blow glass into shape.', regexTrigger('^You begin blowing the glass into shape\\.$')),
      carve = ev('CraftCarve', 'Carve something.', regexTrigger({
        '^You start shredding.*into chips of wood\\.$',
        '^You begin carving.*\\.$',
      })),
      crackstone = ev('CrackStone', 'Cracking a stone in half.', msdpHandler('CRACK_STONE')),
      craftcomplete = ev('CraftComplete', 'Finish crafting an item.', beginTrigger('You have crafted')),
      cutleather = ev('CraftCutLeather', 'Cutting leather into shape.', beginTrigger('You begin cutting the leather')),
      cutpaper = ev('CutPaper', 'Cutting paper.', msdpHandler('CUT_PAPER')),
      cutwillow = ev('CraftCutWillow', 'Cutting the willow into shape.', beginTrigger('You begin cutting the willow')),
      craftdip = ev('CraftDip', 'Dip matchstick into liquid sulfur.', beginTrigger('You dip the wood into a pool of liquid sulfur and wait for it to dry.')),
      craftdrawcompass = ev('CraftDrawCompass', 'Draw a compass on a map.', msdpHandler('DRAW_COMPASS')),
      craftdrypaper = ev('CraftDryPaper', 'Drying paper.', msdpHandler('DRY_PAPER')),
      file = ev('File', 'Filing down a material.', msdpHandler('FILE')),
      foldingpaper = ev('FoldingPaper', 'Folding paper.', msdpHandler('FOLDING_PAPER')),
      grindstone = ev('GrindStone', 'Grinding stones.', msdpHandler('GRIND_STONE')),
      griptool = ev('CraftGrip', 'Grip tool while crafting', regexTrigger('"^You grip.*and prepare.*\\.$"')),
      -- TODO: Hammer Willow sound in soundpack but it's not connected to anything.
      knit = ev('Knit', 'Knitting.', msdpHandler('KNIT')),
      craftlabelmap = ev('CraftLabelMap', 'Label a map', msdpHandler('LABEL_MAP')),
      craftmarkmap = ev('CraftMarkMap', 'Mark a room on a map.', msdpHandler('MARK_MAP')),
      leathercreak = ev('LeatherCreak', 'Leather creaking.', msdpHandler('LEATHER_CREAKING')),
      craftmash = ev('CraftMash', 'Mash wood chips.', msdpHandler('MASH')),
      paint = ev('Paint', 'Painting.', msdpHandler('PAINT')),
      mould = ev('Mould', 'Pouring molten material into a mould.', msdpHandler('POUR_MOULD')),
      poursand = ev('PourSand', 'Pouring sand.', msdpHandler('POUR_SAND')),
      sew = ev('Sew', 'Sewing fabrics.', msdpHandler('SEW')),
      stainglass = ev('StainGlass', 'Staining glass.', msdpHandler('STAIN_GLASS')),
      tattoo = ev('Tattoo', 'Tattoo design.', msdpHandler('TATTOO')),
      tuckwool = ev('CcraftTuckWool', 'Begin tucking wool into something.', msdpHandler('TUCK_WOOL')),
      twist = ev('CraftTwist', 'Begin twisting the willow shoots.', exactTrigger('You twist the fibers of the willow shoot until flexible as a rope and begin winding them into a handle.')),
      twistfail = ev('CraftTwistFail', 'Twist the willow shoot too forcefully and it breaks.', exactTrigger('You twist too forcefully and the willow shoot snaps and breaks!')),
      craftunpick = ev('CraftUnpick', 'Unpick cotton from a prayer rug.', msdpHandler('UNPICK')),
    },
    mining = {
      debris = ev('Debris', 'Debris tumble over the minig site.', exactTrigger('Dirt and rock tumble over the cluster.')),
      cleardebris = ev('ClearDebris', 'Clear aray debris while mining.', exactTrigger("You clear away dirt and rock from the cluster and start hacking away.")),
      mine = ev("Mine", "Begin mining.", regexTrigger({
          "^You swing.*?at the cluster, picking up where you left off\\.$",
          "^You swing.*and hack away at a cluster that another miner abandoned\\.$",
          "^You swing.*?and start hacking away at a cluster\\.$",
      })),
      pickaxe = ev("Pickaxe", "Swing your pickaxe at a cluster.", regexTrigger("^You swing the pickaxe at.*\\.$")),
      pickaxebreak = ev("PickaxeBreak",  "Pickaxe breaks while mining.", regexTrigger("^.*'s handle cracks in half\\.$")),
      ore = ev("Ore", "Obtain ore while mining.", regexTrigger("^You extract .*ore!$")),
      coal = ev("Coal", "Obtain cole while mining.", regexTrigger("^You extract .*coal!$")),
      salt = ev("Salt", "Obtain salt while mining.", regexTrigger("^You extract .*salt!$")),
      mininggem = ev("MiningGem", "Obtain a gem while mining.", msdpHandler('MINING_GEM')),
    }
  }
})


registerAnonymousEventHandler('erion.client.shutdown', erion.Event.clearAll, true)

