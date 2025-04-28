erion = erion or {}

erion.sounds = {
  dir = getMudletHomeDir() .. '/ErionSoundpack/sounds/',
  ext = '.aac',
  bootHandler = nil,
}

function erion.sounds.boot()
  erion.sounds.dispatcher = erion.system:dispatcher('@PKGNAME@', 'sounds')

  erion.sounds:bootGame(erion.events.game)
end

function erion.sounds:bootGame(game)
  self:bootCrafting(game.crafting)
end

function erion.sounds:bootCrafting(crafting)
  self:bootAnimals(crafting.animals)
  self:bootCleaning(crafting.cleaning)
  self:bootCreation(crafting.creation)
  self:bootMining(crafting.mining)
end

function erion.sounds:bootAnimals(animals)
  self:registerEffect(animals.chickenegg, 'crafting/animals/chicken1')
  self:registerEffect(animals.chickeneat, 'crafting/animals/chicken2')
  self:registerEffect(animals.cowmilk, self:soundRandomizer('crafting/animals/milk', 1, 2))
  self:registerEffect(animals.cowpoop, 'crafting/animals/cowpoop1')
  self:registerEffect(animals.coweat, 'crafting/animals/cow1')
  self:registerEffect(animals.sheepeat, 'crafting/animals/sheep1')
  self:registerEffect(animals.shearsheep, self:soundRandomizer('crafting/animals/shear', 1, 3))
end

function erion.sounds.bootCleaning(cleaning)
  self:registerEffect(cleaning.cleancloth, 'crafting/cleaning/cleancloth')
  self:registerEffect(cleaning.cleanfloor, 'crafting/cleaning/cleanfloor')
end

function erion.sounds.bootCooking(cooking)
  self:registerEffect(cooking.cookburnt, 'crafting/cooking/burnt')
  self:registerEffect(cooking.cooksizzle, 'crafting/cooking/sizzle')
end

function erion.sounds.bootCreation(creation)
  self:registerEffect(creation.applyresin, 'crafting/creation/apply_resin')
  self:registerEffect(creation.arrangerocks, 'crafting/creation/arrange_rocks')
  self:registerEffect(creation.arrange, 'crafting/creation/arrange')
  self:registerEffect(creation.attach, 'crafting/creation/attach')
  self:registerEffect(creation.blowglass, 'crafting/creation/blow_glass')
  self:registerEffect(creation.carve, 'crafting/creation/carve')
  self:registerEffect(creation.crackstone, 'crafting/creation/crack_stone')
  self:registerEffect(creation.craftcomplete, 'crafting/creation/craft_complete')
  self:registerEffect(creation.cutleather, 'crafting/creation/cut_leather')
  self:registerEffect(creation.cutpaper, 'crafting/creation/cut_paper')
  self:registerEffect(creation.cutwillow, 'crafting/creation/cut_willow')
  self:registerEffect(creation.craftdip, 'crafting/creation/dip_match')
  self:registerEffect(creation.craftdrawcompas, 'crafting/creation/draw_compass')
  self:registerEffect(creation.craftdrypaper, 'crafting/creation/dry_paper')
  self:registerEffect(creation.file, 'crafting/creation/file')
  self:registerEffect(creation.foldingpaper, 'crafting/creation/folding_paper')
  self:registerEffect(creation.grindstone, 'crafting/creation/grind_stone')
  self:registerEffect(creation.griptool, 'crafting/creation/grip_tool')
  self:registerEffect(creation.knit, 'crafting/creation/knit')
  self:registerEffect(creation.craftmarkmap, 'crafting/creation/label_map')
  self:registerEffect(creation.craftlabelmap, 'crafting/creation/label_map')
  self:registerEffect(creation.leathercreak, 'crafting/creation/leather_creaking')
  self:registerEffect(creation.mash, 'crafting/creation/mash')
  self:registerEffect(creation.paint, 'crafting/creation/paint')
  self:registerEffect(creation.mould, 'crafting/creation/pour_mould')
  self:registerEffect(creation.poursand, 'crafting/creation/pour_sand')
  self:registerEffect(creation.sew, 'crafting/creation/sew')
  self:registerEffect(creation.stainglass, 'crafting/creation/stain_glass')
  self:registerEffect(creation.tattoo, 'crafting/creation/tattoo')
  self:registerEffect(creation.tuckwool, 'crafting/creation/tuck_wool')
  self:registerEffect(creation.twist, 'crafting/creation/twist_begin')
  self:registerEffect(creation.twistfail, 'crafting/creation/twist_fail')
  self:registerEffect(creation.craftunpick, 'crafting/creation/unpick')
end

function erion.sounds:bootMining(mining)
  self:registerEffect(mining.debris, 'crafting/mining/debris')
  self:registerEffect(mining.cleardebris, 'crafting/mining/clear_debris')
  self:registerEffect(mining.mine, 'crafting/mining/mine')
  self:registerEffect(mining.pickaxe, self:soundRandomizer('crafting/mining/swing/', 1, 6))
  self:registerEffect(mining.pickaxebreak, 'crafting/mining/pixkaxe_break')
  self:registerEffect(mining.ore, 'crafting/mining/ore')
  self:registerEffect(mining.coal, 'crafting/mining/coal')
  self:registerEffect(mining.salt, 'crafting/mining/salt')
  self:registerEffect(mining.mininggem, 'crafting/mining/gem')
end



function erion.sounds:registerEffect(event, soundFile, settings)
  if not event or not event.evKey then
    debugc("Event missing for sound:" .. soundFile)
  end
  settings = settings or {}
  local soundSettings = {}
  for key, value in pairs(settings) do
    soundSettings[key] = vaue
  end
  self.dispatcher:registerHandler(event.evKey, function ()
    if type(soundFile) == 'function' then
      soundSettings.name = soundFile()
    else
      soundSettings.name = self.dir .. soundFile:gsub("^/","") .. self.ext
    end
    debugc("Playing Sound: " .. soundSettings.name)
    playSoundFile(soundSettings)
  end)
end

function erion.sounds:soundRandomizer(soundPath, min, max)
  return function ()
    return self.dir .. soundPath .. math.random(min, max) .. self.ext
  end
end

if erion.sounds.bootHandlerId then
  killAnonymousEventHandler(erion.sounds.bootHandlerId)
end

erion.sounds.bootHandlerId = registerAnonymousEventHandler('erion.client.boot', erion.sounds.boot, true)
