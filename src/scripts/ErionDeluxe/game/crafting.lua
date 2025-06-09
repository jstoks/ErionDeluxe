erion = erion or {}
erion.game = erion.game or {}
erion.game.crafting = erion.game.crafting or {
  namespace = 'game.crafting'
}

local crafting = erion.game.crafting

local util = require "@PKGNAME@.util"

function crafting.onBoot()
  erion.module.extend(crafting)

  crafting:defineEvent("crush", "Crush", "Crush the contents of a mortar with a pestle."):beginTrigger("You crush up")
  crafting:defineEvent("engrave", "Engrave", "Engrave your name into a crafted item."):regexTrigger("^You engrave.*with your name\\.$")
  crafting:defineEvent("imbue", "Imbue", "The craft imbue command."):regexTrigger("^You imbue.*with.*\\.$")
  crafting:defineEvent("polishgem", "PolishGem", "Polish a gem to a shine."):regexTrigger("^You polish.*to a shine\\.$")
  crafting:defineEvent("polishgemfail", "PolishGemFail", "Fail to polish a gem."):regexTrigger("^You attempt to polish.*and scratch the surface instead*\\.$")
  crafting:defineEvent("strikematch", "StrikeMatch", "Strike a match to light something."):beginTrigger("You strike a match and ")
  crafting:defineEvent("woven", "CraftWoven", "Finish weaving strands of magic together."):regexTrigger("^You finish weaving the strands together, creating.*\\.$")
end

registerNamedEventHandler(util.handlerTuple('game.crafting','erion.system.boot', crafting.onBoot))
