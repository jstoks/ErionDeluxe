erion = erion or {}
erion.game = erion.game or {}
erion.game.crafting = erion.game.crafting or {}
erion.game.crafting.smelting = {
  namespace = 'game.crafting.smelting',
}

local smelting = erion.game.crafting.smelting

local util = require "@PKGNAME@.util"

function smelting.onBoot()
  erion.module.extend(smelting)

  smelting:defineEvent("beginsmelting", "BeginSmelting", "Sound for beginning the smelting process."):msdpHandler('BEGIN_SMELTING')
  smelting:defineEvent("smeltcool", "SmeltingCooldown", "When ores or gems have melted and are cool enough to touch."):msdpHandler('SMELT_COOLDOWN')
  smelting:defineEvent("dross", "Dross", "Dross has accumulated during the smelting process."):regexTrigger("^A thick layer of dross has accumulated on the surface of .*\\.$")
  smelting:defineEvent("skimdross", "SkimDross", "Clear away dross during the smelting process."):beginTrigger("You skim the layer of dross off a ")
  smelting:defineEvent("flameschange", "FlamesChange", "Flames weaken during the smelting process."):regexTrigger("^The flames change from.*to.*\\.$")
  smelting:defineEvent("skimfail", "SkimFail", "Skim off too much dross."):exactTrigger("You skim off too much dross and destroy the liquid ores.")
  smelting:defineEvent("stoke", "Stoke", "Stoke the flames during the smelting process."):beginTrigger("You stoke the flames and ")
end

registerNamedEventHandler(util.handlerTuple('game.crafting.smelting','erion.system.boot', smelting.onBoot))

