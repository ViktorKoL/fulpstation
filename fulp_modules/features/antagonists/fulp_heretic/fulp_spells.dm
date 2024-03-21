/datum/action/cooldown/spell/jaunt/ethereal_jaunt/ash/antagroll
	name = "Rolling of the Antagonist (OLD)"
	desc = "A spell that allows you pass unimpeded through some walls. Might be short, might be long, the forces of the Roll are unpredictable."
	invocation = "I wanna antagroll"
	invocation_type = INVOCATION_SHOUT
	button_icon = 'fulp_modules/features/antagonists/fulp_heretic/icons/spells.dmi'
	button_icon_state = "jaunt"
	//I think they deserve to be notified when it ends. I wanted to do the waterphone but it's not in the files and I don't care that much.
	exit_jaunt_sound = 'sound/ambience/antag/thatshowfamiliesworks.ogg'

/datum/action/cooldown/spell/jaunt/ethereal_jaunt/ash/antagroll/before_cast(atom/cast_on)
	. = ..()

	jaunt_duration = rand(1 SECONDS, 15 SECONDS)

/datum/action/cooldown/spell/jaunt/ethereal_jaunt/ash/antagroll/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(isspaceturf(get_turf(owner)) || ismiscturf(get_turf(owner)))
		return TRUE
	if(feedback)
		to_chat(owner, span_warning("You must stand on a space or misc turf!"))
	return FALSE


/datum/action/cooldown/spell/pointed/antagroll
	name = "Rolling of the Antagonist"
	desc = "Call on the forbidden magicks of the Mansus to roll over, crushing anyone in your way. \
		Can be used even in cuffs, because funny."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'fulp_modules/features/antagonists/fulp_heretic/icons/spells.dmi'
	button_icon_state = "jaunt"

	school = SCHOOL_FORBIDDEN
	cooldown_time = 5 SECONDS

	invocation = "I wanna antagroll"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE

	active_msg = span_notice("We prepare to antagroll.")
	deactive_msg = span_notice("Not now, when They might be watching...")

	var/rolling_speed = 0.25 SECONDS

//this is mostly copied from malf AI's tipping spell, adapted slightly
/datum/action/cooldown/spell/pointed/antagroll/cast(atom/cast_on)
	. = ..()

	if(!isturf(owner.loc))
		return FALSE

	if(isliving(owner))
		var/mob/living/living_owner = owner
		if(living_owner.body_position == LYING_DOWN)
			return FALSE

	var/turf/target = get_turf(cast_on)
	if (isnull(target))
		return FALSE

	if (target == owner.loc)
		target.balloon_alert(owner, "can't roll on yourself!")
		return FALSE

	var/picked_dir = get_dir(owner, target)
	if (!picked_dir)
		return FALSE
	var/turf/temp_target = get_step(owner, picked_dir) // we can move during the timer so we cant just pass the ref

	new /obj/effect/temp_visual/telegraphing/vending_machine_tilt(temp_target, rolling_speed)
	owner.balloon_alert_to_viewers("rolling...")
	addtimer(CALLBACK(src, PROC_REF(do_roll_over), picked_dir), rolling_speed)

/datum/action/cooldown/spell/pointed/antagroll/proc/do_roll_over(picked_dir)
	if(!isturf(owner.loc))
		return

	if(isliving(owner))
		var/mob/living/living_owner = owner
		if(living_owner.body_position == LYING_DOWN)
			return

	var/turf/target = get_step(owner, picked_dir) // in case we moved we pass the dir not the target turf

	if (isnull(target))
		return

	. = owner.fall_and_crush(target, 25, 10, null, 5 SECONDS, picked_dir, rotation = 0)

	if(isliving(owner))
		var/mob/living/living_owner = owner
		living_owner.Paralyze(2 SECONDS)

	return


//code partially copied from chameleon projector and adapted
/datum/action/cooldown/spell/chameleon
	name = "Krillusion Veil"
	desc = "Masks you as a shrimp plushie that will mansus grasp anyone who dares touch you."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'fulp_modules/features/toys/icons/toys.dmi'
	button_icon_state = "shrimp"
	cooldown_time = 30 SECONDS

	school = SCHOOL_FORBIDDEN
	spell_requirements = NONE

	var/obj/effect/dummy/shrimp/dummy = FALSE

/datum/action/cooldown/spell/chameleon/can_cast_spell(feedback = TRUE)
	. = ..()

	if(!.)
		return FALSE

	if(isturf(owner.loc) || istype(owner.loc, /obj/structure) || dummy)
		return TRUE
	if(feedback)
		to_chat(owner, span_warning("You can't shrimp while inside something!"))
	return FALSE

/datum/action/cooldown/spell/chameleon/cast(mob/living/user)
	to_chat(world,"starting parent cast")
	. = ..()
	to_chat(world,"finished parent cast as [.]")

	to_chat(world,"toggling, dummy is [dummy]")
	if(dummy)
		to_chat(world,"removing dummy...")
		eject()
		playsound(get_turf(src), 'sound/effects/pop.ogg', 100, TRUE, -6)
		qdel(dummy)
		dummy = null
		to_chat(user, span_notice("We are once again unkrilled."))
	else
		to_chat(world,"creating dummy...")
		playsound(get_turf(src), 'sound/effects/pop.ogg', 100, TRUE, -6)
		dummy = new/obj/effect/dummy/shrimp(user.drop_location())
		dummy.activate(user)
		to_chat(user, span_notice("We shrimp ourselves."))
	user.cancel_camera()

/datum/action/cooldown/spell/chameleon/proc/eject()
	owner.forceMove(dummy.loc)
	owner.reset_perspective(null)

/obj/effect/dummy/shrimp
	name = ""
	desc = ""
	density = FALSE
	var/can_move = 0
	var/obj/item/chameleon/master = null

/obj/effect/dummy/shrimp/proc/activate(mob/M)
	var/obj/item/toy/plush/shrimp/shrimp = /obj/item/toy/plush/shrimp
	appearance = shrimp.appearance

	if(istype(M.buckled, /obj/vehicle))
		var/obj/vehicle/V = M.buckled
		V.unbuckle_mob(M, force = TRUE)
	M.forceMove(src)

/*
/obj/effect/dummy/chameleon/attackby()
	master.disrupt()

/obj/effect/dummy/shrimp/attack_hand(mob/user, list/modifiers)
	master.disrupt()

/obj/effect/dummy/shrimp/attack_animal(mob/user, list/modifiers)
	master.disrupt()

/obj/effect/dummy/shrimp/attack_alien(mob/user, list/modifiers)
	master.disrupt()

/obj/effect/dummy/shrimp/ex_act(S, T)
	master.disrupt()
	return TRUE

/obj/effect/dummy/shrimp/bullet_act()
	. = ..()
	master.disrupt()
*/


/datum/action/cooldown/spell/pointed/ascend_door
	name = "Unhinging Glare"
	desc = "Grants any door sentience, or returns a sentient door to its former self."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "ash_shift"

	school = SCHOOL_FORBIDDEN
	cooldown_time = 15 SECONDS

	invocation = "H' H'LLO H' H'LLO"
	invocation_type = INVOCATION_WHISPER
	spell_requirements = NONE

/datum/action/cooldown/spell/pointed/ascend_door/is_valid_target(atom/cast_on)
	if(HAS_TRAIT(cast_on,TRAIT_UNHINGED_SEARCHING))
		to_chat(owner,span_warning("The door is still searching for its spirit!"))
		return FALSE

	if(istype(cast_on,/obj/machinery/door))
		return TRUE
	to_chat(owner, span_warning("You may only cast [src] on a door!"))
	return FALSE

/datum/action/cooldown/spell/pointed/ascend_door/cast(atom/cast_on)
	. = ..()

	//shouldn't happen
	if(!istype(cast_on,/obj/machinery/door))
		to_chat(owner, span_warning("You may only cast [src] on a door!"))
		return FALSE

	//check whether we are removing an existing spirit or awakening a new one
	if(HAS_TRAIT(cast_on,TRAIT_UNHINGED))
		var/response = tgui_alert(owner, "That door is already unhinged! Do you want to banish its spirit?", "Banish spirit?", list("Yes", "No"))
		if(response == "Yes")
			var/datum/component/spirit_holding/unhinged_door/comp = cast_on.GetComponent(/datum/component/spirit_holding/unhinged_door)
			REMOVE_TRAIT(cast_on,TRAIT_UNHINGED,comp)
			qdel(comp)
			cast_on.balloon_alert(owner, "spirit banished!")
	else
		//following section based on spirit holding component's awakening (since we can't use an airlock in hand)

		if(!(GLOB.ghost_role_flags & GHOSTROLE_STATION_SENTIENCE))
			cast_on.balloon_alert(owner, "spirits are unwilling!")
			to_chat(owner, span_warning("Anomalous otherworldly energies block you from awakening [cast_on]!"))
			return
		cast_on.balloon_alert(owner, "channeling a spirit...")
		var/datum/component/spirit_holding/unhinged_door/added_component = cast_on.AddComponent(/datum/component/spirit_holding/unhinged_door)
		ADD_TRAIT(cast_on,TRAIT_UNHINGED_SEARCHING,added_component)

		var/datum/callback/to_call = CALLBACK(src, PROC_REF(affix_spirit), added_component, owner)
		cast_on.AddComponent(/datum/component/orbit_poll, \
			ignore_key = POLL_IGNORE_HERETIC_MONSTER, \
			job_bans = ROLE_PAI, \
			to_call = to_call, \
			title = "Spirit of [cast_on] at [get_area_name(get_area(cast_on))]", \
		)

/datum/action/cooldown/spell/pointed/ascend_door/proc/affix_spirit(datum/component/spirit_holding/unhinged_door/comp, mob/awakener, mob/dead/observer/ghost)
	comp.affix_spirit(awakener, ghost)

//debug spell
/datum/action/cooldown/spell/hamster
	name = "Go to the shadow realm"
	desc = "Debug haha"
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "mind_gate"

	school = SCHOOL_FORBIDDEN
	spell_requirements = NONE

/datum/action/cooldown/spell/hamster/cast(mob/living/cast_on)
	. = ..()

	var/datum/antagonist/heretic/our_heretic = cast_on.mind?.has_antag_datum(/datum/antagonist/heretic)
	var/obj/effect/landmark/heretic/destination_landmark = GLOB.heretic_sacrifice_landmarks[our_heretic.heretic_path] || GLOB.heretic_sacrifice_landmarks[PATH_START]
	var/turf/destination = get_turf(destination_landmark)
	do_teleport(cast_on, destination, asoundin = 'sound/magic/repulse.ogg', asoundout = 'sound/magic/blind.ogg', no_effects = TRUE, channel = TELEPORT_CHANNEL_MAGIC, forced = TRUE)


//pony versions of wizard spells

/datum/action/cooldown/spell/pointed/barnyardcurse/pony
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"

	school = SCHOOL_FORBIDDEN
	spell_requirements = NONE

/datum/action/cooldown/spell/pointed/projectile/lightningbolt/pony
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"

	school = SCHOOL_FORBIDDEN
	spell_requirements = NONE

/datum/action/cooldown/spell/aoe/knock/pony
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"

	school = SCHOOL_FORBIDDEN
	spell_requirements = NONE

/datum/action/cooldown/spell/conjure/bee/pony
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"

	school = SCHOOL_FORBIDDEN
	spell_requirements = NONE

/datum/action/cooldown/spell/emp/disable_tech/pony
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"

	school = SCHOOL_FORBIDDEN
	spell_requirements = NONE

/datum/action/cooldown/spell/aoe/magic_missile/pony
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"

	school = SCHOOL_FORBIDDEN
	spell_requirements = NONE

/datum/action/cooldown/spell/teleport/area_teleport/wizard/pony
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"

	school = SCHOOL_FORBIDDEN
	spell_requirements = NONE

/datum/action/cooldown/spell/summon_dancefloor/pony
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"

	school = SCHOOL_FORBIDDEN
	spell_requirements = NONE

/datum/action/cooldown/spell/timestop/pony
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"

	school = SCHOOL_FORBIDDEN
	spell_requirements = NONE

