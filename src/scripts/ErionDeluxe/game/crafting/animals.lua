erion = erion or {}
erion.game = erion.game or {}
erion.game.crafting = erion.game.crafting or {}

erion.game.crafting.animals = {
  namespace = 'game.crafting.animals',
}
local animals = erion.game.crafting.animals

local util = require "@PKGNAME@.util"

function animals.onBoot()
  erion.module.extend(animals)

  animals:defineEvent("chickenegg", "ChickenEgg", "Collecting a chicken egg."):msdpHandler('CHICKEN_EGG')
  animals:defineEvent("chickeneat", "ChickenEat", "Chicken eating"):msdpHandler('CHICKEN_EAT')
  animals:defineEvent("cowmilk", "CowMilk", "Milking cow."):msdpHandler('COW_MILK')
  animals:defineEvent("cowpoop", "CowPoop", "Cow Pooping."):msdpHandler('COW_POOP')
  animals:defineEvent("coweat", "CowEat", "Cow eating."):msdpHandler('COW_EAT')
  animals:defineEvent("sheepeat", "SheepEat", "Sheep grazing."):msdpHandler('SHEEP_EAT')
  animals:defineEvent("shearsheep", "ShearSheep", "Shearing sheep."):msdpHandler('SHEAR_SHEEP')
end

registerNamedEventHandler(util.handlerTuple('game.crafting.animals','erion.system.boot', animals.onBoot))

