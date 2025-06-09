erion = erion or {}
erion.game = erion.game or {}
erion.game.crafting = erion.game.crafting or {}
erion.game.crafting.gardening = {
  namespace = 'game.crafting.gardening',
}

local gardening = erion.game.crafting.gardening

local util = require "@PKGNAME@.util"

function gardening.onBoot()
  erion.module.extend(gardening)

  gardening:defineEvent("gardendestroy", "GardenDestroy", "Destroy a seed or the entire garden."):regexTrigger({
    "^You dispose of.*seed.*\\.$",
    "^You unearth.*and dispose of it\\.$",
  })
  gardening:defineEvent("fertilize", "GardenFertilize", "Fertilize a seed while gardening."):regexTrigger("^You fertilize.*with a pile of dung\\.$")
  gardening:defineEvent("harvest", "Harvest", "Harvest a seed while gardening."):regexTrigger("^You pluck.*from the center of the blossom!$")
  gardening:defineEvent("plantseed", "GardenPlant", "Plant a seed while gardening."):regexTrigger("^You tuck.*into.*\\.$")
  gardening:defineEvent("waterseed", "GardenWater", "Water a seed while gardening."):msdpHandler('WATER_GARDEN')

end

registerNamedEventHandler(util.handlerTuple('game.crafting.gardening','erion.system.boot', gardening.onBoot))
