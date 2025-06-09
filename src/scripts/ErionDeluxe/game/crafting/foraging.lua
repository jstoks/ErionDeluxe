erion = erion or {}
erion.game = erion.game or {}
erion.game.crafting = erion.game.crafting or {}
erion.game.crafting.foraging = {
  namespace = 'game.crafting.foraging',
}

local foraging = erion.game.crafting.foraging

local util = require "@PKGNAME@.util"

function foraging.onBoot()
  erion.module.extend(foraging)

  foraging:defineEvent("forage", "Forage", "Foraging for something."):msdpHandler('FORAGE')
  foraging:defineEvent("berrybush", "ForageBerryBush", "Examining a berry bush while foraging."):exactTrigger({
    "You examine a berry growing from a bush.",
    "You examine some colorful berries on a branch.",
  })
  foraging:defineEvent("collectrare", "ForageCollectRare", "Collecting a rare item while foraging."):msdpHandler('COLLECT_RARE')
  foraging:defineEvent("collectwet", "ForageCollectWet", "Collecting something from the wetlands while foraging."):msdpHandler('COLLECT_WET')
  foraging:defineEvent("combgrass", "ForageCombGrass", "Comb through grass while foraging."):exactTrigger({
    "You part some tall grass and comb the area.",
    "You comb through some low grass."
    })
  foraging:defineEvent("combsilt", "ForageCombSilt", "Combing through silt while foraging."):exactTrigger("You comb through the silt, seeking hidden treasures.")
  foraging:defineEvent("digsoil", "ForageDigSoil", "Digging into the soil to unearth something while foraging."):regexTrigger({
    "^You dig into the soil and unearth.*\\.$",
    "^You dig into the soil and extract.*\\.$",
    })
  foraging:defineEvent("feather", "Feather", "Feather of liberation from foraging."):msdpHandler('FEATHER')
  foraging:defineEvent("foundnothing", "ForageFoundNothing", "Found nothing useful while foraging."):exactTrigger("You didn't find anything useful.")
  foraging:defineEvent("spotgem", "ForageGem", "Find a gem while foraging."):regexTrigger({
    "^You discover.*among a patch of stones!$",
    "^You find.*gleaming at the bottom of a puddle!$",
    "^You spot.*tucked inside the knothole of a tree!$",
    })
  foraging:defineEvent("leafsnarl", "ForageLeafSnarl", "Clear away leaves while foraging and monster jumps out and snarls."):regexTrigger("^You clear away a pile of leaves and.*leaps forth with a snarl!$")
  foraging:defineEvent("liftbranch", "ForageLiftBranch", "Lifting a branch while foraging."):exactTrigger("You lift a low branch of a tree and examine the ground.")
  foraging:defineEvent("rockgrowl", "ForageRockGrowl", "Turn over a rock while foraging and monster jumps out and growls."):regexTrigger("^You push a rock to turn it over and.*wakes with a rumbling growl!$")
  foraging:defineEvent("siftmuck", "ForageSiftMuck", "Sifting through muck while foraging."):exactTrigger("You sift through the muck.")
  foraging:defineEvent("mudgrime", "ForageMudGrime", "Splashing through mud and grime while foraging."):exactTrigger("You splash through mud and grime, hoping to find loot.")
  foraging:defineEvent("peekknothole", "ForagePeekKnothole", "Peek in the knothole of a tree while foraging."):exactTrigger("You peek inside the knothole of a tree.")
  foraging:defineEvent("peekrock", "ForagePeekRock", "Peek under a rock while foraging."):exactTrigger("You peek under a rock.")
  foraging:defineEvent("pickbush", "ForagePickBush", "Picking something from a bush while foraging."):regexTrigger("^You pluck.*from the ground where it clings to a bit of moss\\.$")
  foraging:defineEvent("pickedover", "ForagePickedOver", "The area is picked over while foraging."):exactTrigger("The area looks picked over.")
  foraging:defineEvent("pluckbranch", "ForagePluckBranch", "Pluck something from a branch while foraging."):regexTrigger({
    "^You pluck.*caught on a branch\\.$",
    "^You pluck.*caught on a branch\\.$",
    })
  foraging:defineEvent("rinsewater", "ForageRinseWater", "Rinsing water off something while foraging."):regexTrigger("^You rinse.*off in the water!$")
  foraging:defineEvent("rockturnover", "ForageRockTurnover", "Turning over a rock while foraging."):regexTrigger("^You turn over a rock and find.*in the dirt\\.$")
  foraging:defineEvent("rolllog", "ForageRollLog", "Rolling over a log while foraging."):exactTrigger("You roll over a log covered in moss.")
  foraging:defineEvent("rottenlog", "ForageRottenLog", "Pushing over a rotten log while foraging."):regexTrigger("^You nudge a rotten log aside with your toe and discover .*!$")
  foraging:defineEvent("spotrune", "ForageRune", "Find a rune while foraging."):regexTrigger({
    "^You spot.*pulsing in a hollow tree stump!$",
    "^You spot.*glowing at the base of a tree!$",
    "^You clear away some leaves and discover.*underneath a gnarled tree root!$",
    })
  foraging:defineEvent("scoopsand", "ForageSand", "Scoop up sand while foraging."):msdpHandler('FORAGE_SAND')
  foraging:defineEvent("scoopfloat", "ForageScoopFloat", "Scooping up an item before it floats away while foraging."):regexTrigger("^You scoop up.*before it floats on by!$")
  foraging:defineEvent("scoopmuck", "ForageScoopMuck", "Scooping muck while foraging."):exactTrigger("You scoop your hand into the muck and pull out.*!")
  foraging:defineEvent("scraperesin", "ForageScrapeResin", "Scrape resin off a tree while foraging."):exactTrigger("You scrape resin off of a tree!")
  foraging:defineEvent("scuttle", "ForageScuttle", "Push over a log while foraging and monster scuttles out."):regexTrigger("^You push over a log and.*scuttles out!$")
  foraging:defineEvent("forageseed", "ForageSeed", "Unearth a seed while foraging."):regexTrigger("^You scoop away a handful of dirt and unearth.*!$")
  foraging:defineEvent("muck", "ForageMuck", "Muck sound while foraging."):exactTrigger("Something brushes your hand and you yank it out, clutching a handful of muck.")
  foraging:defineEvent("toewetleaves", "ForageToeWetLeaves", "Toe at a pile of wet leaves while foraging."):exactTrigger("You toe at a pile of wet leaves.")
  foraging:defineEvent("treebranch", "ForageTreeBranch", "Loosen something from a tree branch while foraging."):regexTrigger("^You carefully loosen.*from a tree branch\\.$")
  foraging:defineEvent("dip", "ForageDip", "Dipping hands into water while foraging."):exactTrigger("You dip your hand into the water and hope it comes back out again.")
  foraging:defineEvent("dipfish", "ForageDipFish", "Dipping and fishing around in water while foraging."):exactTrigger("You dip your hands into the water, fishing for something near the bottom.")
  foraging:defineEvent("wateryank", "ForageWaterYank", "Yanking hand out of water while foraging."):regexTrigger("^Your hand brushes against something and you quickly yank out.*from the water!$")
  foraging:defineEvent("willow", "Willow", "Forage for willow shoots."):exactTrigger("You snap a willow shoot from the base of a willow tree.")
  foraging:defineEvent("wipegunk", "ForageWipeGunk", "Wiping gunk off your hands while foraging."):exactTrigger("You wipe gunk off your hand, inspecting it closely.")
  foraging:defineEvent("sift", "ForageSift", "Sifting through muck while foraging."):exactTrigger("You sift through a handful of muck and pebbles.")
  foraging:defineEvent("seed", "ForageSeed", "Notification when you forage a seed."):msdpHandler('SEED')
  foraging:defineEvent("unearth", "ForageUnearth", "Unearth or collect something while foraging."):msdpHandler('UNEARTH')
end

registerNamedEventHandler(util.handlerTuple('game.crafting.foraging','erion.system.boot', foraging.onBoot))

