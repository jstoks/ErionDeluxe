erion = erion or {}

erion.sounds = {
  dir = getMudletHomeDir() .. '/ErionDeluxe/sounds/',
  ext = '.aac',
  bootHandler = nil,
}

function erion.sounds.boot()
  if erion.events.game then
    erion.sounds:bootGame(erion.events.game)
  end
end

function erion.sounds:bootGame(game)
  self:bootCrafting(game.crafting)
end

function erion.sounds:bootCrafting(crafting)
  self:bootAnimals(crafting.animals)
  self:bootCleaning(crafting.cleaning)
  self:bootCreation(crafting.creation)
  self:bootMining(crafting.mining)
  self:bootForaging(crafting.foraging)
  self:bootGardening(crafting.gardening)
  self:bootLeatherWorking(crafting.leatherworking)
  self:bootSmelting(crafting.smelting)
  self:bootWookworking(crafting.woodworking)
  self:bootWool(crafting.wool)

  self:registerEffect(crafting.crush, 'crafting/crush')
  self:registerEffect(crafting.engrave, 'crafting/engrave')
  self:registerEffect(crafting.imbue, self:soundRandomizer('crafting/imbue', 1, 3)
  self:registerEffect(crafting.polishgem, 'crafting/polish_gem')
  self:registerEffect(crafting.polishgemfail, 'crafting/polish_gem_fail')
  self:registerEffect(crafting.strikematch, 'crafting/strike_match')
  self:registerEffect(crafting.woven, 'crafting/woven')
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

function erion.sounds:bootCleaning(cleaning)
  self:registerEffect(cleaning.cleancloth, 'crafting/cleaning/cleancloth')
  self:registerEffect(cleaning.cleanfloor, 'crafting/cleaning/cleanfloor')
end

function erion.sounds:bootCooking(cooking)
  self:registerEffect(cooking.cookburnt, 'crafting/cooking/burnt')
  self:registerEffect(cooking.cooksizzle, 'crafting/cooking/sizzle')
end

function erion.sounds:bootCreation(creation)
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

function erion.sounds:bootForaging(foraging)
  self:registerEffect(foraging.berrybush, 'crafting/forage/berry_bush')
  self:registerEffect(foraging.collectrare, 'crafting/forage/collect_rare')
  self:registerEffect(foraging.collectwet, 'crafting/forage/collect_wet')
  self:registerEffext(foraging.combgrass, 'crafting/forage/comb_grass')
  self:registerEffext(foraging.combsilt, 'crafting/forage/comb_silt')
  self:registerEffext(foraging.digsoil, 'crafting/forage/dig_soil')
  self:registerEffext(foraging.feather, 'crafting/forage/feather')
  self:registerEffext(foraging.foundnothing, 'crafting/forage/foundnothing')
  self:registerEffext(foraging.spotgem, 'crafting/forage/gem')
  self:registerEffext(foraging.leafsnarl, 'crafting/forage/leaves_growl')
  self:registerEffext(foraging.liftbranch, 'crafting/forage/lift_branch')
  self:registerEffext(foraging.rockgrowl, 'crafting/forage/monster_growl')
  self:registerEffext(foraging.siftmuck, 'crafting/forage/mud_bubble')
  self:registerEffect(foraging.mudgrime, 'crafting/forage/mud_walking')
  self:registerEffect(foraging.peekknothole, 'crafting/forage/peek_knothole')
  self:registerEffect(foraging.peekrock, 'crafting/forage/peek_rock')
  self:registerEffect(foraging.pickbush, 'crafting/forage/pick_bush')
  self:registerEffect(foraging.pickedover, 'crafting/forage/picked_over')
  self:registerEffect(foraging.pickedover, 'crafting/forage/pluck_branch')
  self:registerEffect(foraging.rinsewater, 'crafting/forage/rinse_water')
  self:registerEffect(foraging.rockturnover, 'crafting/forage/rock_turnover')
  self:registerEffect(foraging.rolllog, 'crafting/forage/roll_log')
  self:registerEffect(foraging.rottenlog, 'crafting/forage/rotten_log')
  self:registerEffect(foraging.spotrune, 'crafting/forage/rune')
  self:registerEffect(foraging.scoopsand, 'crafting/forage/sand')
  self:registerEffect(foraging.scoopfloat, 'crafting/forage/scoop_float')
  self:registerEffect(foraging.scoopmuck, 'crafting/forage/scoop_muck')
  self:registerEffect(foraging.scraperesin, 'crafting/forage/scoop_muck')
  self:registerEffext(foraging.scuttle, 'crafting/forage/scuttle')
  self:registerEffext(foraging.forageseed, 'crafting/forage/seed')
  self:registerEffext(foraging.seed, 'crafting/forage/seed')
  self:registerEffect(foraging.muck, 'crafting/forage/sift_muck')
  self:registerEffect(foraging.toewetleaves, 'crafting/forage/toe_dead_leaves')
  self:registerEffect(foraging.treebranch, 'crafting/forage/tree_branch')
  self:registerEffect(foraging.dip, 'crafting/forage/water_dip')
  self:registerEffect(foraging.dipfish, 'crafting/forage/water_sifting')
  self:registerEffect(foraging.wateryank, 'crafting/forage/water_yank')
  self:registerEffect(foraging.willow, 'crafting/forage/willow')
  self:registerEffect(foraging.wipegunk, 'crafting/forage/wipe_gunk')
  self:registerEffect(foraging.sift, 'crafting/forage/water_sifting')
end

function erion.sounds:bootGardening(gardening)
  self:registerEffect(gardening.gardendestroy, 'crafting/gardening/destroy_garden')
  self:registerEffect(gardening.fertilize, 'crafting/gardening/fertilize')
  self:registerEffect(gardening.harvest, 'crafting/gardening/harvest')
  self:registerEffect(gardening.plantseed, 'crafting/gardening/plant')
  self:registerEffect(gardening.waterseed, 'crafting/gardening/water')
end

function erion.sounds:bootLeatherWorking(leatherworking)
  self:registerEffect(leatherworking.tannincomplete, 'crafting/leatherwork/tannin_complete')
end

function erion.sounds:bootSmelting(smelting)
  self:registerEffect(smlting.beginsmelting, 'crafting/smelting/begin_smelting')
  self:registerEffect(smlting.smeltcool, 'crafting/smelting/cooled_down')
  self:registerEffect(smlting.dross, 'crafting/smelting/dross')
  self:registerEffect(smlting.skimdross, 'crafting/smelting/skim_dross')
  self:registerEffect(smlting.flameschange, 'crafting/smelting/flameschange')
  self:registerEffect(smlting.skimfail, 'crafting/smelting/skim_fail')
  self:registerEffect(smlting.stoke, 'crafting/smelting/stoke')
end

function erion.sounds:bootWookworking(woodworking)
  self:registerEffect(woodworking.chop, self:soundRandomizer('crafting/woodwork/chop', 1, 3))
  self:registerEffect(woodworking.hammermetal, 'crafting/woodwork/hammer_metal')
  self:registerEffect(woodworking.hammerwood, 'crafting/woodwork/hammer_wood')
  self:registerEffect(woodworking.splitlog, 'crafting/woodwork/split_log')
  self:registerEffect(woodworking.treewedge, 'crafting/woodwork/tree_wedge')
  self:registerEffect(woodworking.treefall, 'crafting/woodwork/treefall1')
  self:registerEffect(woodworking.treepush, 'crafting/woodwork/treefall2')
end


function erion.sounds:registerEffect(event, soundFile, settings)
  if not event then
    debugc("Event missing for sound:" .. soundFile)
    return
  end

  settings = settings or {}
  local soundSettings = {}
  for key, value in pairs(settings) do
    soundSettings[key] = vaue
  end
  if type(soundFile) == 'function' then
    event:register('sounds', function ()
      soundSettings.name = soundFile()
      debugc("Playing Sound: " .. soundSettings.name)
      playSoundFile(soundSettings)
    end)
  else
    soundSettings.name = self.dir .. soundFile:gsub("^/","") .. self.ext
    event:register('sounds', function ()
      debugc("Playing Sound: " .. soundSettings.name)
      playSoundFile(soundSettings)
    end)
  end

end

function erion.sounds:soundRandomizer(soundPath, min, max)
  return function ()
    return self.dir .. soundPath .. math.random(min, max) .. self.ext
  end
end

registerAnonymousEventHandler('erion.client.boot', erion.sounds.boot, true)
