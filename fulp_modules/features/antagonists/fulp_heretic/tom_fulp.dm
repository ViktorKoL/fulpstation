/obj/tom_fulp
	name = "Tom Fulp"
	gender = MALE
	desc = "Your mind begins to bubble and ooze as it tries to comprehend what it sees."
	icon = 'icons/obj/antags/cult/narsie.dmi'
	icon_state = "narsie"
	anchored = TRUE
	appearance_flags = LONG_GLIDE
	density = FALSE
	plane = MASSIVE_OBJ_PLANE
	light_color = COLOR_RED
	light_power = 0.7
	light_range = 15
	light_range = 6
	move_resist = INFINITY
	obj_flags = CAN_BE_HIT | DANGEROUS_POSSESSION
	pixel_x = -236
	pixel_y = -256
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	flags_1 = SUPERMATTER_IGNORES_1

	var/datum/weakref/singularity

	var/datum/dimension_theme/theme

/obj/tom_fulp/Initialize(mapload)
	. = ..()

	SSpoints_of_interest.make_point_of_interest(src)

	singularity = WEAKREF(AddComponent(
		/datum/component/singularity, \
		bsa_targetable = FALSE, \
		consume_callback = CALLBACK(src, PROC_REF(nice_to_meat_you)), \
		consume_range = 12, \
		disregard_failed_movements = TRUE, \
		grav_pull = 10, \
		roaming = TRUE, \
		singularity_size = 12, \
	))

	send_to_playing_players(span_narsie("TOM FULP HAS RISEN"))
	sound_to_playing_players('sound/creatures/narsie_rises.ogg')

	theme = new /datum/dimension_theme/meat()

/obj/tom_fulp/proc/set_master(mob/master)
	var/datum/component/singularity/singularity_component = singularity.resolve()
	singularity_component.target = master

/obj/tom_fulp/proc/nice_to_meat_you(atom/target)
	if (isturf(target))
		theme.apply_theme(target, show_effect = FALSE)
	if (iscarbon(target))
		var/mob/living/carbon/carbon_victim = target
		var/datum/dna/victim_dna = carbon_victim.has_dna()
		if(victim_dna && !istype(victim_dna.species, /datum/species/beefman))
			carbon_victim.set_species(/datum/species/beefman)

/obj/tom_fulp/process()
	if (prob(10))
		mesmerize()

/obj/tom_fulp/proc/mesmerize()
	for (var/mob/living/carbon/victim in viewers(12, src))
		if (victim.stat == CONSCIOUS)
			if (!IS_HERETIC_OR_MONSTER(victim))
				to_chat(victim, span_cult("You feel conscious thought crumble away in an instant as you gaze upon [src]..."))
				victim.apply_effect(20, EFFECT_STUN)

/obj/tom_fulp/Bump(atom/target)
	var/turf/target_turf = get_turf(target)
	if (target_turf == loc)
		target_turf = get_step(target, target.dir) //please don't slam into a window like a bird, Nar'Sie
	forceMove(target_turf)
