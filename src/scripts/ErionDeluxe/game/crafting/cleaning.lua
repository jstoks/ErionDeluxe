erion = erion or {}
erion.game = erion.game or {}
erion.game.crafting = erion.game.crafting or {}

erion.game.crafting.cleaning = {
  namespace = 'game.crafting.cleaning',
}

local cleaning = erion.game.crafting.cleaning

local util = require "@PKGNAME@.util"

function cleaning.onBoot()
  erion.module.extend(cleaning)

  cleaning:defineEvent("cleancloth", "CleanCloth", "Cleaning clothes."):msdpHandler('CLEAN_CLOTH')
  cleaning:defineEvent("cleanfloor", "CleanFloor", "Cleaning floors."):msdpHandler('CLEAN_FLOOR')
end

registerNamedEventHandler(util.handlerTuple('game.crafting.cleaning','erion.system.boot', cleaning.onBoot))

