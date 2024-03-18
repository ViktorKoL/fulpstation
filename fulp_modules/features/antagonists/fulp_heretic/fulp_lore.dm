/**
 * # The path of tomfoolery.
 *
 * Goes as follows:
 *
 * Tomfoolery
 */
#define PATH_FOOL "Tomfoolery Path"

/datum/heretic_knowledge/limited_amount/starting/base_beef
	name = "The Butchered Fool"
	desc = "Opens up the Path of Tomfoolery to you. \
		Allows you to transmute a slab of meat and a knife into the beefblade. \
		You can only create two at a time. \
		You can not break it like you would a normal sickly blade, but anyone can take a bite out of it to teleport to a random location. \
		You can also feed it to heathens to force this effect upon them."
	gain_text = "I have met a peculiar man today, a man made of beef. He claimed to work his job at fulpstation, and promised to show me around."
	next_knowledge = list(/datum/heretic_knowledge/fulp_grasp)
	required_atoms = list(
		/obj/item/knife = 1,
		/obj/item/food/meat/slab = 1,
	)
	result_atoms = list(/obj/item/melee/sickly_blade/beef)
	route = PATH_FOOL

/datum/heretic_knowledge/limited_amount/starting/base_beef/on_research(mob/user, datum/antagonist/heretic/our_heretic)
	. = ..()

	//this is how wonderland does it I think it should work here too???
	var/datum/map_template/heretic_sacrifice_room_fool/special_map = new()
	special_map.load_new_z()


/datum/heretic_knowledge/fulp_grasp
	name = "Grasp of Bwoink"
	desc = "Your Mansus Grasp will now bwoink the victim."
	gain_text = "The Moderators rule the Fulpites with their dark knowledge and mastery of the soul... \
		This is just a little piece of their unimaginable power..."
	next_knowledge = list(/datum/heretic_knowledge/spell/door_open)
	cost = 1
	route = PATH_FOOL

/datum/heretic_knowledge/fulp_grasp/on_gain(mob/user, datum/antagonist/heretic/our_heretic)
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, PROC_REF(on_mansus_grasp))

/datum/heretic_knowledge/fulp_grasp/on_lose(mob/user, datum/antagonist/heretic/our_heretic)
	UnregisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK)

/datum/heretic_knowledge/fulp_grasp/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	playsound(target, 'sound/effects/adminhelp.ogg', 100)


/datum/heretic_knowledge/spell/door_open
	name = "Doorways'"
	desc = "Grants you Awakening of the Doors, a spell that can only be cast in the vacuum of space. \
		It will render you immaterial and invisible for a random time, allowing you to bypass any obstacles."
	gain_text = "Madness of the Mentors knew no bounds. They searched for any way to escape the Basement, \
		even if that way was straight into the all-encompassing void."
	next_knowledge = list(/datum/heretic_knowledge/mark/beef_mark)
	spell_to_add = /datum/action/cooldown/spell/pointed/ascend_door
	cost = 1
	route = PATH_FOOL


/datum/heretic_knowledge/mark/beef_mark
	name = "Mark of Beef"
	desc = "Your Mansus Grasp now applies the Mark of Beef. The mark is triggered from an attack with your Beefy Blade. \
		When triggered, the victim will themselves become a beefman. \
		If already a beefman, their surrounding will become meat instead."
	gain_text = "Beef of Fulpstation sometimes leaks into our world. And I knew now the pathways it takes."
	next_knowledge = list(/datum/heretic_knowledge/breakfast_ritual)
	route = PATH_FOOL
	mark_type = /datum/status_effect/eldritch/beef


/datum/heretic_knowledge/breakfast_ritual
	name = "Ritual of Knowledge"
	desc = "A transmutation ritual that rewards 4 points and can only be completed once."
	gain_text = "Everything can be a key to a balanced breakfast. I must be wary and wise."
	abstract_parent_type = /datum/heretic_knowledge/knowledge_ritual
	mutually_exclusive = TRUE
	cost = 1
	priority = MAX_KNOWLEDGE_PRIORITY - 10
	var/was_completed = FALSE

	next_knowledge = list(/datum/heretic_knowledge/spell/hamster)
	route = PATH_FOOL

	required_atoms = list(
		/obj/item/food/branrequests = 1,
		/obj/item/reagent_containers/condiment/milk = 1,
		/obj/item/food/meat/bacon = 1,
		/obj/item/food/friedegg = 2,
		/obj/item/reagent_containers/cup/glass/bottle/juice/orangejuice = 1,
	)

	result_atoms = list(/obj/item/food/salad/eldritch)

/datum/heretic_knowledge/breakfast_ritual/on_research(mob/user, datum/antagonist/heretic/our_heretic)
	. = ..()

	var/list/requirements_string = list()

	to_chat(user, span_hierophant("The [name] requires the following:"))
	for(var/obj/item/path as anything in required_atoms)
		var/amount_needed = required_atoms[path]
		to_chat(user, span_hypnophrase("[amount_needed] [initial(path.name)]\s..."))
		requirements_string += "[amount_needed == 1 ? "":"[amount_needed] "][initial(path.name)]\s"

	to_chat(user, span_hierophant("Completing it will reward you 4 points. You can check the knowledge in your Researched Knowledge to be reminded."))

	desc = "Allows you to transmute [english_list(requirements_string)] for 4 points. This can only be completed once."

/datum/heretic_knowledge/breakfast_ritual/can_be_invoked(datum/antagonist/heretic/invoker)
	return !was_completed

/datum/heretic_knowledge/breakfast_ritual/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	return !was_completed

/datum/heretic_knowledge/breakfast_ritual/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()

	was_completed = TRUE
	var/drain_message = "SPECIAL LIMITED EDITION CEREAL."
	to_chat(user, span_boldnotice("[name] completed!"))
	to_chat(user, span_hypnophrase(span_big("[drain_message]")))
	desc += " (Completed!)"
	log_heretic_knowledge("[key_name(user)] completed a [name] at [worldtime2text()].")
	//TODO: custom breakfast memory
	user.add_mob_memory(/datum/memory/heretic_knowledge_ritual)
	return

/datum/heretic_knowledge/spell/hamster
	name = "Domain of the Hamster"
	desc = "Grants you Hamster's Retreat - a spell that can open a portal to a pocket dimension, that anyone can travel through. \
		You can only close this portal from outside, and even then, heathens may exit the dimension, appearing at a random location."
	gain_text = "This world runs and turns only because of a being known as the Hamster. \
		It runs in the Wheel, empowering the Server as long as its eternal task continues..."
	next_knowledge = list(/datum/heretic_knowledge/batong)
	spell_to_add = /datum/action/cooldown/spell/hamster
	cost = 1
	route = PATH_FOOL


/datum/heretic_knowledge/batong
	name = "Charging of the Batong"
	desc = "Allows you to transmute a stunbaton, a toy batong, a recharger and an arm to create a Charged Batong. \
		This weapon fires placebo charges which convince anyone they hit that they have been mutilated. \
		Details of this condition vary from heathen to heathen."
	gain_text = "I asked \"where I charge batong\", and the Mentors answered me, and this is the answer, a horrifying rite..."
	next_knowledge = list(
		/datum/heretic_knowledge/blade_upgrade/fulp,
		/datum/heretic_knowledge/spell/antagroll,
	)
	required_atoms = list(
		/obj/item/melee/baton/security = 1,
		/obj/item/toy/plush/batong = 1,
		/obj/machinery/recharger = 1,
		list(/obj/item/bodypart/arm/left, /obj/item/bodypart/arm/right) = 1,
	)
	result_atoms = list(/obj/item/gun/magic/staff/charged_batong)
	cost = 1
	route = PATH_FOOL


/datum/heretic_knowledge/spell/antagroll
	name = "Technique of the Mentors"
	desc = "Grants you Rolling of the Antagonist, a spell that allows you to roll over and crush."
	gain_text = "Madness of the Mentors knew no bounds. They searched for any way to escape the Basement, \
		even throwing themselves into the gaping expanse of the void... But they did learn this valuable lesson from it..."
	spell_to_add = /datum/action/cooldown/spell/pointed/antagroll
	cost = 1
	route = PATH_FOOL


/datum/heretic_knowledge/blade_upgrade/fulp
	name = "Gravy Blade"
	desc = "Your blades now create slippery tiles when hitting heathens."
	gain_text = "I have found a delicious gravy to go with the beef, and now my enemies shall taste my wrath..."
	next_knowledge = list(/datum/heretic_knowledge/summon/pony)
	route = PATH_FOOL

/datum/heretic_knowledge/blade_upgrade/fulp/do_melee_effects(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	var/turf/location = get_turf(target)
	if(isopenturf(location))
		var/turf/open/ol = location
		ol.MakeSlippery(TURF_WET_LUBE, min_wet_time = 1 SECONDS, wet_time_to_add = 5 SECONDS)
	to_chat(target, span_notice("You can taste gravy."))


/datum/heretic_knowledge/summon/pony
	name = "Power of the Friendship"
	desc = "Allows you to transmute two slabs of meat, a crayon and a heart to create a pony. \
		Ponies come in many variants with unpredictable spells, but they can always crush heathens."
	gain_text = "The Administrators showed me the tools of their craft, \
		and the ways of creation of monsters I would never have imagined before."
	next_knowledge = list(/datum/heretic_knowledge/ultimate/fulp_final)
	required_atoms = list(
		/obj/item/food/meat/slab = 2,
		/obj/item/toy/crayon = 1,
		/obj/item/organ/internal/heart = 1,
	)
	mob_to_summon = /mob/living/basic/heretic_summon/pony/random
	cost = 1
	route = PATH_FOOL
	poll_ignore_define = POLL_IGNORE_HERETIC_MONSTER


/datum/heretic_knowledge/ultimate/fulp_final
	name = "The Fulp Moment"
	desc = "The ascension ritual of the Path of Fool. \
		Bring 3 beefman corpses to a transmutation rune to complete the ritual. \
		When completed, HE ARRIVES. You also get a cake for your hard work."
	gain_text = "So many have walked this path before me... So many have strived to reach this power... \
		Yet they all made a fatal mistake... Performed too many actions in a minute, attracting the attention of the Administrators. \
		But this time is different... I will not join them! \
		The power is mine and He is on my side, all be revealed in the moment of Fulp!!!"
	route = PATH_FOOL

	//let's keep Tom saved
	var/obj/tom_fulp/tom

/datum/heretic_knowledge/ultimate/fulp_final/is_valid_sacrifice(mob/living/carbon/human/sacrifice)
	. = ..()
	if(!.)
		return

	var/datum/dna/sac_dna = sacrifice.has_dna()
	if(!sac_dna)
		return FALSE
	if(istype(sac_dna.species, /datum/species/beefman))
		return TRUE
	return FALSE

/datum/heretic_knowledge/ultimate/fulp_final/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()
	priority_announce(
		text = "[generate_heretic_text()] Fool of fools, [user.real_name], has ascended! The Fulp Moment is upon us! Get some of the cake before it's all devoured! [generate_heretic_text()]",
		title = "[generate_heretic_text()]",
		sound = ANNOUNCER_SPANOMALIES,
		color_override = "pink",
	)

	tom = new /obj/tom_fulp(loc)
	tom.set_master(user)

	RegisterSignal(user, COMSIG_LIVING_DEATH, PROC_REF(on_death))

	//cake
	new /obj/structure/table/wood(loc)
	new /obj/item/food/cake/fulp_ascension(loc)
	new /obj/item/kitchen/fork(loc)

/datum/heretic_knowledge/ultimate/fulp_final/proc/on_death(datum/source)
	SIGNAL_HANDLER

	if(tom)
		qdel(tom)
		tom = null
