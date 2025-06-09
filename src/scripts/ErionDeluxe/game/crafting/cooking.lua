erion = erion or {}
erion.game = erion.game or {}
erion.game.crafting = erion.game.crafting or {}

erion.game.crafting.cooking = {
  namespace = 'game.crafting.cooking',
}

local cooking = erion.game.crafting.cooking

local util = require "@PKGNAME@.util"

function cooking.onBoot()
  erion.module.extend(cooking)

  cooking:defineEvent("cookburnt", "CookBurnt", "Food goes up in flames while cooking."):regexTrigger('.*goes up in flames and burns to ashes!$')
  cooking:defineEvent("cooksizzle", "CookSizzle", "Food sizzles while cooking."):regexTrigger({
    '.*sizzles deliciously over the fire\\.$',
    '^The fire hisses as fat drips from.*\\.$',
    '^You pierce.*with a spit and it begins to sizzle over the fire\\.$',
  })
  cooking:defineEvent("cookding", "CookDing", "Food is done cooking."):regexTrigger('^You slide.*off the spit. Mmm, perfect!$')
end

registerNamedEventHandler(util.handlerTuple('game.crafting.cooking','erion.system.boot', cooking.onBoot))

