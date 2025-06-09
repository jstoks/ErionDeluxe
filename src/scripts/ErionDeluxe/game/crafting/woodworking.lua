erion = erion or {}
erion.game = erion.game or {}
erion.game.crafting = erion.game.crafting or {}
erion.game.crafting.woodworking = {
  namespace = 'game.crafting.woodworking',
}

local woodworking = erion.game.crafting.woodworking

local util = require "@PKGNAME@.util"

function woodworking.onBoot()
  erion.module.extend(woodworking)

  woodworking:defineEvent("chop", "Chop", "Chop down a tree."):regexTrigger({
    "^You swing.*and create the first notch in.*",
    "^You swing the axe at.*\\.$",
  })
  woodworking:defineEvent("hammermetal", "CraftHammerMetal", "Hammering metal materials."):msdpHandler('HAMMER_METAL')
  woodworking:defineEvent("hammerwood", "CraftHammerWood", "Hammering wood materials."):msdpHandler('HAMMER_WOOD')
  woodworking:defineEvent("splitlog", "SplitLog", "Split a log into blocks of wood."):regexTrigger("^You split.*into.*of wood\\.$")
  woodworking:defineEvent("treewedge", "TreeWedge", "Sound chopping a 45-degree wedge in a tree."):msdpHandler('TREE_WEDGE')
  woodworking:defineEvent("treefall", "Treefall", "Tree falls over during the felling process"):regexTrigger({
    "^.*starts to fall away from you and lands with a CRASH!$",
    "^.*starts to fall in your direction and knocks you down with bone-crushing force! OUCH!$",
  })
  woodworking:defineEvent("treepush", "Treepush", "Push over a tree during the felling process."):regexTrigger("^You push.*over and it falls to the ground with a CRASH!$")
end

registerNamedEventHandler(util.handlerTuple('game.crafting.woodworking','client.boot', woodworking.onBoot))
