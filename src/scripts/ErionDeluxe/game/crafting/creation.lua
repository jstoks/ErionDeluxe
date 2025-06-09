erion = erion or {}
erion.game = erion.game or {}
erion.game.crafting = erion.game.crafting or {}
erion.game.crafting.creation = {
  namespace = 'game.crafting.creation',
}

local creation = erion.game.crafting.creation

local util = require "@PKGNAME@.util"

function creation.onBoot()
  erion.module.extend(creation)

  creation:defineEvent("applyresin", "ApplyResin", "Applying resin to a surface."):msdpHandler('APPLY_RESIN')
  creation:defineEvent("arrangerocks", "ArrangeRocks", "Arrange rocks while crafting."):msdpHandler('ARRANGE_ROCKS')
  creation:defineEvent("arrange", "CraftArrange", "Prepare to heat something."):regexTrigger('^You arrange the wood and coal and prepare to heat.*\\.$')
  creation:defineEvent("attach", "Attach", "Attaching something to an item."):msdpHandler('ATTACH')
  creation:defineEvent("blowglass", "CraftBlowGlass", "Blow glass into shape."):regexTrigger('^You begin blowing the glass into shape\\.$')
  creation:defineEvent("carve", "CraftCarve", "Carve something."):regexTrigger({
    '^You start shredding.*into chips of wood\\.$',
    '^You begin carving.*\\.$',
  })
  creation:defineEvent("crackstone", "CrackStone", "Cracking a stone in half."):msdpHandler('CRACK_STONE')
  creation:defineEvent("craftcomplete", "CraftComplete", "Finish crafting an item."):beginTrigger('You have crafted')
  creation:defineEvent("cutleather", "CraftCutLeather", "Cutting leather into shape."):beginTrigger('You begin cutting the leather')
  creation:defineEvent("cutpaper", "CutPaper", "Cutting paper."):msdpHandler('CUT_PAPER')
  creation:defineEvent("cutwillow", "CraftCutWillow", "Cutting the willow into shape."):beginTrigger('You begin cutting the willow')
  creation:defineEvent("craftdip", "CraftDip", "Dip matchstick into liquid sulfur."):beginTrigger('You dip the wood into a pool of liquid sulfur and wait for it to dry.')
  creation:defineEvent("craftdrawcompass", "CraftDrawCompass", "Draw a compass on a map."):msdpHandler('DRAW_COMPASS')
  creation:defineEvent("craftdrypaper", "CraftDryPaper", "Drying paper."):msdpHandler('DRY_PAPER')
  creation:defineEvent("file", "File", "Filing down a material."):msdpHandler('FILE')
  creation:defineEvent("foldingpaper", "FoldingPaper", "Folding paper."):msdpHandler('FOLDING_PAPER')
  creation:defineEvent("grindstone", "GrindStone", "Grinding stones."):msdpHandler('GRIND_STONE')
  creation:defineEvent("griptool", "CraftGrip", "Grip tool while crafting"):regexTrigger('"^You grip.*and prepare.*\\.$"')
  -- TODO: Hammer Willow sound in soundpack but it's not connected to anything.
  creation:defineEvent("knit", "Knit", "Knitting."):msdpHandler('KNIT')
  creation:defineEvent("craftlabelmap", "CraftLabelMap", "Label a map"):msdpHandler('LABEL_MAP')
  creation:defineEvent("craftmarkmap", "CraftMarkMap", "Mark a room on a map."):msdpHandler('MARK_MAP')
  creation:defineEvent("leathercreak", "LeatherCreak", "Leather creaking."):msdpHandler('LEATHER_CREAKING')
  creation:defineEvent("craftmash", "CraftMash", "Mash wood chips."):msdpHandler('MASH')
  creation:defineEvent("paint", "Paint", "Painting."):msdpHandler('PAINT')
  creation:defineEvent("mould", "Mould", "Pouring molten material into a mould."):msdpHandler('POUR_MOULD')
  creation:defineEvent("poursand", "PourSand", "Pouring sand."):msdpHandler('POUR_SAND')
  creation:defineEvent("sew", "Sew", "Sewing fabrics."):msdpHandler('SEW')
  creation:defineEvent("stainglass", "StainGlass", "Staining glass."):msdpHandler('STAIN_GLASS')
  creation:defineEvent("tattoo", "Tattoo", "Tattoo design."):msdpHandler('TATTOO')
  creation:defineEvent("tuckwool", "CcraftTuckWool", "Begin tucking wool into something."):msdpHandler('TUCK_WOOL')
  creation:defineEvent("twist", "CraftTwist", "Begin twisting the willow shoots."):exactTrigger('You twist the fibers of the willow shoot until flexible as a rope and begin winding them into a handle.')
  creation:defineEvent("twistfail", "CraftTwistFail", "Twist the willow shoot too forcefully and it breaks."):exactTrigger('You twist too forcefully and the willow shoot snaps and breaks!')
  creation:defineEvent("craftunpick", "CraftUnpick", "Unpick cotton from a prayer rug."):msdpHandler('UNPICK')
end

registerNamedEventHandler(util.handlerTuple('game.crafting.creation','erion.system.boot', creation.onBoot))

