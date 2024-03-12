/obj/item/melee/sickly_blade/beef
	name = "\improper beefy blade"
	desc = "It's a rag-tag patchwork of beef crudely arranged in the shape of a sickle. \
		You will definitely catch many illnesses if you take a bite..."
	icon_state = "rust_blade"
	inhand_icon_state = "rust_blade"
	after_use_message = "Tom Fulp hears your call..."

	hitsound = 'sound/effects/meatslap.ogg'
	attack_verb_continuous = list("beefs")
	attack_verb_simple = list("beef")

	icon = 'fulp_modules/features/antagonists/fulp_heretic/icons/items.dmi'
	icon_state = "blade"
	inhand_icon_state = "blade"
	lefthand_file = 'fulp_modules/features/antagonists/fulp_heretic/icons/blade_lefthand.dmi'
	righthand_file = 'fulp_modules/features/antagonists/fulp_heretic/icons/blade_righthand.dmi'

	//to slice the cake you get when ascending
	tool_behaviour = TOOL_KNIFE

/obj/item/melee/sickly_blade/beef/attack(mob/living/M, mob/living/user)
	var/lived = !CAN_SUCCUMB(M)

	. = ..()

	if(lived && CAN_SUCCUMB(M))
		say("I am a quick learner when it comes to throwing and strangling people I see.")

/obj/item/melee/sickly_blade/beef/attack_self(mob/user)
	to_chat(user, span_warning("[src] is too squishy to shatter with hands! Try using your teeth..."))

/obj/item/melee/sickly_blade/beef/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/edible, initial_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/eldritch = 5), foodtypes = MEAT | GROSS, after_eat = CALLBACK(src, PROC_REF(took_bite)))

/obj/item/melee/sickly_blade/beef/proc/took_bite(mob/eater, mob/feeder)
	var/turf/safe_turf = find_safe_turf(zlevels = z, extended_safety_checks = TRUE)
	if(do_teleport(eater, safe_turf, channel = TELEPORT_CHANNEL_MAGIC))
		if(eater == feeder)
			to_chat(eater, span_warning("As you take a bite of [src], you feel a gust of energy flow through your body. [after_use_message]"))
			feeder.say("This server is out to get me")
		else
			to_chat(eater, span_warning("As you take a bite of [src], you feel a gust of energy flow through your body. Unknown forces grasp you and you wind up somewhere completely different..."))
			feeder.say("GEY AWAY FROM ME YOU GREIFING PRICK!!!!!")
	else
		to_chat(eater, span_warning("You take a bite of [src], but your plea goes unanswered."))

	playsound(src, 'sound/effects/meatslap.ogg', 70, TRUE)

/*
/obj/item/melee/sickly_blade/beef/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, gentle = FALSE, quickstart = TRUE)


/obj/item/melee/sickly_blade/beef/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(isliving(hit_atom))
		took_bite(hit_atom, )
*/

/obj/item/food/salad/eldritch
	name = "4 point pops balanced breakfast"
	desc = "Crunchy, sweetened, eyeball-shaped corn cereal! Best served with bacon, eggs, and orange juice. A balanced breakfast straight from the depths of Mansus, all organically sourced from the Wood."
	icon = 'fulp_modules/features/antagonists/fulp_heretic/icons/items.dmi'
	icon_state = "breakfast"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/eldritch = 5)
	tastes = list("milk" = 1, "cereal" = 1, "bacon" = 1, "egg" = 1, "orange juice" = 1, "Ag'hsj'saje'sh" = 1)
	foodtypes = DAIRY | SUGAR | GRAIN | BREAKFAST | MEAT | ORANGES | FRIED | SUGAR | FRUIT

/obj/item/food/salad/eldritch/examine(mob/user)
	. = ..()
	if(!IS_HERETIC_OR_MONSTER(user))
		return

	. += span_hypnophrase("It's a breakfast cereal. There's barely anything supernatural about it.")


/obj/item/melee/charged_batong
	name = "batong (CHARGED)"
	desc = "A twisted appendage resembling a normal security baton, at a glance. Some kind of charge can be felt in the air around its tip."
	force = 20
	throw_speed = 0.01
	throwforce = 100
	icon = 'fulp_modules/features/antagonists/fulp_heretic/icons/items.dmi'
	icon_state = "batong"


/obj/item/food/cake/fulp_ascension
	name = "ascension cake"
	desc = "Congratulations! We knew you can do it!"
	icon = 'fulp_modules/features/antagonists/fulp_heretic/icons/items.dmi'
	icon_state = "cake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/sprinkles = 5,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/eldritch = 15,
	)
	tastes = list("cake" = 5, "sweetness" = 1, "victory" = 5)
	foodtypes = GRAIN | DAIRY | JUNKFOOD | SUGAR
	slice_type = /obj/item/food/cakeslice/fulp_ascension
	crafting_complexity = FOOD_COMPLEXITY_5

/obj/item/food/cakeslice/fulp_ascension
	name = "ascension cake slice"
	desc = "Share the taste of godhood with your heretic friends."
	icon = 'fulp_modules/features/antagonists/fulp_heretic/icons/items.dmi'
	icon_state = "cake_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/eldritch = 3,
	)
	tastes = list("cake" = 5, "sweetness" = 1, "victory" = 5)
	foodtypes = GRAIN | DAIRY | JUNKFOOD | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_5
