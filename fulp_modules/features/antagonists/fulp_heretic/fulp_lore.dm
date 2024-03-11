/**
 * # The path of fulp.
 *
 * Goes as follows:
 *
 * Things
 */
#define PATH_FOOL "Fool Path"

/datum/heretic_knowledge/limited_amount/starting/base_beef
	name = "The Foolish Butcher"
	desc = "Opens up the Path of the Fool to you. \
		Allows you to transmute any meat and a knife into the beefblade. \
		You can only create two at a time. \
		You can not break it like you would a normal sickly blade, but anyone can take a bite out of it to teleport to a random location."
	gain_text = "I have met a peculiar man today, a man made of beef. He claimed to work his job at fulpstation, and promised to show me around."
	next_knowledge = list(/datum/heretic_knowledge/fulp_grasp)
	required_atoms = list(
		/obj/item/knife = 1,
		/obj/item/food/meat = 1,
	)
	result_atoms = list(/obj/item/melee/sickly_blade/beef)
	route = PATH_FOOL


/datum/heretic_knowledge/fulp_grasp
	name = "Grasp of Bwoink"
	desc = "Your Mansus Grasp will now bwoink the victim."
	gain_text = "The Moderators rule the world of Fulp with their dark knowledge and mastery of the soul... \
		This is just a little piece of their unimaginable power..."
	next_knowledge = list(/datum/heretic_knowledge/spell/antagroll)
	cost = 1
	route = PATH_FOOL

/datum/heretic_knowledge/fulp_grasp/on_gain(mob/user, datum/antagonist/heretic/our_heretic)
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, PROC_REF(on_mansus_grasp))

/datum/heretic_knowledge/fulp_grasp/on_lose(mob/user, datum/antagonist/heretic/our_heretic)
	UnregisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK)

/datum/heretic_knowledge/fulp_grasp/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	//full volume because evil. Maybe too evil? I don't know
	playsound(target, 'sound/effects/adminhelp.ogg', 100)


/datum/heretic_knowledge/spell/antagroll
	name = "Mentors' Basement"
	desc = "Grants you Rolling of the Antagonist, a spell that can only be cast in the vacuum of space. \
		It will render you immaterial and invisible for a random time, allowing you to bypass any obstacles."
	gain_text = "Madness of the Mentors knew no bounds. They searched for any way to escape the Basement, \
		even if that way was straight into the all-encompassing void."
	next_knowledge = list(/datum/heretic_knowledge/mark/beef_mark)
	spell_to_add = /datum/action/cooldown/spell/jaunt/ethereal_jaunt/ash/antagroll
	cost = 1
	route = PATH_FOOL


/datum/heretic_knowledge/mark/beef_mark
	name = "Mark of Beef"
	desc = "Your Mansus Grasp now applies the Mark of Beef. The mark is triggered from an attack with your Beefy Blade. \
		When triggered, the victim will themselves become a beefman."
	gain_text = "The Beefman has showed me the secrets to Fulpstation's all-natural top quality beef, \
		and the ways to conjure it into this plane."
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
	spell_to_add = /datum/action/cooldown/spell/charged/beam/fire_blast
	cost = 1
	route = PATH_FOOL


/datum/heretic_knowledge/batong
	name = "Charging of the Batong"
	desc = "Allows you to transmute a stunbaton, a toy batong, a recharger and an arm to create a Charged Batong. \
		I don't know what it does. I can't think of a funny here."
	gain_text = "I asked \"where I charge batong\", and the Mentors answered me, and this is the answer, a horrifying rite..."
	next_knowledge = list(
		/datum/heretic_knowledge/blade_upgrade/fulp,
		/datum/heretic_knowledge/reroll_targets,
	)
	required_atoms = list(
		/obj/item/melee/baton/security = 1,
		/obj/item/toy/plush/batong = 1,
		/obj/machinery/recharger = 1,
		list(/obj/item/bodypart/arm/left, /obj/item/bodypart/arm/right) = 1,
	)
	result_atoms = list(/obj/item/melee/baton/security/charged_batong)
	cost = 1
	route = PATH_FOOL


/datum/heretic_knowledge/blade_upgrade/fulp
	name = "Gravy Blade"
	desc = "Your blades now create slippery tiles when hitting heathens."
	gain_text = "My enemies shall taste my wrath..."
	next_knowledge = list(/datum/heretic_knowledge/summon/pony)
	route = PATH_FOOL

/datum/heretic_knowledge/blade_upgrade/ash/do_melee_effects(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	var/turf/location = get_turf(target)
	if(isopenturf(location))
		var/turf/open/ol = location
		ol.MakeSlippery(TURF_WET_LUBE, 15 SECONDS, 10 SECONDS)


/datum/heretic_knowledge/summon/pony
	name = "Call of the Herd"
	desc = "Allows you to transmute two right legs and two left legs to create a pony."
	gain_text = "The Administrators showed me the tools of their craft, and the ways of creation of monsters I would never have imagined before."
	next_knowledge = list(/datum/heretic_knowledge/ultimate/fulp_final)
	required_atoms = list(
		/obj/item/bodypart/leg/right = 2,
		/obj/item/bodypart/leg/left = 2,
	)
	mob_to_summon = /mob/living/basic/heretic_summon/pony/random
	cost = 1
	route = PATH_FOOL
	poll_ignore_define = POLL_IGNORE_HERETIC_MONSTER


/datum/heretic_knowledge/ultimate/fulp_final
	name = "The Fulp Moment"
	desc = "The ascension ritual of the Path of Fulp. \
		Bring 3 beefman corpses to a transmutation rune to complete the ritual. \
		When completed, HE ARRIVES"
	gain_text = "Through the power of beef, the hamster answers to only me! This reality but an illusion, true nature be revealed! \
		I SUMMON HIM HERE!!!"
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
		text = "[generate_heretic_text()] The ultimate fool [user.real_name] has ascended! The Fulp Moment is upon us! [generate_heretic_text()]",
		title = "[generate_heretic_text()]",
		sound = ANNOUNCER_SPANOMALIES,
		color_override = "pink",
	)

	tom = new /obj/tom_fulp(loc)
	tom.set_master(user)

	RegisterSignal(user, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/heretic_knowledge/ultimate/fulp_final/proc/on_death(datum/source)
	SIGNAL_HANDLER

	if(tom)
		qdel(tom)
		tom = null
