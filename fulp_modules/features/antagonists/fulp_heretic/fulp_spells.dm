/datum/action/cooldown/spell/jaunt/ethereal_jaunt/ash/antagroll
	name = "Rolling of the Antagonist"
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
