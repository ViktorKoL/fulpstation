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


/datum/action/cooldown/spell/pointed/ascend_door
	name = "Awakening of Doors"
	desc = "A door is a hinged or otherwise movable barrier that allows ingress (entry) into and egress (exit) from an enclosure. The created opening in the wall is a doorway or portal. A door's essential and primary purpose is to provide security by controlling access to the doorway (portal). Conventionally, it is a panel that fits into the doorway of a building, room, or vehicle. Doors are generally made of a material suited to the door's task. They are commonly attached by hinges, but can move by other means, such as slides or counterbalancing."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "ash_shift"

	school = SCHOOL_FORBIDDEN
	cooldown_time = 5 SECONDS

	invocation = "A'I OP'N"
	invocation_type = INVOCATION_WHISPER
	spell_requirements = NONE

/datum/action/cooldown/spell/pointed/ascend_door/is_valid_target(atom/cast_on)
	if(is_type(cast_on,/obj/machinery/door))
		return TRUE
	to_chat(owner, span_warning("You may only cast [src] on a door!"))
	return FALSE
