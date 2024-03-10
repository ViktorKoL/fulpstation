/mob/living/basic/heretic_summon/pony
	name = "\improper Eldritch Pony"
	real_name = "Eldritch Pony"
	desc = "A pony."
	icon_state = "raw_prophet"
	icon_living = "raw_prophet"
	melee_damage_lower = 5
	melee_damage_upper = 10
	maxHealth = 50
	health = 50
	/// List of innate abilities we have to add.
	var/static/list/innate_abilities = list(
		/datum/action/cooldown/spell/jaunt/ethereal_jaunt/ash/antagroll = null,
	)
