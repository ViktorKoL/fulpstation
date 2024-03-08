/datum/status_effect/eldritch/beef
	effect_icon_state = "emark1"

/datum/status_effect/eldritch/beef/on_effect()
	if(iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		carbon_owner.set_species(/datum/species/beefman)
		to_chat(owner, span_warning("Congratulations! You've become a beefman."))

	return ..()
