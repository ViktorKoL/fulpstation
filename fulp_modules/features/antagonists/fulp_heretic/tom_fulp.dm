/obj/narsie/tom_fulp
	name = "Tom Fulp"
	gender = MALE

	var/datum/dimension_theme/theme

/obj/narsie/tom_fulp/Initialize(mapload)
	. = ..()

	SSpoints_of_interest.make_point_of_interest(src)

	singularity = WEAKREF(AddComponent(
		/datum/component/singularity, \
		bsa_targetable = FALSE, \
		consume_callback = CALLBACK(src, PROC_REF(nice_to_meat_you)), \
		consume_range = 12, \
		disregard_failed_movements = TRUE, \
		grav_pull = 10, \
		roaming = FALSE, /* This is set once the animation finishes */ \
		singularity_size = 12, \
	))

	send_to_playing_players(span_narsie("TOM FULP HAS RISEN"))
	sound_to_playing_players('sound/creatures/narsie_rises.ogg')

	theme = new /datum/dimension_theme/meat()

/obj/narsie/tom_fulp/proc/nice_to_meat_you(atom/target)
	if (isturf(target))
		theme.apply_theme(target, show_effect = FALSE)
