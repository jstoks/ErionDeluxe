erion = erion or {}
erion.game = erion.game or {}
erion.game.crafting = erion.game.crafting or {}

erion.game.crafting.wool = {
  namespace = 'game.crafting.wool',
}

local wool = erion.game.crafting.wool

local util = require "@PKGNAME@.util"

function wool.onBoot()
  erion.module.extend(wool)

  wool:defineEvent("spinwheel", "Spin", "Spin yarn on a spinning wheel."):msdpHandler('SPINNING_WHEEL')
end

registerNamedEventHandler(util.handlerTuple('game.crafting.wool','erion.system.boot', wool.onBoot))

