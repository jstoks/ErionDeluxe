erion = erion or {}
erion.game = erion.game or {}
erion.game.crafting = erion.game.crafting or {}
erion.game.crafting.mining = {
  namespace = 'game.crafting.mining'
}

local mining = erion.game.crafting.mining

local util = require "@PKGNAME@.util"

function mining.onBoot()
  erion.module.extend(mining)

  mining:defineEvent('mine', 'Mine', 'Begin mining'):regexTrigger({
    "^You swing.*?at the cluster, picking up where you left off\\.$",
    "^You swing.*and hack away at a cluster that another miner abandoned\\.$",
    "^You swing.*?and start hacking away at a cluster\\.$",
  })

  mining:defineEvent("debris", "Debris", "Debris tumble over the minig site."):regexTrigger(
    '^Dirt and rock tumble over the cluster\\.$'
  )

  mining:defineEvent("cleardebris", "ClearDebris", "Clear aray debris while mining."):regexTrigger(
    "^You clear away dirt and rock from the cluster and start hacking away\\.$"
  )

  mining:defineEvent("pickaxe", "Pickaxe", "Swing your pickaxe at a cluster."):regexTrigger(
    "^You swing the pickaxe at.*\\.$"
  )

  mining:defineEvent("pickaxebreak", "PickaxeBreak", "Pickaxe breaks while mining."):regexTrigger(
    "^.*'s handle cracks in half\\.$"
  )
  mining:defineEvent("ore", "Ore", "Obtain ore while mining."):regexTrigger("^You extract .*ore!$")
  mining:defineEvent("coal", "Coal", "Obtain cole while mining."):regexTrigger("^You extract .*coal!$")
  mining:defineEvent("salt", "Salt", "Obtain salt while mining."):regexTrigger("^You extract .*salt!$")
  mining:defineEvent("mininggem", "MiningGem", "Obtain a gem while mining."):msdpHandler('MINING_GEM')
end

registerNamedEventHandler(util.handlerTuple('game.crafting.mining', 'erion.system.boot', mining.onBoot))

