/mob/living/basic/heretic_summon/pony
	name = "Pony"
	desc = "The My Little Pony brand describes its characters as ponies. As the name suggests, they usually consist of small colorful \
			ponies. The characters on the various My Little Pony television shows and movies are depicted with varying degrees of \
			fantasy elements, like the ability to speak, fly, and use magic."
	icon = 'fulp_modules/features/antagonists/fulp_heretic/icons/pony.dmi'
	icon_state = "pony"
	gender = NEUTER
	health = 150
	maxHealth = 150
	obj_damage = 60
	melee_damage_lower = 20
	melee_damage_upper = 20
	response_help_continuous = "prods"
	response_help_simple = "prod"
	response_disarm_continuous = "challenges"
	response_disarm_simple = "challenge"
	response_harm_continuous = "clops"
	response_harm_simple = "clops"
	attack_verb_continuous = "uses the power of friendship to kick"
	attack_verb_simple = "kick"
	speak_emote = list("neighs")
	combat_mode = TRUE
	attack_sound = 'sound/weapons/punch1.ogg'
	attack_vis_effect = ATTACK_EFFECT_KICK
	var/list/pony_skins = list(
		"applejack",
		"clownie",
		"dash",
		"fleur",
		"fluttershy",
		"luna",
		"lyra",
		"mac",
		"pinkie",
		"rarity",
		"tia",
		"trixie",
		"twilight",
		"vinyl",
		"whooves",
	)

	var/static/list/actions_to_add = list(
		/datum/action/cooldown/spell/jaunt/ethereal_jaunt/ash/antagroll = BB_GENERIC_ACTION,
	)

/mob/living/basic/heretic_summon/pony/Initialize(mapload)
	. = ..()

	grant_actions_by_list(grantable_spells)


/mob/living/basic/heretic_summon/pony/random

/mob/living/basic/heretic_summon/pony/random/Initialize(mapload)
	icon_state = "[pick(pony_skins)]"
	name = capitalize(icon_state)
	return ..()
