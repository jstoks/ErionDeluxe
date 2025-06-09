erion = erion or {}
erion.game = erion.game or {}
erion.game.crafting = erion.game.crafting or {}
erion.game.crafting.leatherworking = {
  namespace = 'game.crafting.leatherworking'
}

local leatherworking = erion.game.crafting.leatherworking

local util = require "@PKGNAME@.util"

function leatherworking.onBoot()
  erion.module.extend(leatherworking)

  leatherworking:defineEvent("tannincomplete", "TanninComplete", "Sound for skin turning to leather in a vat."):msdpHandler('TANNIN_COMPLETE')
end

registerNamedEventHandler(util.handlerTuple('game.crafting.leatherworking','erion.system.boot', leatherworking.onBoot))

