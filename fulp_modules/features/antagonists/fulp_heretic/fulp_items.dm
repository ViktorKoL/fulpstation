/obj/item/melee/sickly_blade/beef
	name = "\improper beefy blade"
	desc = "It's a rag-tag patchwork of beef crudely arranged in the shape of a sickle. \
		You will definitely catch many illnesses if you take a bite..."
	icon_state = "rust_blade"
	inhand_icon_state = "rust_blade"
	after_use_message = "Tom Fulp hears your call..."

	//idk what the meat sound is yet
	//hitsound = 'sound'
	attack_verb_continuous = list("beefs")
	attack_verb_simple = list("beef")

	icon = 'fulp_modules/features/antagonists/fulp_heretic/icons/blade.dmi'
	icon_state = "blade"
	inhand_icon_state = "blade"
	lefthand_file = 'fulp_modules/features/antagonists/fulp_heretic/icons/blade_lefthand.dmi'
	righthand_file = 'fulp_modules/features/antagonists/fulp_heretic/icons/blade_righthand.dmi'

/obj/item/melee/sickly_blade/examine(mob/user)
	. = ..()
	if(!IS_HERETIC_OR_MONSTER(user))
		return

	. += span_notice("You can take a bite out of the blade to teleport to a random, (mostly) safe location.")

/obj/item/melee/sickly_blade/beef/attack(mob/living/M, mob/living/user)
	var/lived = !CAN_SUCCUMB(M)

	. = ..()

	if(lived && CAN_SUCCUMB(M))
		say("I am a quick learner when it comes to throwing and strangling people I see.")

/obj/item/melee/sickly_blade/beef/attack_self(mob/user)
	to_chat(user, span_warning("[src] is too squishy to shatter with hands! Try using your teeth..."))

/obj/item/melee/sickly_blade/beef/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/edible, initial_reagents = list(/datum/reagent/consumable/nutriment = 10), foodtypes = MEAT | GROSS, after_eat = CALLBACK(src, PROC_REF(took_bite)))

/obj/item/melee/sickly_blade/beef/proc/took_bite(mob/eater)
	var/turf/safe_turf = find_safe_turf(zlevels = z, extended_safety_checks = TRUE)
	if(do_teleport(eater, safe_turf, channel = TELEPORT_CHANNEL_MAGIC))
		to_chat(eater, span_warning("As you take a bite of [src], you feel a gust of energy flow through your body. [after_use_message]"))
	else
		to_chat(eater, span_warning("You take a bite of [src], but your plea goes unanswered."))
	//change this to meat sound please, future me
	playsound(src, SFX_SHATTER, 70, TRUE)
